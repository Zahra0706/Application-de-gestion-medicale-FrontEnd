import 'package:flutter/foundation.dart';
import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class DoctorAuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  DoctorAuthViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authRepository.loginDoctor(email, password);
      // TODO: Save token
      if (_authResponse?.token != null) {
        print('Doctor Token received: ${_authResponse!.token}');
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
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
