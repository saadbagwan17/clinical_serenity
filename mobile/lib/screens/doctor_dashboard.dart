import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DoctorDashboard extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorDashboard({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  Map<String, dynamic>? doctor;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final doctorId = widget.doctor['doctor_id'].toString();

      final result = await ApiService.doctorDashboard(doctorId);

      if (!mounted) return;

      if (result['status'] == 'success') {
        setState(() {
          doctor = Map<String, dynamic>.from(result['doctor']);
          loading = false;
        });
      } else {
        setState(() {
          error = result['message'] ?? 'Dashboard unavailable';
          loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Doctor Dashboard'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.pending_actions,
                  size: 70,
                ),
                const SizedBox(height: 20),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                      error = null;
                    });
                    loadDashboard();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final d = doctor!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loading = true;
              });
              loadDashboard();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        child: Icon(
                          Icons.medical_services,
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. ${d['full_name']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              d['specialization'] ??
                                  'Doctor',
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'ID: ${d['doctor_id']}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Professional Information',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _info(
                Icons.badge,
                'Medical Registration',
                d['medical_registration_number'],
              ),

              _info(
                Icons.account_balance,
                'State Medical Council',
                d['state_medical_council'],
              ),

              _info(
                Icons.school,
                'Qualifications',
                d['qualifications'],
              ),

              _info(
                Icons.work,
                'Experience',
                '${d['years_of_experience'] ?? 0} years',
              ),

              _info(
                Icons.local_hospital,
                'Hospital',
                d['hospital_name'],
              ),

              _info(
                Icons.location_on,
                'Address',
                d['address'],
              ),

              const SizedBox(height: 25),

              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _stat(
                      Icons.people,
                      'Patients',
                      '0',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _stat(
                      Icons.calendar_month,
                      'Appointments',
                      '0',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _stat(
                      Icons.medication,
                      'Prescriptions',
                      '0',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _stat(
                      Icons.description,
                      'Records',
                      '0',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(
    IconData icon,
    String title,
    dynamic value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value?.toString() ?? 'Not provided',
        ),
      ),
    );
  }

  Widget _stat(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 35),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
