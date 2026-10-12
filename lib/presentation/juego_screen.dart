import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/almacen_puntaje_prefs.dart';
import '../logica/estado_juego.dart';
import '../logica/mejor_puntaje.dart';
import '../logica/motor_juego.dart';
import '../logica/niveles.dart';
import 'hud_vidas.dart';

class JuegoScreen extends StatefulWidget {
  /// Nivel con el que arranca (0 = nivel 1). Util para depurar y tomar capturas.
  final int nivelInicial;

  /// Posicion horizontal inicial opcional del personaje (solo depuracion).
  final double? xInicial;

  const JuegoScreen({super.key, this.nivelInicial = 0, this.xInicial});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;
  final _mejorPuntaje = GestorMejorPuntaje(AlmacenPuntajePrefs());
  Timer? _bucle;
  double _direccion = 0;
  int _nivel = 0;
  int _acumulado = 0; // puntos de los niveles ya superados

  int get _puntajeTotal => _acumulado + _motor.puntaje;

  @override
  void initState() {
    super.initState();
    _nivel = widget.nivelInicial.clamp(0, Niveles.total - 1);
    _iniciarNivel();
    if (widget.xInicial != null) _motor.personaje.x = widget.xInicial!;
    _iniciarBucle();
    _mejorPuntaje.cargar().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _iniciarNivel() {
    _direccion = 0;
    _motor = Niveles.crear(_nivel);
  }

  void _iniciarBucle() {
    _bucle?.cancel();
    _bucle = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final teclado = HardwareKeyboard.instance;
      var direccion = _direccion;
      if (teclado.isLogicalKeyPressed(LogicalKeyboardKey.arrowLeft) ||
          teclado.isLogicalKeyPressed(LogicalKeyboardKey.keyA)) {
        direccion = -1;
      } else if (teclado.isLogicalKeyPressed(LogicalKeyboardKey.arrowRight) ||
          teclado.isLogicalKeyPressed(LogicalKeyboardKey.keyD)) {
        direccion = 1;
      }
      if (teclado.isLogicalKeyPressed(LogicalKeyboardKey.arrowUp) ||
          teclado.isLogicalKeyPressed(LogicalKeyboardKey.space) ||
          teclado.isLogicalKeyPressed(LogicalKeyboardKey.keyW)) {
        _motor.saltar();
      }
      setState(() => _motor.mover(direccion * 4));
      if (_motor.estado != EstadoJuego.jugando) {
        _bucle?.cancel();
        _terminarNivel();
      }
    });
  }

  @override
  void dispose() {
    _bucle?.cancel();
    super.dispose();
  }

  Future<void> _terminarNivel() async {
    final gano = _motor.estado == EstadoJuego.ganado;
    final esRecord = await _mejorPuntaje.registrar(_puntajeTotal);
    if (!mounted) return;
    setState(() {});
    final hayOtroNivel = _nivel + 1 < Niveles.total;
    final String titulo;
    final String boton;
    if (!gano) {
      titulo = 'Las momias te atraparon';
      boton = 'Reintentar nivel';
    } else if (hayOtroNivel) {
      titulo = '¡Llegaste al Callejón del Beso!';
      boton = 'Siguiente nivel';
    } else {
      titulo = '¡Completaste todos los niveles!';
      boton = 'Jugar de nuevo';
    }
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'resultado',
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
        child: FadeTransition(
          opacity: anim1,
          child: AlertDialog(
            title: Text(titulo),
            content: Text(
              'Puntaje: $_puntajeTotal\nRécord: ${_mejorPuntaje.mejor}'
              '${esRecord ? '\n¡Nuevo récord!' : ''}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (!gano) {
                      // reintenta el mismo nivel conservando lo acumulado antes de entrar
                    } else if (hayOtroNivel) {
                      _acumulado = _puntajeTotal;
                      _nivel++;
                    } else {
                      _acumulado = 0;
                      _nivel = 0;
                    }
                    _iniciarNivel();
                  });
                  _iniciarBucle();
                },
                child: Text(boton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const anchoVentana = 360.0;
    final camaraX = (_motor.personaje.x - anchoVentana / 2)
        .clamp(0.0, _motor.anchoNivel - anchoVentana)
        .toDouble();

    return Scaffold(
      appBar: AppBar(title: Text('Momias de Guanajuato · Nivel ${_nivel + 1}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HudVidas(vidas: _motor.vidas, maximo: 3),
                Text('Puntaje: $_puntajeTotal   Récord: ${_mejorPuntaje.mejor}'),
              ],
            ),
          ),
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  ..._motor.plataformas.map((pl) => Positioned(
                        left: pl.x - camaraX,
                        top: pl.y,
                        child: Container(
                          width: pl.ancho,
                          height: pl.alto,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63),
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )),
                  ..._motor.calaveritas.where((c) => !c.recolectada).map((c) => Positioned(
                        left: c.x - camaraX,
                        top: c.y,
                        child: const Text('\u{1F480}', style: TextStyle(fontSize: 20)),
                      )),
                  ..._motor.momias.where((m) => !m.derrotada).map((m) => Positioned(
                        left: m.x - camaraX,
                        top: m.y,
                        child: Container(
                          width: m.ancho,
                          height: m.alto,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7CCC8),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black38),
                          ),
                          alignment: Alignment.center,
                          child: const Text('\u{1F9DF}', style: TextStyle(fontSize: 18)),
                        ),
                      )),
                  Positioned(
                    left: _motor.personaje.x - camaraX,
                    top: _motor.personaje.y,
                    child: Container(
                      width: _motor.personaje.ancho,
                      height: _motor.personaje.alto,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('\u{1F920}', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  _boton(Icons.arrow_back, () => _direccion = -1, () => _direccion = 0),
                  const SizedBox(width: 12),
                  _boton(Icons.arrow_forward, () => _direccion = 1, () => _direccion = 0),
                ]),
                _boton(Icons.arrow_upward, () => _motor.saltar(), () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _boton(IconData icono, VoidCallback alPresionar, VoidCallback alSoltar) {
    return GestureDetector(
      onTapDown: (_) => alPresionar(),
      onTapUp: (_) => alSoltar(),
      onTapCancel: alSoltar,
      child: CircleAvatar(radius: 28, backgroundColor: Colors.indigo, child: Icon(icono, color: Colors.white)),
    );
  }
}
