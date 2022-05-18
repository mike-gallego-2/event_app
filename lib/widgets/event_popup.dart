import 'dart:ui';

import 'package:event_app/constants/constants.dart';
import 'package:event_app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventPopup extends StatelessWidget {
  final bool isOpen;
  const EventPopup({Key? key, required this.isOpen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isOpen,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ClipPath(
                    clipper: _TriangleClipper(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: CustomPaint(
                          painter: _TrianglePainter(
                              paintingStyle: PaintingStyle.fill, strokeColor: accentColor.withOpacity(0.2))),
                    ),
                  )),
            ),
          ),
          Container(
            height: 85,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: accentColor.withOpacity(0.2)),
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.asset(
                            'assets/events/event.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              text: 'Event Name X',
                              fontWeight: bold,
                            ),
                            const SizedBox(height: 5),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SvgPicture.asset(
                                    'assets/events/calendar.svg',
                                    height: 10,
                                  ),
                                  const SizedBox(width: 5),
                                  const AppText(text: '05/13/2022')
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/events/clock.svg',
                                  height: 10,
                                ),
                                const SizedBox(width: 5),
                                const AppText(text: '16:37')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    return Path()
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class _TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..lineTo(x / 2, y)
      ..lineTo(x, 0)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
