import "package:flutter/material.dart";
import 'package:smartrr/utils/colors.dart';
import "package:table_calendar/table_calendar.dart";

class PeriodTracker extends StatefulWidget {
  const PeriodTracker({super.key});

  @override
  State<PeriodTracker> createState() => _PeriodTrackerState();
}

class _PeriodTrackerState extends State<PeriodTracker> {
  DateTime focusedDay = DateTime.now();

  ValueNotifier<CalendarFormat> _calendarFormat =
      ValueNotifier(CalendarFormat.week);
  DateTime lastPeriod = DateTime.parse("2023-01-31 00:00:00.000Z");

  Map<DateTime, List<Event>> allEvents = {};

  @override
  Widget build(BuildContext context) {
    List<Event>? selectedDayEvents = _getEventsForDay(focusedDay);

    return Scaffold(
      appBar: AppBar(title: Text("Period Tracker")),
      body: ValueListenableBuilder(
        valueListenable: _calendarFormat,
        builder: (context, _, __) => ListView(
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat.value,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: focusedDay,
              onFormatChanged: (format) {
                _calendarFormat.value = format;
              },
              eventLoader: (day) {
                if (FertilityCalculator(
                      cycleLength: 28,
                      lastPeriod: lastPeriod,
                    ).nextPeriod.day ==
                    day.day) {
                  return [
                    Event(
                      title: 'Start of menstrual flow',
                      type: EventType.MESTRUAL_FLOW,
                      color: Colors.teal,
                    )
                  ];
                }
                if (FertilityCalculator(
                      cycleLength: 28,
                      lastPeriod: lastPeriod,
                    ).ovulation.day ==
                    day.day) {
                  return [
                    Event(
                      title: 'Ovulation day',
                      type: EventType.OVULATION,
                      color: Colors.blue,
                    )
                  ];
                }

                final fertileWindow = FertilityCalculator(
                  cycleLength: 28,
                  lastPeriod: lastPeriod,
                ).fertileWindow;

                for (DateTime date in fertileWindow) {
                  if (date.day == day.day) {
                    return [
                      Event(
                        title: 'Fertile window',
                        type: EventType.FERTILE_WINDOW,
                        color: Colors.pink,
                      )
                    ];
                  }
                }
                return [];
              },
              calendarBuilders: CalendarBuilders(
                todayBuilder: (context, day, focusedDay) => SizedBox(),
                selectedBuilder: (context, day, focusedDay) => Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    allEvents = {...allEvents, day: events as List<Event>};

                    if (events[0].type == EventType.MESTRUAL_FLOW) {
                      return Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle().copyWith(color: Colors.teal),
                        ),
                      );
                    } else if (events[0].type == EventType.FERTILE_WINDOW) {
                      return Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle().copyWith(color: Colors.pink),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle().copyWith(color: Colors.blue),
                      ),
                    );
                  }
                  return null;
                },
              ),
              onDaySelected: (selectedDay, _) {
                setState(() {
                  focusedDay = selectedDay;
                });
              },
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: selectedDayEvents.isNotEmpty
                      ? selectedDayEvents.first.color
                      : Colors.white,
                  borderRadius: BorderRadius.circular(75),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    )
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        selectedDayEvents.first.color.withOpacity(0.2),
                        selectedDayEvents.first.color.withOpacity(0.3),
                        selectedDayEvents.first.color.withOpacity(0.4),
                        selectedDayEvents.first.color.withOpacity(0.5),
                      ],
                      stops: [
                        0.1,
                        0.3,
                        0.8,
                        0.9
                      ]),
                ),
                child: Center(
                    child: Text(
                  selectedDayEvents.isNotEmpty
                      ? selectedDayEvents.first.title
                      : "Today seems like a good day",
                  textAlign: TextAlign.center,
                  style: TextStyle().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return allEvents[day] ??
        [
          Event(
            title: "Today seems like a good day",
            type: EventType.NORMAL,
          )
        ];
  }
}

enum EventType { FERTILE_WINDOW, OVULATION, MESTRUAL_FLOW, NORMAL }

class Event {
  final String title;
  final EventType type;
  final Color color;

  const Event({
    required this.title,
    required this.type,
    this.color = Colors.grey,
  });

  @override
  String toString() => title;
}

class FertilityCalculator {
  int cycleLength;
  DateTime lastPeriod;
  int lutealPhaseLength;

  FertilityCalculator({
    required this.cycleLength,
    required this.lastPeriod,
    this.lutealPhaseLength = 14,
  });

  DateTime get nextPeriod {
    return lastPeriod.add(Duration(days: cycleLength));
  }

  DateTime get ovulation {
    return lastPeriod.add(Duration(days: cycleLength - lutealPhaseLength));
  }

  List<DateTime> get fertileWindow {
    int fertileWindowStart = cycleLength - 18;
    int fertileWindowEnd = cycleLength - 11;

    DateTime fertileWindowFirstDay =
        lastPeriod.add(Duration(days: fertileWindowStart));
    DateTime fertileWindowEndDay =
        lastPeriod.add(Duration(days: fertileWindowEnd));
    int differenceInDays =
        fertileWindowEndDay.difference(fertileWindowFirstDay).inDays;

    List<DateTime> fertileWindow = [];
    while (differenceInDays > 0) {
      fertileWindow.add(lastPeriod
          .add(Duration(days: fertileWindowEnd - differenceInDays, hours: 1))
          .toUtc());
      differenceInDays--;
    }

    return fertileWindow;
  }
}
