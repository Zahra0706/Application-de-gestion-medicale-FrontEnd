import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/mock_auth_service.dart';
import 'repositories/auth_repository.dart';
import 'view_models/auth_view_model.dart';
import 'views/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation des dépendances (Dependency Injection)
    final mockAuthService = MockAuthService();
    final authRepository = AuthRepository(mockAuthService);
    final authViewModel = AuthViewModel(authRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authViewModel),
        // Ajouter d'autres ViewModels ici plus tard
      ],
      child: MaterialApp(
        title: 'MedConnect Patient',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const RegisterScreen(), // Commencez par l'inscription
        // home: const LoginScreen(), // Ou par la connexion
      ),
    );
  }
}