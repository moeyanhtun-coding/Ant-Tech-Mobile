import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

class ScanAttendancePage extends StatefulWidget {
  final String employeeGUID;

  const ScanAttendancePage({super.key, required this.employeeGUID});

  @override
  State<ScanAttendancePage> createState() => _ScanAttendancePageState();
}

class _ScanAttendancePageState extends State<ScanAttendancePage> {
  final MobileScannerController controller = MobileScannerController();
  bool _hasStarted = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    if (cameraStatus.isGranted && locationStatus.isGranted) {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location services are disabled. Please enable GPS in settings.',
              ),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }

      setState(() {
        _hasStarted = true;
      });
    } else {
      if (mounted) {
        String message = 'Camera and Location permissions are required';
        if (!cameraStatus.isGranted && !locationStatus.isGranted) {
          message = 'Camera and Location permissions are required';
        } else if (!cameraStatus.isGranted) {
          message = 'Camera permission is required';
        } else {
          message = 'Location permission is required';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          _isProcessing = true;
        });

        try {
          // Get high-accuracy position
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: const Duration(seconds: 15),
          );
          log('Raw Lat: ${position.latitude.toString()}');
          log('Raw Long: ${position.longitude.toString()}');
          if (!mounted) return;

          // The QR code contains the LocationGUID (and now dynamic token info from the backend)
          context.read<AttendanceBloc>().add(
            ScanQRCodeRequested(
              employeeGUID: widget.employeeGUID,
              locationGUID: code,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
        } catch (e) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error getting location: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state.qrScanMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.qrScanMessage!),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to refresh list
        } else if (state.qrScanError != null) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.qrScanError!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Scan Attendance QR',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (_hasStarted)
              MobileScanner(controller: controller, onDetect: _onDetect),

            // Scanner Overlay
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isProcessing
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : null,
              ),
            ),

            // Instructions
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Align QR code within the frame',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),

            // Flash toggle
            Positioned(
              top: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: ValueListenableBuilder<MobileScannerState>(
                    valueListenable: controller,
                    builder: (context, state, child) {
                      switch (state.torchState) {
                        case TorchState.off:
                          return const Icon(
                            Icons.flash_off_rounded,
                            color: Colors.white,
                          );
                        case TorchState.on:
                          return const Icon(
                            Icons.flash_on_rounded,
                            color: Colors.yellow,
                          );
                        default:
                          return const Icon(
                            Icons.flash_off_rounded,
                            color: Colors.grey,
                          );
                      }
                    },
                  ),
                  onPressed: () => controller.toggleTorch(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
