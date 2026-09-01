import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PatientSignupScreen extends StatefulWidget {
  const PatientSignupScreen({super.key});

  @override
  State<PatientSignupScreen> createState() => _PatientSignupScreenState();
}

class _PatientSignupScreenState extends State<PatientSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodGroupController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {
      final result = await ApiService.patientSignup(
        fullName: nameController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        address: addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
        age: int.tryParse(ageController.text.trim()),
        height: double.tryParse(heightController.text.trim()),
        weight: double.tryParse(weightController.text.trim()),
        bloodGroup: bloodGroupController.text.trim().isEmpty
            ? null
            : bloodGroupController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully. Patient ID: ${result['patient_id']}',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  InputDecoration decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Sign Up'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.person_add,
                      size: 65,
                      color: Colors.teal,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Create Patient Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: nameController,
                      decoration: decoration(
                        'Full Name',
                        Icons.person,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'Enter your full name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: emailController,
                      decoration: decoration(
                        'Email',
                        Icons.email,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: decoration(
                        'Mobile Number',
                        Icons.phone,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Enter a valid mobile number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: addressController,
                      decoration: decoration(
                        'Address',
                        Icons.location_on,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: decoration(
                        'Age',
                        Icons.cake,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: decoration(
                        'Height (cm)',
                        Icons.height,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: decoration(
                        'Weight (kg)',
                        Icons.monitor_weight,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: bloodGroupController,
                      decoration: decoration(
                        'Blood Group',
                        Icons.bloodtype,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : signup,
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'CREATE ACCOUNT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
