import 'package:flutter/material.dart';
import 'presentation/juego_screen.dart';

void main() => runApp(const MomiasApp());

class MomiasApp extends StatelessWidget {
  const MomiasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Parametros opcionales en web: ?nivel=2&x=1700 (solo para depurar / capturas).
    final query = Uri.base.queryParameters;
    final nivel = (int.tryParse(query['nivel'] ?? '') ?? 1) - 1;
    final x = double.tryParse(query['x'] ?? '');
    return MaterialApp(
      title: 'Momias de Guanajuato',
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true),
      home: JuegoScreen(nivelInicial: nivel, xInicial: x),
    );
  }
}
