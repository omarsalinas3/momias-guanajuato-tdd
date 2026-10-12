import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momias_guanajuato/presentation/hud_vidas.dart';

Widget _app(int vidas) => MaterialApp(home: Scaffold(body: HudVidas(vidas: vidas, maximo: 3)));

void main() {
  testWidgets('con 3 vidas se muestran 3 corazones llenos', (tester) async {
    await tester.pumpWidget(_app(3));
    expect(find.byIcon(Icons.favorite), findsNWidgets(3));
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });

  testWidgets('con 1 vida se muestra 1 corazon lleno y 2 vacios', (tester) async {
    await tester.pumpWidget(_app(1));
    expect(find.byIcon(Icons.favorite), findsNWidgets(1));
    expect(find.byIcon(Icons.favorite_border), findsNWidgets(2));
  });

  testWidgets('con 0 vidas todos los corazones estan vacios', (tester) async {
    await tester.pumpWidget(_app(0));
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsNWidgets(3));
  });
}
