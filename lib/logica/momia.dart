import 'rectangulo.dart';

class Momia {
  double x;
  double y;
  final double ancho = 32;
  final double alto = 32;
  double velocidadX;
  double velocidadY;
  final double limiteIzquierdo;
  final double limiteDerecho;
  final double? limiteArriba;
  final double? limiteAbajo;
  bool derrotada = false;

  Momia({
    required this.x,
    required this.y,
    required this.limiteIzquierdo,
    required this.limiteDerecho,
    this.velocidadX = 2,
  })  : velocidadY = 0,
        limiteArriba = null,
        limiteAbajo = null;

  /// Momia que sube y baja entre [limiteArriba] y [limiteAbajo] sin moverse en horizontal.
  Momia.vertical({
    required this.x,
    required this.y,
    required double this.limiteArriba,
    required double this.limiteAbajo,
    this.velocidadY = 2,
  })  : velocidadX = 0,
        limiteIzquierdo = x,
        limiteDerecho = x + 32;

  Rectangulo get rectangulo => Rectangulo(x: x, y: y, ancho: ancho, alto: alto);

  void patrullar() {
    if (derrotada) return;
    if (velocidadX != 0) _patrullarHorizontal();
    if (limiteArriba != null && limiteAbajo != null) _patrullarVertical();
  }

  void _patrullarHorizontal() {
    x += velocidadX;
    if (x <= limiteIzquierdo) {
      x = limiteIzquierdo;
      velocidadX = velocidadX.abs();
    } else if (x + ancho >= limiteDerecho) {
      x = limiteDerecho - ancho;
      velocidadX = -velocidadX.abs();
    }
  }

  void _patrullarVertical() {
    y += velocidadY;
    if (y <= limiteArriba!) {
      y = limiteArriba!;
      velocidadY = velocidadY.abs();
    } else if (y + alto >= limiteAbajo!) {
      y = limiteAbajo! - alto;
      velocidadY = -velocidadY.abs();
    }
  }
}
