import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WeeklySchedulePage()));

class WeeklySchedulePage extends StatelessWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('週スケジュール')),

      body: WeeklyScheduleView(startHour: 3, endHour: 24, pxPerMinute: 1),
    );
  }
}

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key, required this.startHour, required this.endHour, required this.pxPerMinute});

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  static const _dayLabels = ['日', '月', '火', '水', '木', '金', '土'];

  ///
  @override
  Widget build(BuildContext context) {
    final totalMinutes = (endHour - startHour) * 60;

    final gridHeight = totalMinutes * pxPerMinute;

    const timeGutterWidth = 56.0;

    return Column(
      children: [
        //---------------------------------------
        SizedBox(
          height: 36,
          child: Row(
            children: [
              const SizedBox(width: timeGutterWidth), // 時間欄ぶんの余白
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final colW = constraints.maxWidth / 7;
                    return Row(
                      children: List.generate(7, (i) {
                        final isWeekend = (i == 0 || i == 6);
                        return Container(
                          alignment: Alignment.center,
                          width: colW,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0x33000000))),
                          ),
                          child: Text(
                            _dayLabels[i],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isWeekend ? Colors.blueGrey : Colors.black87,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: gridHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: timeGutterWidth,
                    child: _TimeLabels(startHour: startHour, endHour: endHour, pxPerMinute: pxPerMinute),
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final colW = constraints.maxWidth / 7;

                        return CustomPaint(
                          size: Size(constraints.maxWidth, gridHeight),

                          painter: _GridPainter(
                            startHour: startHour,
                            endHour: endHour,
                            pxPerMinute: pxPerMinute,
                            columnWidth: colW,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeLabels extends StatelessWidget {
  const _TimeLabels({required this.startHour, required this.endHour, required this.pxPerMinute});

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  ///
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int h = startHour; h <= endHour; h++) {
      final top = (h - startHour) * 60 * pxPerMinute;

      children.add(Positioned(top: top - 8, left: 4, child: Text('${h.toString().padLeft(2, '0')}:00')));
    }

    return Stack(children: children);
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.startHour, required this.endHour, required this.pxPerMinute, required this.columnWidth});

  final int startHour, endHour;
  final double pxPerMinute, columnWidth;

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final hour = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;

    final major = Paint()
      ..color = const Color(0x33000000)
      ..strokeWidth = 1.2;

    for (int h = startHour; h <= endHour; h++) {
      final y = (h - startHour) * 60 * pxPerMinute;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), (h % 3 == 0) ? major : hour);
    }

    final v = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;

    for (int i = 0; i <= 7; i++) {
      final x = i * columnWidth;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), v);
    }

    final weekend = Paint()..color = const Color(0x113F51B5);

    canvas.drawRect(Rect.fromLTWH(0, 0, columnWidth, size.height), weekend);

    canvas.drawRect(Rect.fromLTWH(6 * columnWidth, 0, columnWidth, size.height), weekend);
  }

  ///
  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.startHour != startHour ||
      old.endHour != endHour ||
      old.pxPerMinute != pxPerMinute ||
      old.columnWidth != columnWidth;
}
