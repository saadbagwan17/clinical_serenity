import 'package:flutter/material.dart';

class PendingScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const PendingScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pending_actions,
                size: 80,
                color: Colors.orange,
              ),

              const SizedBox(height: 25),

              Text(
                'Hello, ${doctor['full_name']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Your doctor account is currently waiting for admin verification.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),

              const SizedBox(height: 20),

              const Text(
                'You will be able to access your doctor dashboard after your professional credentials are verified.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              Text(
                'Doctor ID: ${doctor['doctor_id']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}