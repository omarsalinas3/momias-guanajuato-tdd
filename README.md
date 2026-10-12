# Momias de Guanajuato: La Leyenda

Juego de plataformas en Flutter con física real, construido **100% con TDD** (Desarrollo Móvil Integral, proyecto complementario de práctica TDD). Se sigue el *Manual paso a paso con TDD*.

Un explorador 🤠 cruza los callejones de Guanajuato saltando entre plataformas, esquivando o derrotando momias 🧟 que patrullan, recolectando calaveritas 💀 de azúcar hasta llegar al **Callejón del Beso**.

## Mecánicas

- El personaje cae por gravedad y aterriza sobre plataformas.
- Controles: **← / →** (o A / D) para moverse y **↑ / Espacio / W** para saltar. También hay botones táctiles en pantalla.
- Las momias patrullan entre dos límites y invierten dirección al llegar a ellos.
- Saltar **encima** de una momia la derrota; chocar de lado quita una vida (se regresa al inicio).
- Cada calaverita suma 50 puntos.
- Llegar a la meta gana la partida; quedarse sin las 3 vidas la pierde.

## Arquitectura

Toda la física y las reglas viven en `lib/logica/` como **Dart puro** (sin widgets), probadas con TDD antes de escribir la interfaz.

```
lib/
  logica/
    rectangulo.dart      colisión AABB
    personaje.dart
    momia.dart           patrullaje
    calaverita.dart
    motor_fisica.dart    gravedad, salto, aterrizaje, límites, meta
    motor_combate.dart   stomp vs. golpe
    estado_juego.dart
    motor_juego.dart     orquesta todo el bucle
  presentation/
    juego_screen.dart    cámara lateral, sprites, controles
  main.dart
test/                    5 archivos, 23 pruebas
```

## TDD: las 10 rondas (Rojo → Verde)

| Ronda | Tema | Archivo de prueba |
|---|---|---|
| 1 | Colisión entre rectángulos (AABB) | `rectangulo_test.dart` |
| 2 | Gravedad y salto | `motor_fisica_test.dart` |
| 3 | Aterrizar sobre una plataforma | `motor_fisica_test.dart` |
| 4 | Movimiento horizontal con límites | `motor_fisica_test.dart` |
| 5 | La momia patrulla entre dos límites | `momia_test.dart` |
| 6 | Combate: stomp vs. golpe | `motor_combate_test.dart` |
| 7 | Recolectar calaveritas | `motor_juego_test.dart` |
| 8 | Detectar la meta | `motor_fisica_test.dart` |
| 9 | Vidas y Game Over | `motor_juego_test.dart` |
| 10 | `MotorJuego` + prueba de integración (ganar) | `motor_juego_test.dart` |

Resultado de `flutter test`: **23 pruebas, todas en verde**.

### Ajustes respecto al manual

Algunos datos de prueba del manual no podían pasar tal cual y se corrigieron:

- Prueba de aterrizaje: `y: 90` ya dejaba el pie dentro de la plataforma; se usó `y: 70` con `yAnterior: 65`.
- Prueba de stomp: `y: 68` no producía colisión; se usó `y: 70`.
- `Calaverita` es mutable, por lo que no se declara con `const` en el nivel.
- `clamp` devuelve `num`; se agregó `.toDouble()` en la cámara.
- Se agregó control por teclado (el manual solo traía botones táctiles).

## Capturas de pantalla

| Inicio | Saltando y calaverita (50 pts) |
|---|---|
| ![Inicio](docs/capturas/1_inicio.png) | ![Saltando](docs/capturas/2_saltando_y_calaverita.png) |

| Vida perdida (Vidas: 2) | Victoria: Callejón del Beso |
|---|---|
| ![Vida perdida](docs/capturas/3_vida_perdida.png) | ![Victoria](docs/capturas/4_victoria.png) |

| Game Over (Vidas: 0) |
|---|
| ![Game Over](docs/capturas/5_game_over.png) |

## Cómo ejecutar

```bash
flutter pub get
flutter test
flutter run -d chrome
```

## Retos de extensión (pendientes)

Colisión lateral con plataformas, corazones en el HUD, momia vertical, mejor puntaje con `shared_preferences` y un segundo nivel.
