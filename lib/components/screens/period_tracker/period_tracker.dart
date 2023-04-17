import 'package:dart_date/dart_date.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/period_tracker/cycle_settings.dart';
import 'package:smartrr/services/period_tracker_service.dart';
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
  late DateTime now;
  late List<Event> _selectedDayEvents;
  late DateTime _selectedDay;

  late List<DateTime> _ovulationDays;
  late List<List<DateTime>> _period;
  late List<List<DateTime>> _fertileWindow;

  final DateTime _lastCalendarDay = DateTime(DateTime.now().year + 1);

  final Map<DateTime, List<Event>> allEvents = {};

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
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Period Tracker",
              style: TextStyle().copyWith(color: materialWhite),
            ),
            centerTitle: true,
            backgroundColor: primaryColor,
            iconTheme: IconThemeData().copyWith(color: materialWhite),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CycleSettings(),
                        ));
                  },
                  icon: Icon(Icons.settings))
            ],
          ),
          backgroundColor: Color(0xFFEEEEEE),
          body: ListView(
            padding: EdgeInsets.only(left: 30, top: 30, right: 30),
            children: [
              Container(
                height: 450,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: materialWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: _lastCalendarDay,
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  daysOfWeekHeight: 20,
                  daysOfWeekStyle:
                      DaysOfWeekStyle(dowTextFormatter: weekDayBuilder),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(outsideDaysVisible: false),
                  availableCalendarFormats: {CalendarFormat.month: "Month"},
                  // onPageChanged: (focusedDay) =>
                  //     onDaySelected(focusedDay, _selectedDay),
                  eventLoader: (day) {
                    for (int i = 0; i < _ovulationDays.length; i++) {
                      if (isSameDay(_ovulationDays[i], day)) {
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
                        return events;
                      }
                    }

                    for (int i = 0; i < _fertileWindow.length; i++) {
                      for (int j = 0; j < _fertileWindow[i].length; j++) {
                        if (isSameDay(_fertileWindow[i][j], day)) {
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
                          return events;
                        }
                      }
                    }

                    for (int i = 0; i < _period.length; i++) {
                      for (int j = 0; j < _period[i].length; j++) {
                        if (isSameDay(_period[i][j], day)) {
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
                                  style:
                                      TextStyle().copyWith(color: Colors.white),
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
                ),
              ),
              SizedBox(height: 22.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  color: materialWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        isSameDay(_selectedDay, now)
                            ? Text(
                                "Today",
                                style: TextStyle().copyWith(
                                  color: _selectedDayEvents.isNotEmpty
                                      ? _selectedDayEvents.first.color
                                      : darkGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Text(
                                "${_selectedDay.toHumanString().substring(0, _selectedDay.toHumanString().length - 6)}",
                                style: TextStyle().copyWith(
                                  color: _selectedDayEvents.isNotEmpty
                                      ? _selectedDayEvents.first.color
                                      : darkGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                      ],
                    ),
                    SizedBox(height: 13),
                    Center(
                      child: Container(
                        height: 156,
                        width: 156,
                        decoration: BoxDecoration(
                          color: _selectedDayEvents.isNotEmpty
                              ? _selectedDayEvents.first.color.withOpacity(.5)
                              : Color(0xFFEEEEEE).withOpacity(.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Container(
                            height: 140,
                            width: 140,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: _selectedDayEvents.isNotEmpty
                                  ? _selectedDayEvents.first.color
                                  : Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: _selectedDayEvents.isNotEmpty
                                  ? _selectedDayEvents.first.title
                                  : Text(
                                      "Today seems like a good day",
                                      textAlign: TextAlign.center,
                                      style: TextStyle().copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDay, _selectedDay)) {
      selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      setState(() {
        _selectedDay = selectedDay;
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
      cycleLength: PeriodTrackerService.getCycleLength!,
      lastPeriod: PeriodTrackerService.getLastPeriod!,
      lutealPhaseLength: PeriodTrackerService.getLutealPhaseLength!,
    ).menstrualCycle;

    _period = period;

    for (int i = 0; i < period.length; i++) {
      for (int j = 0; j < period[i].length; j++) {
        List<Event> events = [
          Event(
            title: Text(
              'Period day ${j + 1}',
              style: TextStyle().copyWith(
                color: materialWhite,
                fontSize: 16,
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
      cycleLength: PeriodTrackerService.getCycleLength!,
      lastPeriod: PeriodTrackerService.getLastPeriod!,
      lutealPhaseLength: PeriodTrackerService.getLutealPhaseLength!,
    ).ovulation;
    _ovulationDays = ovulationDays;

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
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
              Text('High possibility of getting pregnant',
                  textAlign: TextAlign.center,
                  style: TextStyle().copyWith(
                    color: materialWhite,
                    fontSize: 12,
                  ))
            ],
          ),
          type: EventType.OVULATION,
          color: Colors.blue,
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
      cycleLength: PeriodTrackerService.getCycleLength!,
      lastPeriod: PeriodTrackerService.getLastPeriod!,
      lutealPhaseLength: PeriodTrackerService.getLutealPhaseLength!,
    ).fertileWindow;

    _fertileWindow = fertileWindow;

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
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text('Possibility of getting pregnant',
                    textAlign: TextAlign.center,
                    style: TextStyle().copyWith(
                      color: materialWhite,
                      fontSize: 12,
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
    now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);

    _getAllMenstrualFlowDays();
    _getAllFertileWindows();
    _getAllOvulationDays();

    _selectedDayEvents = _getEventsForDay(_selectedDay);
    super.initState();
  }
}
