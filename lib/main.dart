import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WeeklySchedulePage()));

class WeeklySchedulePage extends StatelessWidget {
  const WeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('週スケジュール（Step1）')),
      body: Center(child: Text('ここに作っていく')),
    );
  }
}
