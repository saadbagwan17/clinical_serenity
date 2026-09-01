import 'package:flutter/material.dart';

class PatientDashboard extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDashboard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Serenity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.teal,
            ),

            const SizedBox(height: 16),

            Text(
              'Welcome, ${patient['full_name']}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Patient ID: ${patient['patient_id']}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            _infoCard(
              Icons.phone,
              'Mobile',
              patient['mobile_number'] ?? 'Not available',
            ),

            _infoCard(
              Icons.email,
              'Email',
              patient['email'] ?? 'Not available',
            ),

            _infoCard(
              Icons.cake,
              'Age',
              '${patient['age'] ?? 'Not available'}',
            ),

            _infoCard(
              Icons.bloodtype,
              'Blood Group',
              patient['blood_group'] ?? 'Not available',
            ),

            const SizedBox(height: 25),

            const Text(
              'Health Services',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _serviceCard(
                    Icons.medical_services,
                    'Medical Records',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _serviceCard(
                    Icons.receipt_long,
                    'Prescriptions',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _serviceCard(
                    Icons.calendar_month,
                    'Appointments',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _serviceCard(
                    Icons.monitor_heart,
                    'Health Monitoring',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _serviceCard(
    IconData icon,
    String title,
  ) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

