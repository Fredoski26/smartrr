import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
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
  late DateTime _focusedDay;
  DateTime _lastCalendarDay = DateTime(2030, 1, 1);

  ValueNotifier<CalendarFormat> _calendarFormat =
      ValueNotifier(CalendarFormat.month);

  late DateTime lastPeriod;

  Map<DateTime, List<Event>> allEvents = {};

  late DateTime _selectedDay;
  late List<Event> _selectedDayEvents;

  @override
  Widget build(BuildContext context) {
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
                  _selectedDayEvents.isNotEmpty
                      ? _selectedDayEvents.first.color.withOpacity(.1)
                      : Colors.pink.withOpacity(.1),
                ],
              ),
            ),
            child: ListView(
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
                ValueListenableBuilder(
                  valueListenable: _calendarFormat,
                  builder: (context, _, __) {
                    return TableCalendar(
                      calendarFormat: _calendarFormat.value,
                      firstDay: DateTime(2010, 10, 16),
                      lastDay: _lastCalendarDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
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
                        final ovulationDays = FertilityCalculator(
                          lastCalendarDay: _lastCalendarDay,
                          cycleLength: 28,
                          lastPeriod: lastPeriod,
                        ).ovulation;
                        for (int i = 0; i < ovulationDays.length; i++) {
                          if (isSameDay(ovulationDays[i], day)) {
                            List<Event> events = [
                              Event(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Ovulation Day",
                                        style: TextStyle().copyWith(
                                            color: materialWhite,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900)),
                                    Text('High possibility of getting pregnant',
                                        textAlign: TextAlign.center,
                                        style: TextStyle().copyWith(
                                          color: materialWhite,
                                          fontSize: 18,
                                        ))
                                  ],
                                ),
                                type: EventType.OVULATION,
                                color: Colors.blue,
                              )
                            ];
                            allEvents[day] = [...?allEvents[day], ...events];
                            return events;
                          }
                        }

                        final fertileWindow = FertilityCalculator(
                          lastCalendarDay: _lastCalendarDay,
                          cycleLength: 28,
                          lastPeriod: lastPeriod,
                        ).fertileWindow;

                        for (int i = 0; i < fertileWindow.length; i++) {
                          for (int j = 0; j < fertileWindow[i].length; j++) {
                            if (isSameDay(fertileWindow[i][j], day)) {
                              List<Event> events = [
                                Event(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Fertile Window",
                                        style: TextStyle().copyWith(
                                          color: materialWhite,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text('Possibility of getting pregnant',
                                          textAlign: TextAlign.center,
                                          style: TextStyle().copyWith(
                                            color: materialWhite,
                                            fontSize: 18,
                                          ))
                                    ],
                                  ),
                                  type: EventType.FERTILE_WINDOW,
                                  color: Colors.teal,
                                )
                              ];
                              allEvents[day] = [...?allEvents[day], ...events];
                              return events;
                            }
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
                              List<Event> events = [
                                Event(
                                  title: Text(
                                    'Period day ${j + 1}',
                                    style: TextStyle().copyWith(
                                      color: materialWhite,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  type: EventType.MESTRUAL_FLOW,
                                  color: Colors.pink,
                                )
                              ];
                              allEvents[day] = [...?allEvents[day], ...events];
                              return events;
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
                            events = events as List<Event>;

                            if (events[0].type == EventType.FERTILE_WINDOW) {
                              return Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: events[0].color),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                    child: Text(
                                      day.day.toString(),
                                      style: TextStyle()
                                          .copyWith(color: events[0].color),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: events[0].color,
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
                          }
                          return null;
                        },
                      ),
                      onDaySelected: onDaySelected,
                    );
                  },
                ),
                SizedBox(height: 50.0),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.height / 3,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: _selectedDayEvents.isNotEmpty
                          ? _selectedDayEvents.first.color
                          : Colors.white,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height / 3),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedDayEvents.isNotEmpty
                              ? _selectedDayEvents.first.color.shade300
                              : Colors.grey.shade300,
                          blurRadius: 0.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _selectedDayEvents.isNotEmpty
                                ? _selectedDayEvents.first.color.shade200
                                : Colors.grey.shade200,
                            _selectedDayEvents.isNotEmpty
                                ? _selectedDayEvents.first.color.shade300
                                : Colors.grey.shade300,
                            _selectedDayEvents.isNotEmpty
                                ? _selectedDayEvents.first.color.shade400
                                : Colors.grey.shade400,
                            _selectedDayEvents.isNotEmpty
                                ? _selectedDayEvents.first.color.shade500
                                : Colors.grey.shade500,
                          ],
                          stops: [
                            0.1,
                            0.3,
                            0.8,
                            0.9
                          ]),
                    ),
                    child: Center(
                      child: _selectedDayEvents.isNotEmpty
                          ? _selectedDayEvents.first.title
                          : Text(
                              "Today seems like a good day",
                              textAlign: TextAlign.center,
                              style: TextStyle().copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDay, _selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = selectedDay;
        _selectedDayEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return allEvents[day] ?? [];
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

  void _getAllMenstrualFlowDays() {
    final period = FertilityCalculator(
            lastCalendarDay: _lastCalendarDay,
            cycleLength: 28,
            lastPeriod: lastPeriod)
        .nextPeriod;

    for (int i = 0; i < period.length; i++) {
      for (int j = 0; j < period[i].length; j++) {
        List<Event> events = [
          Event(
            title: Text(
              'Period day ${j + 1}',
              style: TextStyle().copyWith(
                color: materialWhite,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            type: EventType.MESTRUAL_FLOW,
            color: Colors.pink,
          )
        ];
        allEvents[period[i][j]] = [...?allEvents[period[i][j]], ...events];
      }
    }
  }

  void _getAllOvulationDays() {
    final ovulationDays = FertilityCalculator(
      lastCalendarDay: _lastCalendarDay,
      cycleLength: 28,
      lastPeriod: lastPeriod,
    ).ovulation;
    for (int i = 0; i < ovulationDays.length; i++) {
      List<Event> events = [
        Event(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Ovulation Day",
                  style: TextStyle().copyWith(
                      color: materialWhite,
                      fontSize: 25,
                      fontWeight: FontWeight.w900)),
              Text('High possibility of getting pregnant',
                  textAlign: TextAlign.center,
                  style: TextStyle().copyWith(
                    color: materialWhite,
                    fontSize: 18,
                  ))
            ],
          ),
          type: EventType.OVULATION,
          color: Colors.teal,
        )
      ];
      allEvents[ovulationDays[i]] = [
        ...events,
        ...?allEvents[ovulationDays[i]],
      ];
    }
  }

  void _getAllFertileWindows() {
    final fertileWindow = FertilityCalculator(
      lastCalendarDay: _lastCalendarDay,
      cycleLength: 28,
      lastPeriod: lastPeriod,
    ).fertileWindow;

    for (int i = 0; i < fertileWindow.length; i++) {
      for (int j = 0; j < fertileWindow[i].length; j++) {
        List<Event> events = [
          Event(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fertile Window",
                  style: TextStyle().copyWith(
                    color: materialWhite,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text('Possibility of getting pregnant',
                    textAlign: TextAlign.center,
                    style: TextStyle().copyWith(
                      color: materialWhite,
                      fontSize: 18,
                    ))
              ],
            ),
            type: EventType.FERTILE_WINDOW,
            color: Colors.teal,
          )
        ];
        allEvents[fertileWindow[i][j]] = [
          ...?allEvents[fertileWindow[i][j]],
          ...events
        ];
      }
    }
  }

  @override
  void initState() {
    lastPeriod = DateTime.fromMillisecondsSinceEpoch(
            Hive.box("period_tracker").get("lastPeriod"))
        .toLocal();

    DateTime now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;

    _getAllMenstrualFlowDays();
    _getAllFertileWindows();
    _getAllOvulationDays();

    _selectedDayEvents = _getEventsForDay(_selectedDay);
    super.initState();
  }
}
