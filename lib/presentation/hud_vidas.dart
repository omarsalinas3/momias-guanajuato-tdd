import 'package:flutter/material.dart';

class HudVidas extends StatelessWidget {
  final int vidas;
  final int maximo;

  const HudVidas({super.key, required this.vidas, this.maximo = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maximo, (i) {
        final llena = i < vidas;
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            llena ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: 22,
          ),
        );
      }),
    );
  }
}
