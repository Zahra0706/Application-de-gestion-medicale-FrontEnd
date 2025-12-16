import 'package:flutter/foundation.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  // Inscription
  Future<void> registerPatient(RegisterRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authRepository.registerPatient(request);
      // Stocker le token dans SharedPreferences
      if (_authResponse?.token != null) {
        // TODO: Sauvegarder token avec shared_preferences
        print('Token reçu: ${_authResponse!.token}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Connexion
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authRepository.login(email, password);
      if (_authResponse?.token != null) {
        // TODO: Sauvegarder token
        print('Token reçu: ${_authResponse!.token}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}