import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // =========================================================
  // PATIENT LOGIN
  // =========================================================

  static Future<Map<String, dynamic>> patientLogin({
    String? email,
    String? mobileNumber,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (email != null && email.isNotEmpty) 'email': email,
        if (mobileNumber != null && mobileNumber.isNotEmpty)
          'mobile_number': mobileNumber,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Patient login failed',
    );
  }

  // =========================================================
  // PATIENT SIGNUP
  // =========================================================

  static Future<Map<String, dynamic>> patientSignup({
    required String fullName,
    String? email,
    required String mobileNumber,
    String? address,
    int? age,
    double? height,
    double? weight,
    String? bloodGroup,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': fullName,
        if (email != null && email.isNotEmpty)
          'email': email,
        'mobile_number': mobileNumber,
        if (address != null && address.isNotEmpty)
          'address': address,
        if (age != null) 'age': age,
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
        if (bloodGroup != null && bloodGroup.isNotEmpty)
          'blood_group': bloodGroup,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Patient signup failed',
    );
  }

  // =========================================================
  // DOCTOR LOGIN
  // =========================================================

  static Future<Map<String, dynamic>> doctorLogin({
    String? email,
    String? mobileNumber,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctors/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (email != null && email.isNotEmpty)
          'email': email,
        if (mobileNumber != null && mobileNumber.isNotEmpty)
          'mobile_number': mobileNumber,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Doctor login failed',
    );
  }

  // =========================================================
  // DOCTOR SIGNUP
  // =========================================================

  static Future<Map<String, dynamic>> doctorSignup({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
    required String confirmPassword,
    required String medicalRegistrationNumber,
    required String stateMedicalCouncil,
    required String specialization,
    String? qualifications,
    int? yearsOfExperience,
    String? languages,
    String? bio,
    String? hospitalName,
    String? address,
    required bool termsAccepted,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctors/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'confirm_password': confirmPassword,
        'medical_registration_number':
            medicalRegistrationNumber,
        'state_medical_council':
            stateMedicalCouncil,
        'specialization': specialization,
        if (qualifications != null &&
            qualifications.isNotEmpty)
          'qualifications': qualifications,
        if (yearsOfExperience != null)
          'years_of_experience': yearsOfExperience,
        if (languages != null && languages.isNotEmpty)
          'languages': languages,
        if (bio != null && bio.isNotEmpty)
          'bio': bio,
        if (hospitalName != null &&
            hospitalName.isNotEmpty)
          'hospital_name': hospitalName,
        if (address != null && address.isNotEmpty)
          'address': address,
        'terms_accepted': termsAccepted,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Doctor signup failed',
    );
  }

  // =========================================================
  // DOCTOR DASHBOARD
  // =========================================================

  static Future<Map<String, dynamic>> doctorDashboard(
    String doctorId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/doctors/dashboard/$doctorId',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Unable to load doctor dashboard',
    );
  }

  
static Future<Map<String, dynamic>> adminLogin({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/admin/login'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode >= 200 &&
      response.statusCode < 300) {
    return Map<String, dynamic>.from(data);
  }

  throw Exception(
    data['detail'] ?? 'Admin login failed',
  );
}
  // =========================================================
  // GET PENDING DOCTORS
  // =========================================================

  static Future<List<dynamic>> getPendingDoctors() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/doctors/pending'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return List<dynamic>.from(
        data['doctors'] ?? [],
      );
    }

    throw Exception(
      data['detail'] ?? 'Unable to load pending doctors',
    );
  }

  // =========================================================
  // GET SINGLE DOCTOR
  // =========================================================

  static Future<Map<String, dynamic>> getDoctor(
    String doctorId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/admin/doctors/$doctorId',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Unable to load doctor',
    );
  }

  // =========================================================
  // APPROVE DOCTOR
  // =========================================================

  static Future<Map<String, dynamic>> approveDoctor(
    String doctorId,
  ) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/admin/doctors/$doctorId/approve',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Unable to approve doctor',
    );
  }

  // =========================================================
  // REJECT DOCTOR
  // =========================================================

  static Future<Map<String, dynamic>> rejectDoctor(
    String doctorId,
  ) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/admin/doctors/$doctorId/reject',
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data['detail'] ?? 'Unable to reject doctor',
    );
  }
}
