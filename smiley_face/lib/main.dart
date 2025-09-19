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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ShapesDemoScreen(),
    );
  }
}

class ShapesDemoScreen extends StatelessWidget {
  const ShapesDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shapes Drawing Demo')),
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
    // Task 1: Drawing Shapes (Square, circle, and arc) instead of lines

    // Paint for square
    final squarePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Paint for circle
    final circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Paint for arc
    final arcPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    // Paint for additional shapes
    final trianglePaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    // Draw a square
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.1,
        size.width * 0.25,
        size.width * 0.25,
      ),
      squarePaint,
    );

    // Draw a circle
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.22),
      size.width * 0.12,
      circlePaint,
    );

    // Draw an arc (smile shape)
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.6,
        size.height * 0.3,
      ),
      0, // start angle
      pi, // sweep angle (half circle)
      false, // use center
      arcPaint,
    );

    // Draw a triangle
    final trianglePath = Path();
    trianglePath.moveTo(size.width * 0.15, size.height * 0.85); // Bottom left
    trianglePath.lineTo(size.width * 0.35, size.height * 0.85); // Bottom right
    trianglePath.lineTo(size.width * 0.25, size.height * 0.65); // Top
    trianglePath.close();
    canvas.drawPath(trianglePath, trianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StyledShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Task 2: Drawing an Emoji - Create the best big bright smile possible
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw the face (big bright yellow circle)
    final facePaint = Paint()
      ..color = Colors.yellow.shade600
      ..style = PaintingStyle.fill;

    // Face shadow for depth
    final faceShadowPaint = Paint()
      ..color = Colors.yellow.shade800.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(centerX + 2, centerY + 2),
      size.width * 0.35,
      faceShadowPaint,
    );
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.35, facePaint);

    // Face outline
    final faceOutlinePaint = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(
      Offset(centerX, centerY),
      size.width * 0.35,
      faceOutlinePaint,
    );

    // Fill the left eye (solid black circle)
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.12, centerY - size.height * 0.08),
      size.width * 0.04,
      eyePaint,
    );

    // Fill the right eye (solid black circle)
    canvas.drawCircle(
      Offset(centerX + size.width * 0.12, centerY - size.height * 0.08),
      size.width * 0.04,
      eyePaint,
    );

    // Add eye shine (small white circles)
    final eyeShinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.105, centerY - size.height * 0.095),
      size.width * 0.015,
      eyeShinePaint,
    );
    canvas.drawCircle(
      Offset(centerX + size.width * 0.135, centerY - size.height * 0.095),
      size.width * 0.015,
      eyeShinePaint,
    );

    // Draw the smile (this is an arc)
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, centerY + size.height * 0.05),
        width: size.width * 0.35,
        height: size.height * 0.25,
      ),
      0.3, // start angle (slightly offset for natural smile)
      pi - 0.6, // sweep angle (most of semicircle)
      false, // don't use center
      smilePaint,
    );

    // Make custom designs - add rosy cheeks
    final cheekPaint = Paint()
      ..color = Colors.pink.shade200.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.22, centerY + size.height * 0.03),
      size.width * 0.05,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(centerX + size.width * 0.22, centerY + size.height * 0.03),
      size.width * 0.05,
      cheekPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
