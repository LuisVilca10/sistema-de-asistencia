import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/evento_api.dart';
import 'package:audioplayers/audioplayers.dart';


class RuletaPage extends StatefulWidget {
  final int eventoId;

  const RuletaPage({super.key, required this.eventoId});

  @override
  State<RuletaPage> createState() => _RuletaPageState();
}

class _RuletaPageState extends State<RuletaPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _idleController;
  late Animation<double> _idleAnimation;
  Animation<double>? _animation;

  List<Map<String, dynamic>> asistentes = [];
  double currentAngle = 0;
  bool _dialogShown = false;
  final _random = Random();
  final player = AudioPlayer(); //

  @override
  void initState() {
    super.initState();
    _fetchAsistentes();

    // Idle rotation (ruleta gira sola lentamente)
    _idleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    _idleAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_idleController)
      ..addListener(() {
        setState(() {
          currentAngle = _idleAnimation.value % (2 * pi);
        });
      });

    _mainController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );
  }

  Future<void> _fetchAsistentes() async {
    final data = await EventoApi().listarAsistentesPorEvento(widget.eventoId);
    setState(() {
      asistentes = data
          .map((e) => {
                'dni': e['dni'].toString(),
                'nombre': e['nombre'] ?? 'Sin Nombre',
              })
          .toList();
    });
  }

  void _girarRuleta() async {
    if (asistentes.isEmpty || _mainController.isAnimating) return;

    _dialogShown = false;
    _idleController.stop();

    // Reproducir sonido
    await player.play(AssetSource('sounds/spin.mp3'));

    final vueltas = _random.nextInt(8) + 25;
    final anguloFinal = _random.nextDouble() * 2 * pi;
    final anguloTotal = vueltas * 2 * pi + anguloFinal;

    _animation = Tween<double>(
      begin: currentAngle,
      end: currentAngle + anguloTotal,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutCubic,
    ))
      ..addListener(() {
        setState(() {
          currentAngle = _animation!.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_dialogShown && mounted) {
          _dialogShown = true;
          player.stop(); // Detener el sonido cuando termina el giro
          final ganador = _obtenerGanador();
          _mostrarGanador(ganador);
        }
      });

    _mainController.reset();
    _mainController.forward();
  }

  Map<String, dynamic> _obtenerGanador() {
    if (asistentes.isEmpty) return {};

    final anglePerSegment = 2 * pi / asistentes.length;
    double adjustedAngle = (currentAngle + pi / 4) % (2 * pi);
    if (adjustedAngle < 0) adjustedAngle += 2 * pi;

    int index =
        ((2 * pi - adjustedAngle) / anglePerSegment).floor() % asistentes.length;

    return asistentes[index];
  }

  void _mostrarGanador(Map<String, dynamic> ganador) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text("🎉 Ganador"),
        content: Text("El ganador es:\n${ganador['nombre']}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text("Cerrar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                currentAngle = 0;
              });
              _idleController.repeat();
            },
            child: Text("Nuevo Sorteo"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _idleController.dispose();
    player.dispose(); // Liberar recurso
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorteo Ruleta'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: asistentes.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando participantes...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Participantes: ${asistentes.length}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: currentAngle,
                        child: CustomPaint(
                          size: Size(size, size),
                          painter: RuletaPainter(asistentes),
                        ),
                      ),
                      Positioned(
                        top: size * 0.02,
                        child: Icon(Icons.arrow_drop_down, size: 40),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: Icon(Icons.casino),
                    label: Text('Girar Ruleta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _mainController.isAnimating ? Colors.grey : Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: _mainController.isAnimating ? null : _girarRuleta,
                  ),
                  if (_mainController.isAnimating) ...[
                    SizedBox(height: 16),
                    Text(
                      '¡Girando...!',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class RuletaPainter extends CustomPainter {
  final List<Map<String, dynamic>> asistentes;

  RuletaPainter(this.asistentes);

  @override
  void paint(Canvas canvas, Size size) {
    if (asistentes.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final anglePerSegment = 2 * pi / asistentes.length;
    final textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    for (int i = 0; i < asistentes.length; i++) {
      final startAngle = -pi / 4 + (i * anglePerSegment);
      paint.color = Colors.primaries[i % Colors.primaries.length].shade300;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(Rect.fromCircle(center: center, radius: radius), startAngle, anglePerSegment, false)
        ..close();

      canvas.drawPath(path, paint);

      final textAngle = startAngle + anglePerSegment / 2;
      final textOffset = Offset(
        center.dx + (radius / 1.5) * cos(textAngle),
        center.dy + (radius / 1.5) * sin(textAngle),
      );

      textPainter.text = TextSpan(
        text: asistentes[i]['nombre'],
        style: TextStyle(fontSize: 11, color: Colors.white),
      );
      textPainter.layout();
      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);
      canvas.rotate(textAngle);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
