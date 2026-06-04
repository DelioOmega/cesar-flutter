import 'package:flutter/material.dart';
import '../presentation/screens/PrincipalScreen.dart';
import '../presentation/screens/registro_screen.dart';
 

class AppRoutes {
  static const home = '/';
  static const registro = '/registro';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const PrincipalScreen(),
    registro: (_) => const RegistroScreen(),
  };
}
// static , no es es necesario crear un objeto para acceder a esos recursos