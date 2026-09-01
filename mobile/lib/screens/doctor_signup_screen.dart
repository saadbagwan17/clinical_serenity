import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final registrationController = TextEditingController();
  final councilController = TextEditingController();
  final specializationController = TextEditingController();
  final qualificationsController = TextEditingController();
  final experienceController = TextEditingController();
  final hospitalController = TextEditingController();
  final addressController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool termsAccepted = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    registrationController.dispose();
    councilController.dispose();
    specializationController.dispose();
    qualificationsController.dispose();
    experienceController.dispose();
    hospitalController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and privacy policy'),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final result = await ApiService.doctorSignup(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        medicalRegistrationNumber:
            registrationController.text.trim(),
        stateMedicalCouncil: councilController.text.trim(),
        specialization: specializationController.text.trim(),
        qualifications: qualificationsController.text.trim(),
        yearsOfExperience:
            int.tryParse(experienceController.text.trim()),
        hospitalName: hospitalController.text.trim(),
        address: addressController.text.trim(),
        termsAccepted: termsAccepted,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Signup successful. Doctor ID: ${result['doctor_id'] ?? 'created'}',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
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
        title: const Text('Doctor Sign Up'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 70,
                      color: Colors.teal,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Create Doctor Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(
                      controller: fullNameController,
                      decoration: decoration(
                        'Full Name',
                        Icons.person,
                      ),
                      validator: requiredField,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: decoration(
                        'Email',
                        Icons.email,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: decoration(
                        'Mobile Number',
                        Icons.phone,
                      ),
                      validator: requiredField,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: registrationController,
                      decoration: decoration(
                        'Medical Registration Number',
                        Icons.badge,
                      ),
                      validator: requiredField,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: councilController,
                      decoration: decoration(
                        'State Medical Council',
                        Icons.account_balance,
                      ),
                      validator: requiredField,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: specializationController,
                      decoration: decoration(
                        'Specialization',
                        Icons.local_hospital,
                      ),
                      validator: requiredField,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: qualificationsController,
                      decoration: decoration(
                        'Qualifications',
                        Icons.school,
                      ),
                      validator: requiredField,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: experienceController,
                      keyboardType: TextInputType.number,
                      decoration: decoration(
                        'Years of Experience',
                        Icons.work,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: hospitalController,
                      decoration: decoration(
                        'Hospital / Clinic',
                        Icons.business,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: addressController,
                      maxLines: 2,
                      decoration: decoration(
                        'Address',
                        Icons.location_on,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: decoration(
                        'Password',
                        Icons.lock,
                      ).copyWith(
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

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: decoration(
                        'Confirm Password',
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    CheckboxListTile(
                      value: termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          termsAccepted = value ?? false;
                        });
                      },
                      title: const Text(
                        'I accept the Terms and Privacy Policy',
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity:
                          ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : signup,
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'CREATE DOCTOR ACCOUNT',
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

  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
