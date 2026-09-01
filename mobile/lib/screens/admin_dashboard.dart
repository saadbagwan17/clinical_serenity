import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic>? admin;

  const AdminDashboard({
    super.key,
    this.admin,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> pendingDoctors = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPendingDoctors();
  }

  Future<void> loadPendingDoctors() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final doctors = await ApiService.getPendingDoctors();

      if (!mounted) return;

      setState(() {
        pendingDoctors = doctors;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  Future<void> approveDoctor(String doctorId) async {
    try {
      await ApiService.approveDoctor(doctorId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doctor approved successfully'),
        ),
      );

      await loadPendingDoctors();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  Future<void> rejectDoctor(String doctorId) async {
    try {
      await ApiService.rejectDoctor(doctorId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doctor rejected'),
        ),
      );

      await loadPendingDoctors();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: loadPendingDoctors,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadPendingDoctors,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: loadPendingDoctors,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : pendingDoctors.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 180),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.verified_user,
                                  size: 70,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Pending Doctors',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'All doctor verification requests are processed.',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: pendingDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor =
                              Map<String, dynamic>.from(
                            pendingDoctors[index],
                          );

                          final doctorId =
                              doctor['doctor_id']?.toString() ?? '';

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 16,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 28,
                                        child: Icon(
                                          Icons.medical_services,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          doctor['full_name']
                                                  ?.toString() ??
                                              'Doctor',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  Text(
                                    'Doctor ID: $doctorId',
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    'Email: ${doctor['email'] ?? '-'}',
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    'Mobile: ${doctor['mobile_number'] ?? '-'}',
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    'Registration No: ${doctor['medical_registration_number'] ?? '-'}',
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    'Medical Council: ${doctor['state_medical_council'] ?? '-'}',
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    'Specialization: ${doctor['specialization'] ?? '-'}',
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              doctorId.isEmpty
                                                  ? null
                                                  : () =>
                                                      approveDoctor(
                                                        doctorId,
                                                      ),
                                          icon: const Icon(
                                            Icons.check,
                                          ),
                                          label: const Text(
                                            'APPROVE',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed:
                                              doctorId.isEmpty
                                                  ? null
                                                  : () =>
                                                      rejectDoctor(
                                                        doctorId,
                                                      ),
                                          icon: const Icon(
                                            Icons.close,
                                          ),
                                          label: const Text(
                                            'REJECT',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}