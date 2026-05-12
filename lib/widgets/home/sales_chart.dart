import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Sales",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Last 7 Days",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child:Placeholder(),

            // CustomPaint(
            //   painter: ChartPainter(
            //     color: AppColors.primary,
            //     isDark: isDark,
            //   ),
            // ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                .map((day) => Text(
                      day,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  ChartPainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.6, size.height * 1.0, size.width * 0.8, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.2, size.width, size.height * 0.5);

    canvas.drawPath(path, paint);

    // Fill area under the curve
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.0),
      ],
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, Paint()..shader = gradient);
    
    // Draw data point
    final pointPaint = Paint()..color = color;
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.8), 4, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.8), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
