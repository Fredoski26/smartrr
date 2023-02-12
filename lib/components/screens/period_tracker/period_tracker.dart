import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import "package:table_calendar/table_calendar.dart";
import "package:page_transition/page_transition.dart";

class PeriodTracker extends StatefulWidget {
  const PeriodTracker({super.key});

  @override
  State<PeriodTracker> createState() => _PeriodTrackerState();
}

class _PeriodTrackerState extends State<PeriodTracker> {
  DateTime _focusedDay = DateTime.now();

  ValueNotifier<CalendarFormat> _calendarFormat =
      ValueNotifier(CalendarFormat.week);
  DateTime lastPeriod = DateTime.parse("2023-01-31 00:00:00.000Z");

  Map<DateTime, List<Event>> allEvents = {};
  @override
  Widget build(BuildContext context) {
    DateTime? _selectedDay = _focusedDay;
    List<Event>? selectedDayEvents = _getEventsForDay(_focusedDay);

    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              theme.darkTheme ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: theme.darkTheme ? darkGrey : Colors.white,
          systemNavigationBarIconBrightness:
              theme.darkTheme ? Brightness.light : Brightness.dark,
        ),
        child: Material(
          child: Container(
            child: ValueListenableBuilder(
              valueListenable: _calendarFormat,
              builder: (context, _, __) => ListView(
                children: [
                  Container(
                    height: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Period Tracker",
                          style: TextStyle().copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  TableCalendar(
                    calendarFormat: _calendarFormat.value,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                      todayBuilder: (context, day, _focusedDay) => SizedBox(),
                      selectedBuilder: (context, day, _focusedDay) => Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: theme.darkTheme
                                ? Colors.white
                                : Colors.purple.shade200,
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey.shade200,
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                  Colors.grey.shade500
                                ],
                                stops: [
                                  0.1,
                                  0.3,
                                  0.8,
                                  0.9
                                ])),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                          ),
                        ),
                      ),
                      markerBuilder: (context, day, events) {
                        if (events.isNotEmpty) {
                          allEvents = {
                            ...allEvents,
                            day: events as List<Event>
                          };

                          if (events[0].type == EventType.MESTRUAL_FLOW) {
                            return Center(
                              child: Text(
                                day.day.toString(),
                                style: TextStyle().copyWith(color: Colors.teal),
                              ),
                            );
                          } else if (events[0].type ==
                              EventType.FERTILE_WINDOW) {
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
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(selectedDay, _selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = selectedDay;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 50.0),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.height / 3,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedDayEvents.isNotEmpty
                            ? selectedDayEvents.first.color
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 3),
                        boxShadow: [
                          BoxShadow(
                            color: selectedDayEvents.first.color.shade300,
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              selectedDayEvents.first.color.shade200,
                              selectedDayEvents.first.color.shade300,
                              selectedDayEvents.first.color.shade400,
                              selectedDayEvents.first.color.shade500,
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
          ),
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
  final MaterialColor color;

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
