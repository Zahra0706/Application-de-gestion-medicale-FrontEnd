import '../models/register_request.dart';
import '../models/auth_response.dart';

abstract class AuthService {
  Future<AuthResponse> registerPatient(RegisterRequest request);
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
}