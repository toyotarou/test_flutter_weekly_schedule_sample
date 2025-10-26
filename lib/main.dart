import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WeeklySchedulePage()));

class ScheduleEvent {
  ScheduleEvent({
    required this.dayIndex,
    required this.startMinutes,
    required this.endMinutes,
    required this.title,
    this.color = const Color(0xFF42A5F5),
    this.memo,
  });

  final int dayIndex;
  final int startMinutes;
  final int endMinutes;
  final String title;
  final Color color;
  final String? memo;
}

class BadgeMarker {
  const BadgeMarker({
    required this.dayIndex,
    required this.minutesOfDay,
    this.icon = Icons.train,
    this.color = const Color(0xFF1565C0),
    this.tooltip,
  });

  final int dayIndex;
  final int minutesOfDay;
  final IconData icon;
  final Color color;
  final String? tooltip;
}

int toMinutes(int h, int m) => h * 60 + m;

///
String _fmtHM(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');

  final m = (minutes % 60).toString().padLeft(2, '0');

  return '$h:$m';
}

const _dayLabels = ['日', '月', '火', '水', '木', '金', '土'];

class WeeklySchedulePage extends StatelessWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = <ScheduleEvent>[
      ScheduleEvent(
        dayIndex: 0,
        startMinutes: toMinutes(8, 0),
        endMinutes: toMinutes(10, 0),
        title: '病院',
        memo: '小児科・予約A-12',
      ),
      ScheduleEvent(
        dayIndex: 0,
        startMinutes: toMinutes(9, 0),
        endMinutes: toMinutes(11, 0),
        title: '買い物',
        color: const Color(0xFF26A69A),
      ),

      ScheduleEvent(dayIndex: 2, startMinutes: toMinutes(10, 0), endMinutes: toMinutes(12, 0), title: '通院'),
      ScheduleEvent(
        dayIndex: 2,
        startMinutes: toMinutes(10, 30),
        endMinutes: toMinutes(12, 30),
        title: 'オンライン',
        color: const Color(0xFF8E24AA),
      ),
      ScheduleEvent(
        dayIndex: 2,
        startMinutes: toMinutes(11, 0),
        endMinutes: toMinutes(12, 0),
        title: 'MTG',
        color: const Color(0xFFFFA726),
      ),

      ScheduleEvent(
        dayIndex: 4,
        startMinutes: toMinutes(13, 15),
        endMinutes: toMinutes(16, 45),
        title: '検診',
        color: const Color(0xFF1E88E5),
      ),
    ];

    final badges = <BadgeMarker>[
      const BadgeMarker(
        dayIndex: 0,
        minutesOfDay: 16 * 60,
        icon: Icons.train,
        color: Color(0xFF1565C0),
        tooltip: '電車に乗車（16:00）',
      ),

      const BadgeMarker(
        dayIndex: 3,
        minutesOfDay: 9 * 60 + 30,
        icon: Icons.local_hospital,
        color: Colors.red,
        tooltip: '診察（09:30）',
      ),

      const BadgeMarker(
        dayIndex: 0,
        minutesOfDay: 20 * 60 + 30,
        icon: Icons.restaurant,
        color: Color(0xFF6D4C41),
        tooltip: '夕食（20:30）',
      ),

      const BadgeMarker(
        dayIndex: 1,
        minutesOfDay: 7 * 60 + 15,
        icon: Icons.directions_run,
        color: Color(0xFF2E7D32),
        tooltip: '朝ラン（07:15）',
      ),

      const BadgeMarker(
        dayIndex: 2,
        minutesOfDay: 12 * 60,
        icon: Icons.lunch_dining,
        color: Color(0xFF8D6E63),
        tooltip: 'ランチ（12:00）',
      ),

      const BadgeMarker(
        dayIndex: 4,
        minutesOfDay: 18 * 60 + 45,
        icon: Icons.work,
        color: Color(0xFF455A64),
        tooltip: '退社（18:45）',
      ),

      const BadgeMarker(
        dayIndex: 5,
        minutesOfDay: 6 * 60,
        icon: Icons.alarm,
        color: Color(0xFFF4511E),
        tooltip: '早起き（06:00）',
      ),

      const BadgeMarker(
        dayIndex: 6,
        minutesOfDay: 14 * 60,
        icon: Icons.directions_walk,
        color: Color(0xFF5E35B1),
        tooltip: 'お散歩（14:00）',
      ),

      const BadgeMarker(
        dayIndex: 4,
        minutesOfDay: 22 * 60 + 10,
        icon: Icons.bedtime,
        color: Color(0xFF283593),
        tooltip: '就寝（22:10）',
      ),

      const BadgeMarker(
        dayIndex: 2,
        minutesOfDay: 8 * 60 + 5,
        icon: Icons.flight_takeoff,
        color: Color(0xFF0277BD),
        tooltip: '出発（08:05）',
      ),

      const BadgeMarker(
        dayIndex: 0,
        minutesOfDay: 9 * 60,
        icon: Icons.church,
        color: Color(0xFF795548),
        tooltip: '日曜礼拝（09:00）',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Step9 ダイアログ表示')),

      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.calendar_view_week),
          label: const Text('週スケジュールを開く'),
          onPressed: () => _openWeeklyDialog(context, events, badges),
        ),
      ),
    );
  }
}

void _openWeeklyDialog(BuildContext context, List<ScheduleEvent> events, List<BadgeMarker> badges) {
  const int startHour = 3;
  const int endHour = 24;
  const double pxPerMinute = 1.0;
  const double gutter = 56;
  const double minColW = 90;
  final double gridHeight = (endHour - startHour) * 60 * pxPerMinute;

  final ScrollController gutterVertical = ScrollController();

  showDialog(
    context: context,
    builder: (ctx) {
      final bg = Theme.of(ctx).dialogTheme.backgroundColor ?? Theme.of(ctx).colorScheme.surface;

      return AlertDialog(
        title: const Text('週スケジュール'),
        content: SizedBox(
          width: double.maxFinite,
          height: 560,
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.axis == Axis.vertical) {
                    final target = n.metrics.pixels;
                    if (gutterVertical.hasClients) {
                      gutterVertical.jumpTo(target.clamp(0.0, gutterVertical.position.maxScrollExtent));
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: gutter + 7 * minColW,
                    child: WeeklyScheduleView(
                      startHour: startHour,
                      endHour: endHour,
                      pxPerMinute: pxPerMinute,
                      events: events,
                      badges: badges,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                top: 36,
                bottom: 0,
                width: gutter,
                child: IgnorePointer(
                  child: Container(
                    color: bg,
                    child: SingleChildScrollView(
                      controller: gutterVertical,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        height: gridHeight,
                        child: const _TimeLabels(startHour: startHour, endHour: endHour, pxPerMinute: pxPerMinute),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('閉じる'))],
      );
    },
  );
}

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.pxPerMinute,
    this.events = const [],
    this.badges = const [],
  });

  final int startHour;

  final int endHour;

  final double pxPerMinute;

  final List<ScheduleEvent> events;

  final List<BadgeMarker> badges;

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
              const SizedBox(width: timeGutterWidth),

              const Expanded(child: _WeekHeader()),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: gridHeight,
              child: Row(
                children: [
                  SizedBox(width: timeGutterWidth, child: const _TimeLabels(startHour: 3, endHour: 24, pxPerMinute: 1)),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final colW = constraints.maxWidth / 7;

                        final placed = _placeWeekly(events, colW);

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

                            ...placed.map((p) {
                              final e = p.event;

                              final top = (e.startMinutes - startHour * 60) * pxPerMinute;

                              final height = (e.endMinutes - e.startMinutes) * pxPerMinute;

                              final perWidth = colW / p.columnCount;

                              final left = e.dayIndex * colW + p.columnIndex * perWidth;

                              const gap = 2.0;

                              final width = perWidth - gap * 2;

                              return Positioned(
                                top: top.clamp(0, gridHeight - 1),
                                left: left + gap,
                                width: width,
                                height: height,

                                child: _EventCard(event: e, onTap: () => _showEventDialog(context, e)),
                              );
                            }),

                            _NowIndicatorLine(startHour: startHour, endHour: endHour, pxPerMinute: pxPerMinute),

                            ...badges.map((b) {
                              const double size = 20.0;
                              final top = (b.minutesOfDay - startHour * 60) * pxPerMinute - size / 2;
                              final left = b.dayIndex * colW + (colW - size) / 2;
                              return Positioned(
                                top: top.clamp(0, gridHeight - size),
                                left: left,
                                width: size,
                                height: size,
                                child: Tooltip(
                                  message: b.tooltip ?? 'badge',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: const [BoxShadow(blurRadius: 3, color: Color(0x33000000))],
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(b.icon, size: 14, color: b.color),
                                  ),
                                ),
                              );
                            }),
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

class _WeekHeader extends StatelessWidget {
  const _WeekHeader();

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colW = constraints.maxWidth / 7;
        return Row(
          children: List.generate(7, (i) {
            final isWeekend = i == 0 || i == 6;

            return Container(
              alignment: Alignment.center,
              width: colW,

              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0x33000000))),
              ),

              child: Text(
                _dayLabels[i],
                style: TextStyle(fontWeight: FontWeight.w600, color: isWeekend ? Colors.blueGrey : Colors.black87),
              ),
            );
          }),
        );
      },
    );
  }
}

void _showEventDialog(BuildContext context, ScheduleEvent e) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(e.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DialogRow(icon: Icons.today, text: '曜日: ${_dayLabels[e.dayIndex]}'),
            const SizedBox(height: 8),
            _DialogRow(icon: Icons.access_time, text: '${_fmtHM(e.startMinutes)} 〜 ${_fmtHM(e.endMinutes)}'),

            if (e.memo != null) ...[const SizedBox(height: 8), _DialogRow(icon: Icons.notes, text: e.memo!)],
          ],
        ),

        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('閉じる'))],
      );
    },
  );
}

///
class _DialogRow extends StatelessWidget {
  const _DialogRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _PlacedEvent {
  const _PlacedEvent({required this.event, required this.columnIndex, required this.columnCount});

  final ScheduleEvent event;

  final int columnIndex, columnCount;
}

List<_PlacedEvent> _placeWeekly(List<ScheduleEvent> events, double columnWidth) {
  final byDay = <int, List<ScheduleEvent>>{};

  for (final e in events) {
    byDay.putIfAbsent(e.dayIndex, () => []).add(e);
  }

  final placedAll = <_PlacedEvent>[];

  for (final entry in byDay.entries) {
    final dayEvents = [...entry.value]..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    placedAll.addAll(_placeForOneDay(dayEvents));
  }

  return placedAll;
}

///
List<_PlacedEvent> _placeForOneDay(List<ScheduleEvent> events) {
  final result = <_PlacedEvent>[];

  var i = 0;

  while (i < events.length) {
    final cluster = <ScheduleEvent>[];

    final active = <ScheduleEvent>[];

    int j = i;

    while (j < events.length) {
      final e = events[j];

      active.removeWhere((a) => a.endMinutes <= e.startMinutes);

      if (active.isEmpty && cluster.isNotEmpty) break;

      active.add(e);
      cluster.add(e);
      j++;
    }

    result.addAll(_assignColumns(cluster));

    i = j;
  }
  return result;
}

///
List<_PlacedEvent> _assignColumns(List<ScheduleEvent> cluster) {
  final sorted = [...cluster]
    ..sort((a, b) {
      final c = a.startMinutes.compareTo(b.startMinutes);
      if (c != 0) return c;
      return a.endMinutes.compareTo(b.endMinutes);
    });

  final placed = <_PlacedEvent>[];

  final active = <int, ScheduleEvent>{};

  for (final e in sorted) {
    final toRemove = <int>[];

    active.forEach((col, ev) {
      if (ev.endMinutes <= e.startMinutes) toRemove.add(col);
    });

    for (final col in toRemove) {
      active.remove(col);
    }

    int colIndex = 0;
    while (active.containsKey(colIndex)) {
      colIndex++;
    }

    active[colIndex] = e;

    placed.add(_PlacedEvent(event: e, columnIndex: colIndex, columnCount: 0));
  }

  final cc = placed.fold<int>(0, (m, p) => (p.columnIndex + 1 > m) ? p.columnIndex + 1 : m);

  return placed.map((p) => _PlacedEvent(event: p.event, columnIndex: p.columnIndex, columnCount: cc)).toList();
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

      children.add(
        Positioned(
          top: top - 8,
          left: 4,
          child: Text(
            '${h.toString().padLeft(2, '0')}:00',
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ),
      );
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
  const _EventCard({required this.event, this.onTap});

  final ScheduleEvent event;

  final VoidCallback? onTap;

  ///
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),

      child: Material(
        color: event.color.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                left: 6,
                top: 6,
                right: 6,
                child: Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NowIndicatorLine extends StatelessWidget {
  const _NowIndicatorLine({required this.startHour, required this.endHour, required this.pxPerMinute});

  final int startHour, endHour;

  final double pxPerMinute;

  ///
  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();

    final nowMinutes = now.hour * 60 + now.minute;

    final s = startHour * 60, e = endHour * 60;

    if (nowMinutes < s || nowMinutes > e) return const SizedBox.shrink();

    final top = (nowMinutes - s) * pxPerMinute;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: IgnorePointer(child: Container(height: 2, color: const Color(0xFFE53935))),
    );
  }
}
