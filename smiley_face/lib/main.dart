import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ShapesDemoApp());
}

class ShapesDemoApp extends StatelessWidget {
  const ShapesDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shapes Drawing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ShapesDemoScreen(),
    );
  }
}

class ShapesDemoScreen extends StatelessWidget {
  const ShapesDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapes Drawing Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task 1: Basic Shapes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: BasicShapesPainter(),
                size: const Size(double.infinity, 200),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Task 2: Combined Shapes (Abstract Design)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: CustomPaint(
                painter: CombinedShapesPainter(),
                size: const Size(double.infinity, 300),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Task 3: Styled Shapes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: CustomPaint(
                painter: StyledShapesPainter(),
                size: const Size(double.infinity, 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Determine the center of the canvas
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final squareOffset = Offset(centerX - 80, centerY);
    final circleOffset = Offset(centerX, centerY);
    final arcOffset = Offset(centerX + 80, centerY);
    final rectOffset = Offset(centerX - 160, centerY);
    final lineStart = Offset(centerX - 200, centerY - 50);
    final lineEnd = Offset(centerX - 140, centerY + 50);
    final ovalOffset = Offset(centerX + 160, centerY);

    // Draw a square
    final squarePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: squareOffset, width: 60, height: 60),
      squarePaint,
    );

    // Draw a circle
    final circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleOffset, 30, circlePaint);

    // Draw an arc
    final arcPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawArc(
      Rect.fromCenter(center: arcOffset, width: 60, height: 60),
      0, // start angle in radians
      2.1, // sweep angle in radians (about 120 degrees)
      false, // whether to use center
      arcPaint,
    );

    // Draw a rectangle
    final rectPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: rectOffset, width: 80, height: 40),
      rectPaint,
    );

    // Draw a line
    final linePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 3;
    canvas.drawLine(lineStart, lineEnd, linePaint);

    // Draw an oval
    final ovalPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: ovalOffset, width: 80, height: 40),
      ovalPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CombinedShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Background gradient
    final backgroundGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [Colors.blue.shade100, Colors.white],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = backgroundGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Draw a sun (circle with rays)
    final sunPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY - 40), 40, sunPaint);

    // Sun rays (lines)
    final rayPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3;
    for (int i = 0; i < 8; i++) {
      final angle = i * (pi / 4); // Use pi from dart:math
      final dx = cos(angle) * 60;
      final dy = sin(angle) * 60;
      canvas.drawLine(
        Offset(centerX, centerY - 40),
        Offset(centerX + dx, centerY - 40 + dy),
        rayPaint,
      );
    }

    // Draw a house (square with triangle roof)
    final housePaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;
    
    // House body (rectangle)
    canvas.drawRect(
      Rect.fromCenter(center: Offset(centerX, centerY + 60), width: 80, height: 60),
      housePaint,
    );
    
    // House roof (triangle)
    final roofPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    Path roofPath = Path();
    roofPath.moveTo(centerX - 50, centerY + 30); // Bottom left of roof
    roofPath.lineTo(centerX, centerY); // Top of roof
    roofPath.lineTo(centerX + 50, centerY + 30); // Bottom right of roof
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);
    
    // House door
    final doorPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(centerX, centerY + 75), width: 20, height: 30),
      doorPaint,
    );
    
    // House windows
    final windowPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(centerX - 25, centerY + 50), width: 15, height: 15),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(centerX + 25, centerY + 50), width: 15, height: 15),
      windowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StyledShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Create gradient paint
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple, Colors.pink, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw gradient circle
    canvas.drawCircle(Offset(centerX - 80, centerY - 50), 40, gradientPaint);

    // Draw shadow rectangle
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(centerX + 80, centerY - 50), width: 80, height: 60),
      shadowPaint,
    );

    // Draw actual rectangle on top
    final rectPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(centerX + 75, centerY - 55), width: 80, height: 60),
      rectPaint,
    );

    // Draw textured oval using pattern
    final texturePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Create a pattern by drawing multiple concentric ovals
    for (int i = 0; i < 5; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 50), 
          width: 100 - (i * 10), 
          height: 60 - (i * 6)
        ),
        texturePaint,
      );
    }

    // Draw star shape
    final starPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Path starPath = Path();
    const int numPoints = 5;
    const double outerRadius = 30;
    const double innerRadius = 15;
    const double startAngle = -pi / 2;

    for (int i = 0; i < numPoints * 2; i++) {
      final double angle = startAngle + (i * pi / numPoints);
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double x = centerX - 80 + cos(angle) * radius;
      final double y = centerY + 50 + sin(angle) * radius;

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);

    // Draw dashed line
    final dashPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double dashWidth = 10;
    const double dashSpace = 5;
    double startX = centerX - 100;
    final double endX = centerX + 100;
    final double y = centerY + 120;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
