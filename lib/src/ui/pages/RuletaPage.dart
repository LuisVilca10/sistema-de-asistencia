import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/evento_api.dart';

class RuletaPage extends StatefulWidget {
  final int eventoId;

  const RuletaPage({super.key, required this.eventoId});

  @override
  State<RuletaPage> createState() => _RuletaPageState();
}

class _RuletaPageState extends State<RuletaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<String> dnIs = [];
  double currentAngle = 0;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _fetchAsistentes();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  Future<void> _fetchAsistentes() async {
    final data = await EventoApi().listarAsistentesPorEvento(widget.eventoId);
    setState(() {
      dnIs = data.map((e) => e['dni'].toString()).toList();
    });
  }

  void _girarRuleta() {
    final vueltas = _random.nextInt(4) + 3;
    final destino = _random.nextDouble() * 2 * pi;

    _animation = Tween<double>(
      begin: currentAngle,
      end: vueltas * 2 * pi + destino,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          currentAngle = _animation.value % (2 * pi);
          final ganador = _obtenerGanador();
          _mostrarGanador(ganador);
        }
      });

    _controller.reset();
    _controller.forward();
  }

  String _obtenerGanador() {
    final porcion = 2 * pi / dnIs.length;
    final index = dnIs.length - 1 - (currentAngle ~/ porcion) % dnIs.length;
    return dnIs[index];
  }

  void _mostrarGanador(String dni) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🎉 Ganador"),
        content: Text("El DNI ganador es:\n$dni"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(title: Text('Sorteo Ruleta')),
      body: Center(
        child: dnIs.isEmpty
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _animation?.value ?? currentAngle,
                        child: CustomPaint(
                          size: Size(size, size),
                          painter: RuletaPainter(dnIs),
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
                    label: Text('Girar'),
                    onPressed: _girarRuleta,
                  ),
                ],
              ),
      ),
    );
  }
}

class RuletaPainter extends CustomPainter {
  final List<String> dnIs;

  RuletaPainter(this.dnIs);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final anglePerSegment = 2 * pi / dnIs.length;
    final textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    for (int i = 0; i < dnIs.length; i++) {
      final angle = i * anglePerSegment;
      paint.color = Colors.primaries[i % Colors.primaries.length].shade300;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(Rect.fromCircle(center: center, radius: radius), angle, anglePerSegment, false)
        ..close();

      canvas.drawPath(path, paint);

      final textAngle = angle + anglePerSegment / 2;
      final textOffset = Offset(
        center.dx + (radius / 1.5) * cos(textAngle),
        center.dy + (radius / 1.5) * sin(textAngle),
      );

      textPainter.text = TextSpan(
        text: dnIs[i],
        style: TextStyle(fontSize: 12, color: Colors.white),
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
