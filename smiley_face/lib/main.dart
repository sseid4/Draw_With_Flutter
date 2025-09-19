import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EmojiDrawingApp());
}

class EmojiDrawingApp extends StatelessWidget {
  const EmojiDrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Emoji Drawing',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const EmojiDrawingScreen(),
    );
  }
}

class EmojiInstance {
  final EmojiType type;
  final Offset position;
  const EmojiInstance({required this.type, required this.position});
}


class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  const GradientText(this.text, {super.key, required this.style, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}


enum EmojiType {
  smileyFace,
  partyFace,
  heart,
}

class EmojiDrawingScreen extends StatefulWidget {
  const EmojiDrawingScreen({super.key});

  @override
  State<EmojiDrawingScreen> createState() => _EmojiDrawingScreenState();
}

class _EmojiDrawingScreenState extends State<EmojiDrawingScreen> {
  EmojiType selectedEmoji = EmojiType.smileyFace;
  final List<EmojiInstance> _placedEmojis = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          'Interactive Emoji Drawing',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.yellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.lightBlue, Colors.white, Colors.lightGreen],
            center: Alignment.topRight,
            radius: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji Selection UI
              Card(
                elevation: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.lightBlue.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        'Select an Emoji to Draw:',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientText(
                            'Tap the canvas to add emojis',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.orange],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() => _placedEmojis.clear());
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.purple.shade50,
                              foregroundColor: Colors.purple,
                            ),
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildEmojiButton(
                            emoji: '😊',
                            label: 'Smiley Face',
                            type: EmojiType.smileyFace,
                          ),
                          _buildEmojiButton(
                            emoji: '🥳',
                            label: 'Party Face',
                            type: EmojiType.partyFace,
                          ),
                          _buildEmojiButton(
                            emoji: '❤️',
                            label: 'Heart',
                            type: EmojiType.heart,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Drawing Area
              Expanded(
                child: Card(
                  elevation: 8,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      gradient: RadialGradient(
                        colors: [Colors.yellow.shade100, Colors.white],
                        center: Alignment.center,
                        radius: 0.8,
                      ),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        final local = details.localPosition;
                        setState(() {
                          _placedEmojis.add(EmojiInstance(type: selectedEmoji, position: local));
                        });
                      },
                      child: CustomPaint(
                        painter: PlacedEmojiPainter(
                          selected: selectedEmoji,
                          placed: _placedEmojis,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiButton({
    required String emoji,
    required String label,
    required EmojiType type,
  }) {
    final isSelected = selectedEmoji == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmoji = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dynamic Emoji Painter that switches between different emoji types
class DynamicEmojiPainter extends CustomPainter {
  final EmojiType emojiType;

  DynamicEmojiPainter(this.emojiType);

  @override
  void paint(Canvas canvas, Size size) {
    switch (emojiType) {
      case EmojiType.smileyFace:
        _drawSmileyFace(canvas, size);
        break;
      case EmojiType.partyFace:
        _drawPartyFace(canvas, size);
        break;
      case EmojiType.heart:
        _drawHeart(canvas, size);
        break;
    }
  }

  void _drawSmileyFace(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw the face with gradient
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade400, Colors.yellow.shade600],
        center: Alignment.topLeft,
      ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: size.width * 0.3));

    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.3, facePaint);

    // Face outline
    final faceOutlinePaint = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.3, faceOutlinePaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.1, centerY - size.height * 0.08),
      size.width * 0.03,
      eyePaint
    );
    canvas.drawCircle(
      Offset(centerX + size.width * 0.1, centerY - size.height * 0.08),
      size.width * 0.03,
      eyePaint
    );

    // Eye shine
    final eyeShinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.09, centerY - size.height * 0.09),
      size.width * 0.01,
      eyeShinePaint
    );
    canvas.drawCircle(
      Offset(centerX + size.width * 0.11, centerY - size.height * 0.09),
      size.width * 0.01,
      eyeShinePaint
    );

    // Smile
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, centerY + size.height * 0.03),
        width: size.width * 0.25,
        height: size.height * 0.15,
      ),
      0.3,
      pi - 0.6,
      false,
      smilePaint,
    );

    // Rosy cheeks
    final cheekPaint = Paint()
      ..color = Colors.pink.shade200.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.18, centerY + size.height * 0.02),
      size.width * 0.04,
      cheekPaint
    );
    canvas.drawCircle(
      Offset(centerX + size.width * 0.18, centerY + size.height * 0.02),
      size.width * 0.04,
      cheekPaint
    );
  }

  void _drawPartyFace(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw the face with party gradient
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade400],
        center: Alignment.topLeft,
      ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: size.width * 0.3));

    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.3, facePaint);

    // Face outline
    final faceOutlinePaint = Paint()
      ..color = Colors.deepOrange.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.3, faceOutlinePaint);

    // Party hat
    final hatPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple, Colors.pink, Colors.red],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(centerX - size.width * 0.15, centerY - size.height * 0.35, size.width * 0.3, size.height * 0.25));

    final hatPath = Path();
    hatPath.moveTo(centerX - size.width * 0.15, centerY - size.height * 0.1); // Bottom left
    hatPath.lineTo(centerX + size.width * 0.15, centerY - size.height * 0.1); // Bottom right
    hatPath.lineTo(centerX, centerY - size.height * 0.35); // Top
    hatPath.close();
    canvas.drawPath(hatPath, hatPaint);

    // Hat outline
    final hatOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(hatPath, hatOutlinePaint);

    // Hat pom-pom
    final pompomPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX, centerY - size.height * 0.35),
      size.width * 0.02,
      pompomPaint
    );

    // Eyes (party eyes with sparkles)
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - size.width * 0.1, centerY - size.height * 0.05),
      size.width * 0.03,
      eyePaint
    );
    canvas.drawCircle(
      Offset(centerX + size.width * 0.1, centerY - size.height * 0.05),
      size.width * 0.03,
      eyePaint
    );

    // Big smile
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, centerY + size.height * 0.05),
        width: size.width * 0.3,
        height: size.height * 0.2,
      ),
      0.2,
      pi - 0.4,
      false,
      smilePaint,
    );

    // Confetti - colorful shapes scattered around
    _drawConfetti(canvas, size, centerX, centerY);
  }

  void _drawConfetti(Canvas canvas, Size size, double centerX, double centerY) {
    final random = Random(42); // Fixed seed for consistent confetti

    // Different confetti colors
    final confettiColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.pink,
      Colors.orange,
      Colors.purple,
    ];

    // Draw various confetti pieces
    for (int i = 0; i < 20; i++) {
      final color = confettiColors[i % confettiColors.length];
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final x = centerX + (random.nextDouble() - 0.5) * size.width * 0.8;
      final y = centerY + (random.nextDouble() - 0.5) * size.height * 0.8;

      if (i % 3 == 0) {
        // Draw circles
        canvas.drawCircle(Offset(x, y), size.width * 0.01, paint);
      } else if (i % 3 == 1) {
        // Draw squares
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: size.width * 0.015, height: size.width * 0.015),
          paint,
        );
      } else {
        // Draw triangles
        final path = Path();
        path.moveTo(x, y - size.width * 0.01);
        path.lineTo(x - size.width * 0.008, y + size.width * 0.005);
        path.lineTo(x + size.width * 0.008, y + size.width * 0.005);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawHeart(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Heart with gradient
    final heartPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red.shade300, Colors.red.shade700, Colors.red.shade900],
        begin: Alignment.topLeft,


        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(centerX - size.width * 0.25, centerY - size.height * 0.2, size.width * 0.5, size.height * 0.4));

    // Draw heart shape
    final heartPath = Path();
    final heartSize = size.width * 0.3;

    // Start from the bottom point of the heart
    heartPath.moveTo(centerX, centerY + heartSize * 0.3);

    // Left curve
    heartPath.cubicTo(
      centerX - heartSize * 0.5, centerY + heartSize * 0.1,
      centerX - heartSize * 0.5, centerY - heartSize * 0.3,
      centerX, centerY - heartSize * 0.1,
    );

    // Right curve
    heartPath.cubicTo(
      centerX + heartSize * 0.5, centerY - heartSize * 0.3,
      centerX + heartSize * 0.5, centerY + heartSize * 0.1,
      centerX, centerY + heartSize * 0.3,
    );

    canvas.drawPath(heartPath, heartPaint);

    // Heart outline
    final heartOutlinePaint = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(heartPath, heartOutlinePaint);

    // Add sparkles around the heart
    _drawSparkles(canvas, size, centerX, centerY);
  }

  void _drawSparkles(Canvas canvas, Size size, double centerX, double centerY) {
    final sparklePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final sparklePositions = [
      Offset(centerX - size.width * 0.2, centerY - size.height * 0.15),
      Offset(centerX + size.width * 0.2, centerY - size.height * 0.1),
      Offset(centerX - size.width * 0.15, centerY + size.height * 0.2),
      Offset(centerX + size.width * 0.18, centerY + size.height * 0.15),
      Offset(centerX - size.width * 0.25, centerY),
      Offset(centerX + size.width * 0.25, centerY - size.height * 0.05),
    ];

    for (final position in sparklePositions) {
      // Draw sparkle as a star shape
      final sparkleSize = size.width * 0.02;
      final sparklePath = Path();

      // Simple 4-pointed star
      sparklePath.moveTo(position.dx, position.dy - sparkleSize);
      sparklePath.lineTo(position.dx + sparkleSize * 0.3, position.dy - sparkleSize * 0.3);
      sparklePath.lineTo(position.dx + sparkleSize, position.dy);
      sparklePath.lineTo(position.dx + sparkleSize * 0.3, position.dy + sparkleSize * 0.3);
      sparklePath.lineTo(position.dx, position.dy + sparkleSize);
      sparklePath.lineTo(position.dx - sparkleSize * 0.3, position.dy + sparkleSize * 0.3);
      sparklePath.lineTo(position.dx - sparkleSize, position.dy);
      sparklePath.lineTo(position.dx - sparkleSize * 0.3, position.dy - sparkleSize * 0.3);
      sparklePath.close();

      canvas.drawPath(sparklePath, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! DynamicEmojiPainter || oldDelegate.emojiType != emojiType;
  }
}

class CombinedShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Task 1 with gradients: Square, Circle, Arc, Triangle

    // Square with linear gradient
    final squareRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.1,
      size.width * 0.25,
      size.width * 0.25,
    );
    final squarePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.blue, Colors.cyan],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(squareRect)
      ..style = PaintingStyle.fill;
    canvas.drawRect(squareRect, squarePaint);

    // Circle with radial gradient
    final circleCenter = Offset(size.width * 0.7, size.height * 0.22);
    final circleRadius = size.width * 0.12;
    final circleRect = Rect.fromCircle(center: circleCenter, radius: circleRadius);
    final circlePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.red, Colors.orange],
        center: Alignment(-0.3, -0.3),
        radius: 1.0,
      ).createShader(circleRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    // Arc with sweep gradient stroke
    final arcRect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.3,
    );
    final arcPaint = Paint()
      ..shader = const SweepGradient(
        colors: [Colors.green, Colors.lightGreen, Colors.green],
        startAngle: 0,
        endAngle: pi,
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcRect,
      0, // start angle
      pi, // sweep angle (half circle)
      false, // use center
      arcPaint,
    );

    // Triangle with linear gradient fill
    final triLeft = size.width * 0.15;
    final triRight = size.width * 0.35;
    final triBottom = size.height * 0.85;
    final triTop = size.height * 0.65;
    final trianglePath = Path()
      ..moveTo(triLeft, triBottom)
      ..lineTo(triRight, triBottom)
      ..lineTo((triLeft + triRight) / 2, triTop)
      ..close();
    final triangleBounds = Rect.fromLTRB(triLeft, triTop, triRight, triBottom);
    final trianglePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.purple, Colors.deepPurpleAccent],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(triangleBounds)
      ..style = PaintingStyle.fill;
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


class PlacedEmojiPainter extends CustomPainter {
  final EmojiType selected;
  final List<EmojiInstance> placed;
  PlacedEmojiPainter({required this.selected, required this.placed});

  @override
  void paint(Canvas canvas, Size size) {
    if (placed.isEmpty) {
      // Fallback to single selected emoji centered (preserve previous behavior)
      DynamicEmojiPainter(selected).paint(canvas, size);
      return;
    }

    // Draw each placed emoji at its tapped position
    final base = size.shortestSide;
    final radius = (base * 0.08).clamp(20.0, 60.0); // responsive size per emoji

    for (final e in placed) {
      switch (e.type) {
        case EmojiType.smileyFace:
          _drawSmileyAt(canvas, e.position, radius);
          break;
        case EmojiType.partyFace:
          _drawPartyAt(canvas, e.position, radius);
          break;
        case EmojiType.heart:
          _drawHeartAt(canvas, e.position, radius);
          break;
      }
    }
  }

  void _drawSmileyAt(Canvas canvas, Offset c, double r) {
    // Face (gradient fill)
    final faceRect = Rect.fromCircle(center: c, radius: r);
    final facePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.yellow, Colors.orangeAccent],
        center: Alignment(-0.4, -0.4),
      ).createShader(faceRect);
    canvas.drawCircle(c, r, facePaint);

    // Outline
    final outline = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.08;
    canvas.drawCircle(c, r, outline);

    // Eyes
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(c.dx - r * 0.4, c.dy - r * 0.25), r * 0.14, eyePaint);
    canvas.drawCircle(Offset(c.dx + r * 0.4, c.dy - r * 0.25), r * 0.14, eyePaint);

    // Smile (arc)
    final smile = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.1), width: r * 1.2, height: r * 0.9),
      0.3,
      pi - 0.6,
      false,
      smile,
    );

    // Custom design: cheeks
    final cheek = Paint()..color = Colors.pink.shade200.withOpacity(0.7);
    canvas.drawCircle(Offset(c.dx - r * 0.6, c.dy + r * 0.15), r * 0.2, cheek);
    canvas.drawCircle(Offset(c.dx + r * 0.6, c.dy + r * 0.15), r * 0.2, cheek);
  }

  void _drawPartyAt(Canvas canvas, Offset c, double r) {
    // Face with party gradient
    final faceRect = Rect.fromCircle(center: c, radius: r);
    final facePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.yellow, Colors.deepOrangeAccent],
        center: Alignment(-0.4, -0.4),
      ).createShader(faceRect);
    canvas.drawCircle(c, r, facePaint);

    // Outline
    final outline = Paint()
      ..color = Colors.deepOrange.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.08;
    canvas.drawCircle(c, r, outline);

    // Eyes
    final eye = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(c.dx - r * 0.35, c.dy - r * 0.2), r * 0.14, eye);
    canvas.drawCircle(Offset(c.dx + r * 0.35, c.dy - r * 0.2), r * 0.14, eye);

    // Smile
    final smile = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.16
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.1), width: r * 1.3, height: r * 0.9),
      0.2,
      pi - 0.4,
      false,
      smile,
    );

    // Party hat
    final hatRect = Rect.fromLTWH(c.dx - r * 0.8, c.dy - r * 1.5, r * 1.6, r * 1.2);
    final hatPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.purple, Colors.pink, Colors.red],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(hatRect);
    final hat = Path()
      ..moveTo(c.dx - r * 0.7, c.dy - r * 0.3)
      ..lineTo(c.dx + r * 0.7, c.dy - r * 0.3)
      ..lineTo(c.dx, c.dy - r * 1.5)
      ..close();
    canvas.drawPath(hat, hatPaint);
    canvas.drawPath(hat, Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = r * 0.06);

    // Confetti
    final confettiColors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.pink, Colors.orange, Colors.purple];
    for (int i = 0; i < 10; i++) {
      final t = (i / 10.0) * 2 * pi;
      final pos = Offset(c.dx + cos(t) * r * 1.4, c.dy + sin(t) * r * 1.2);
      final paint = Paint()..color = confettiColors[i % confettiColors.length];
      switch (i % 3) {
        case 0:
          canvas.drawCircle(pos, r * 0.08, paint);
          break;
        case 1:
          canvas.drawRect(Rect.fromCenter(center: pos, width: r * 0.14, height: r * 0.14), paint);
          break;
        case 2:
          final tri = Path()
            ..moveTo(pos.dx, pos.dy - r * 0.1)
            ..lineTo(pos.dx - r * 0.08, pos.dy + r * 0.05)
            ..lineTo(pos.dx + r * 0.08, pos.dy + r * 0.05)
            ..close();
          canvas.drawPath(tri, paint);
          break;
      }
    }
  }

  void _drawHeartAt(Canvas canvas, Offset c, double r) {
    final rect = Rect.fromCircle(center: c, radius: r * 1.3);
    final fill = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.redAccent, Colors.red, Colors.red],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final p = Path();
    final s = r * 1.2;
    p.moveTo(c.dx, c.dy + s * 0.6);
    p.cubicTo(c.dx - s, c.dy + s * 0.2, c.dx - s, c.dy - s * 0.6, c.dx, c.dy - s * 0.2);
    p.cubicTo(c.dx + s, c.dy - s * 0.6, c.dx + s, c.dy + s * 0.2, c.dx, c.dy + s * 0.6);

    canvas.drawPath(p, Paint()..shader = fill.shader);
    canvas.drawPath(p, Paint()..color = Colors.red.shade900..style = PaintingStyle.stroke..strokeWidth = r * 0.08);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
