import 'package:get/get.dart';

class TranslationsApp extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'admin_dashboard': 'Admin Dashboard',
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'login_button': 'Login',
      'error': 'Error',
      'empty_fields': 'Email and password cannot be empty',
      'invalid_credentials': 'Invalid email or password',
      'error_occurred': 'An error occurred',
    },
    'es': {
      'admin_dashboard': 'Panel de Administrador',
      'login': 'Iniciar sesión',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'enter_email': 'Ingrese su correo electrónico',
      'enter_password': 'Ingrese su contraseña',
      'login_button': 'Iniciar sesión',
      'error': 'Error',
      'empty_fields': 'El correo electrónico y la contraseña no pueden estar vacíos',
      'invalid_credentials': 'Correo electrónico o contraseña no válidos',
      'error_occurred': 'Ocurrió un error',
    },
  };
}
