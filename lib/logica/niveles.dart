import 'calaverita.dart';
import 'momia.dart';
import 'motor_juego.dart';
import 'personaje.dart';
import 'rectangulo.dart';

/// Catalogo de niveles: todos reutilizan exactamente el mismo [MotorJuego].
class Niveles {
  static const _nombres = ['Callejón de la Momia', 'Subterráneo de las Momias'];

  static int get total => _nombres.length;

  static String nombre(int indice) => _nombres[indice];

  static MotorJuego crear(int indice) {
    RangeError.checkValidIndex(indice, _nombres);
    return indice == 0 ? _nivel1() : _nivel2();
  }

  static MotorJuego _nivel1() => MotorJuego(
        personaje: Personaje(x: 20, y: 100),
        plataformas: const [
          Rectangulo(x: 0, y: 300, ancho: 2000, alto: 40),
          Rectangulo(x: 300, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 550, y: 160, ancho: 120, alto: 20),
        ],
        momias: [
          Momia(x: 320, y: 268, limiteIzquierdo: 300, limiteDerecho: 420),
          Momia(x: 900, y: 268, limiteIzquierdo: 850, limiteDerecho: 1100),
        ],
        calaveritas: [
          Calaverita(x: 360, y: 180),
          Calaverita(x: 600, y: 120),
          Calaverita(x: 1200, y: 260),
        ],
        posicionMeta: 1900,
        anchoNivel: 2000,
      );

  static MotorJuego _nivel2() => MotorJuego(
        personaje: Personaje(x: 20, y: 100),
        plataformas: const [
          Rectangulo(x: 0, y: 300, ancho: 3200, alto: 40),
          Rectangulo(x: 200, y: 236, ancho: 40, alto: 64), // muro: no se atraviesa de lado
          Rectangulo(x: 330, y: 230, ancho: 120, alto: 20),
          Rectangulo(x: 520, y: 170, ancho: 120, alto: 20),
          Rectangulo(x: 760, y: 230, ancho: 100, alto: 20),
          Rectangulo(x: 1000, y: 200, ancho: 150, alto: 20),
          Rectangulo(x: 1300, y: 140, ancho: 120, alto: 20),
          Rectangulo(x: 1650, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 1950, y: 170, ancho: 150, alto: 20),
          Rectangulo(x: 2300, y: 236, ancho: 40, alto: 64),
          Rectangulo(x: 2450, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 2750, y: 160, ancho: 120, alto: 20),
        ],
        momias: [
          Momia(x: 480, y: 268, limiteIzquierdo: 420, limiteDerecho: 700),
          Momia(x: 900, y: 268, limiteIzquierdo: 880, limiteDerecho: 1150, velocidadX: 3),
          Momia(x: 1450, y: 268, limiteIzquierdo: 1400, limiteDerecho: 1620, velocidadX: 3),
          Momia.vertical(x: 1800, y: 130, limiteArriba: 110, limiteAbajo: 300),
          Momia(x: 2150, y: 268, limiteIzquierdo: 2100, limiteDerecho: 2290, velocidadX: 3),
          Momia(x: 2650, y: 268, limiteIzquierdo: 2600, limiteDerecho: 2900, velocidadX: 3),
        ],
        calaveritas: [
          Calaverita(x: 370, y: 190),
          Calaverita(x: 560, y: 130),
          Calaverita(x: 800, y: 190),
          Calaverita(x: 1060, y: 160),
          Calaverita(x: 1340, y: 100),
          Calaverita(x: 1690, y: 180),
          Calaverita(x: 2000, y: 130),
          Calaverita(x: 2490, y: 180),
          Calaverita(x: 2790, y: 120),
        ],
        posicionMeta: 3100,
        anchoNivel: 3200,
      );
}
