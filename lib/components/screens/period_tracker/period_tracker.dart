import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import "package:table_calendar/table_calendar.dart";
import "package:smartrr/utils/fertilityCalculator.dart";
import 'package:smartrr/models/event.dart';

class PeriodTracker extends StatefulWidget {
  const PeriodTracker({super.key});

  @override
  State<PeriodTracker> createState() => _PeriodTrackerState();
}

class _PeriodTrackerState extends State<PeriodTracker> {
  DateTime _focusedDay = DateTime.now();
  DateTime _lastCalendarDay = DateTime.utc(2030, 1, 1);

  ValueNotifier<CalendarFormat> _calendarFormat =
      ValueNotifier(CalendarFormat.month);

  late DateTime lastPeriod;

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
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white,
                  selectedDayEvents.isNotEmpty
                      ? selectedDayEvents.first.color.withOpacity(.1)
                      : Colors.pink.shade200,
                ],
              ),
            ),
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
                    lastDay: _lastCalendarDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    daysOfWeekHeight: 20,
                    daysOfWeekStyle:
                        DaysOfWeekStyle(dowTextFormatter: weekDayBuilder),
                    headerStyle: HeaderStyle(
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                    ),
                    calendarStyle: CalendarStyle(outsideDaysVisible: false),
                    onFormatChanged: (format) {
                      _calendarFormat.value = format;
                    },
                    eventLoader: (day) {
                      if (FertilityCalculator(
                            lastCalendarDay: _lastCalendarDay,
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
                        lastCalendarDay: _lastCalendarDay,
                        cycleLength: 28,
                        lastPeriod: lastPeriod,
                      ).fertileWindow;

                      for (DateTime date in fertileWindow) {
                        if (date.day == day.day) {
                          return [
                            Event(
                              title: 'Fertile window',
                              type: EventType.FERTILE_WINDOW,
                              color: Colors.teal,
                            )
                          ];
                        }
                      }

                      final period = FertilityCalculator(
                              lastCalendarDay: _lastCalendarDay,
                              cycleLength: 28,
                              lastPeriod: lastPeriod)
                          .nextPeriod;

                      for (int i = 0; i < period.length; i++) {
                        for (int j = 0; j < period[i].length; j++) {
                          if (isSameDay(period[i][j], day)) {
                            return [
                              Event(
                                title: 'Period day ${j + 1}',
                                type: EventType.MESTRUAL_FLOW,
                                color: Colors.pink,
                              )
                            ];
                          }
                        }
                      }
                      return [];
                    },
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, _focusedDay) => Center(
                        child: Text(day.day.toString()),
                      ),
                      selectedBuilder: (context, day, _focusedDay) => Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: TextStyle().copyWith(color: darkGrey),
                            ),
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
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: TextStyle()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          } else if (events[0].type ==
                              EventType.FERTILE_WINDOW) {
                            return Center(
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: TextStyle()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: Text(
                                  day.day.toString(),
                                  style:
                                      TextStyle().copyWith(color: Colors.white),
                                ),
                              ),
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
                            blurRadius: 0.0,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  String weekDayBuilder(DateTime date, dynamic locale) {
    switch (date.weekday) {
      case DateTime.monday:
        return "MON";
      case DateTime.tuesday:
        return "TUE";
      case DateTime.wednesday:
        return "WED";
      case DateTime.thursday:
        return "THU";
      case DateTime.friday:
        return "FRI";
      case DateTime.saturday:
        return "SAT";
      default:
        return "SUN";
    }
  }

  @override
  void initState() {
    lastPeriod = DateTime.fromMillisecondsSinceEpoch(
        Hive.box("period_tracker").get("lastPeriod"));
    super.initState();
  }
}
