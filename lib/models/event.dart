import 'package:flutter/material.dart';

enum EventType { FERTILE_WINDOW, OVULATION, MESTRUAL_FLOW, NORMAL }

class Event {
  final String title;
  final EventType type;
  final MaterialColor color;

  const Event({
    required this.title,
    required this.type,
    this.color = Colors.grey,
  });

  @override
  String toString() => title;
}
