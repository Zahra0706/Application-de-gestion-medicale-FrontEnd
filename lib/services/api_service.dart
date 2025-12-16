import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_request.dart';
import '../models/auth_response.dart';

class ApiService {
  static const String baseUrl = "http://192.168.0.139:8000";
  static const String apiPrefix = "$baseUrl/api";

  Future<AuthResponse> registerPatient(RegisterRequest request) async {
    final url = Uri.parse('$apiPrefix/auth/register/patient/');

    print('URL d\'inscription: $url');
    print('Données envoyées: ${request.toJson()}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    print('Statut de réponse: ${response.statusCode}');
    print('Corps de réponse: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      try {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? errorBody['message'] ?? 'Erreur d\'inscription (${response.statusCode})');
      } catch (e) {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('$apiPrefix/auth/login/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Identifiants incorrects (${response.statusCode})');
    }
  }
}