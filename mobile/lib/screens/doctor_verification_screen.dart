import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'doctor_dashboard.dart';

class DoctorVerificationScreen extends StatefulWidget {
  final String doctorId;

  const DoctorVerificationScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorVerificationScreen> createState() =>
      _DoctorVerificationScreenState();
}

class _DoctorVerificationScreenState
    extends State<DoctorVerificationScreen> {

  bool loading = true;
  String status = 'pending';
  String message = 'Checking verification status...';

  @override
  void initState() {
    super.initState();
    checkVerification();
  }

  Future<void> checkVerification() async {
    setState(() {
      loading = true;
    });

    try {
      final result =
          await ApiService.doctorDashboard(widget.doctorId);

      if (!mounted) return;

      final doctor = result['doctor'] ?? result;

      final verificationStatus =
          doctor['verification_status']?.toString() ?? 'pending';

      setState(() {
        status = verificationStatus;
        loading = false;

        if (verificationStatus == 'approved') {
          message = 'Your account has been verified.';
        } else if (verificationStatus == 'rejected') {
          message = 'Your verification request was rejected.';
        } else {
          message = 'Your account is waiting for admin verification.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        message = 'Unable to check verification status.';
      });
    }
  }

  void openDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDashboard(
          doctor: {
            'id': widget.doctorId,
            'verification_status': 'approved',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              children: [

                const Icon(
                  Icons.verified_user,
                  size: 90,
                  color: Colors.teal,
                ),

                const SizedBox(height: 25),

                const Text(
                  'Professional Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Your medical credentials are reviewed by the administrator before dashboard access.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                if (loading)
                  const CircularProgressIndicator()

                else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [

                        Icon(
                          status == 'approved'
                              ? Icons.check_circle
                              : status == 'rejected'
                                  ? Icons.cancel
                                  : Icons.hourglass_top,
                          size: 60,
                          color: status == 'approved'
                              ? Colors.green
                              : status == 'rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: status == 'approved'
                                ? Colors.green
                                : status == 'rejected'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: checkVerification,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'CHECK STATUS',
                      ),
                    ),
                  ),

                  if (status == 'approved') ...[
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: openDashboard,
                        icon: const Icon(Icons.dashboard),
                        label: const Text(
                          'OPEN DOCTOR DASHBOARD',
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
