import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/auth_view_model.dart';
import 'repositories/auth_repository.dart';
import 'services/auth_service.dart';
import 'services/api_auth_service.dart';
import 'views/auth/login_patient_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = ApiAuthService();
    final AuthRepository authRepository = AuthRepository(authService);
    final AuthViewModel authViewModel = AuthViewModel(authRepository);

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => authViewModel)],
      child: MaterialApp(
        title: 'MedConnect',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginPatientPage(),
      ),
    );
  }
}
