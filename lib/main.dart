import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WeeklySchedulePage()));

class WeeklySchedulePage extends StatelessWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('週スケジュール')),
      body: WeeklyScheduleView(),
    );
  }
}

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key});

  static const _dayLabels = ['日', '月', '火', '水', '木', '金', '土'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //---------------------------------------
        SizedBox(
          height: 36,
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

        //---------------------------------------
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
