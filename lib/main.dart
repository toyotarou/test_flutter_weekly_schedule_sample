import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WeeklySchedulePage()));

class ScheduleEvent {
  ScheduleEvent({
    required this.dayIndex,
    required this.startMinutes,
    required this.endMinutes,
    required this.title,
    this.color = const Color(0xFF42A5F5),
  });

  final int dayIndex;
  final int startMinutes;
  final int endMinutes;
  final String title;
  final Color color;
}

int toMinutes(int h, int m) => h * 60 + m;

class WeeklySchedulePage extends StatelessWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = <ScheduleEvent>[
      ScheduleEvent(dayIndex: 0, startMinutes: toMinutes(8, 0), endMinutes: toMinutes(9, 30), title: '病院'),
      ScheduleEvent(
        dayIndex: 2,
        startMinutes: toMinutes(6, 0),
        endMinutes: toMinutes(7, 0),
        title: 'ジョグ',
        color: const Color(0xFF26A69A),
      ),
      ScheduleEvent(dayIndex: 2, startMinutes: toMinutes(10, 0), endMinutes: toMinutes(12, 0), title: '病院'),
      ScheduleEvent(
        dayIndex: 4,
        startMinutes: toMinutes(13, 15),
        endMinutes: toMinutes(16, 45),
        title: '検診',
        color: const Color(0xFFFFA726),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('週スケジュール')),

      body: WeeklyScheduleView(startHour: 3, endHour: 24, pxPerMinute: 1, events: events),
    );
  }
}

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.pxPerMinute,
    this.events = const [],
  });

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  final List<ScheduleEvent> events;

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

                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(constraints.maxWidth, gridHeight),
                              painter: _GridPainter(
                                startHour: startHour,
                                endHour: endHour,
                                pxPerMinute: pxPerMinute,
                                columnWidth: colW,
                              ),
                            ),

                            ...events.map((e) {
                              final top = (e.startMinutes - startHour * 60) * pxPerMinute;

                              final height = (e.endMinutes - e.startMinutes) * pxPerMinute;

                              final left = e.dayIndex * colW;

                              return Positioned(
                                top: top.clamp(0, gridHeight - 1),
                                left: left,
                                width: colW,
                                height: height,
                                child: _EventCard(event: e),
                              );
                            }),

                            _NowIndicatorLine(startHour: startHour, endHour: endHour, pxPerMinute: pxPerMinute),
                          ],
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

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final ScheduleEvent event;

  ///
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: event.color.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 2, offset: Offset(0, 1))],
        ),

        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),

        child: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}

class _NowIndicatorLine extends StatelessWidget {
  const _NowIndicatorLine({required this.startHour, required this.endHour, required this.pxPerMinute});

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  ///
  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();

    final nowMinutes = now.hour * 60 + now.minute;

    final startMin = startHour * 60;

    final endMin = endHour * 60;

    if (nowMinutes < startMin || nowMinutes > endMin) {
      return const SizedBox.shrink();
    }

    final top = (nowMinutes - startMin) * pxPerMinute;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: IgnorePointer(child: Container(height: 2, color: const Color(0xFFE53935))),
    );
  }
}
