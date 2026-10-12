import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/logica/momia.dart';

void main() {
  test('la momia vertical baja mientras no llegue al limite inferior', () {
    final momia = Momia.vertical(x: 100, y: 200, limiteArriba: 100, limiteAbajo: 300, velocidadY: 2);
    momia.patrullar();
    expect(momia.y, 202);
    expect(momia.x, 100);
  });

  test('la momia vertical invierte direccion al llegar al limite inferior', () {
    final momia = Momia.vertical(x: 100, y: 265, limiteArriba: 100, limiteAbajo: 300, velocidadY: 2);
    momia.patrullar(); // y=267, borde inferior 299
    momia.patrullar(); // y=269, borde inferior 301: paso el limite
    expect(momia.velocidadY, -2);
    expect(momia.y, 300 - momia.alto);
  });

  test('la momia vertical invierte direccion al llegar al limite superior', () {
    final momia = Momia.vertical(x: 100, y: 101, limiteArriba: 100, limiteAbajo: 300, velocidadY: -2);
    momia.patrullar();
    expect(momia.velocidadY, 2);
    expect(momia.y, 100);
  });

  test('la momia vertical no se mueve en horizontal', () {
    final momia = Momia.vertical(x: 100, y: 200, limiteArriba: 100, limiteAbajo: 300);
    for (var i = 0; i < 50; i++) {
      momia.patrullar();
    }
    expect(momia.x, 100);
  });

  test('una momia vertical derrotada no se mueve', () {
    final momia = Momia.vertical(x: 100, y: 200, limiteArriba: 100, limiteAbajo: 300)..derrotada = true;
    momia.patrullar();
    expect(momia.y, 200);
  });

  test('la momia horizontal de siempre no se mueve en vertical', () {
    final momia = Momia(x: 100, y: 200, limiteIzquierdo: 50, limiteDerecho: 300);
    momia.patrullar();
    expect(momia.y, 200);
  });
}
