import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:pomodoro/widgets/chart.dart';
import '../widgets/digital_clock.dart';

class TimeManagerScreen extends StatefulWidget {
  const TimeManagerScreen({Key? key}) : super(key: key);
  static const routeName = '/time-management';
  @override
  State<TimeManagerScreen> createState() => _TimeManagerScreenState();
}

class _TimeManagerScreenState extends State<TimeManagerScreen> {
  DateTime? selectedDay;
  List? selectedEvent;

  final Map<DateTime, List<CleanCalendarEvent>> _events = {
    // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
    //   CleanCalendarEvent('Event A',
    //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day, 10, 0),
    //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day, 12, 0),
    //       description: 'A special event',
    //       color: Colors.blue[700] as Color),
    // ],
    // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
    //     [
    //   CleanCalendarEvent('Event B',
    //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day + 2, 10, 0),
    //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day + 2, 12, 0),
    //       color: Colors.orange),
    //   CleanCalendarEvent('Event C',
    //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day + 2, 14, 30),
    //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day + 2, 17, 0),
    //       color: Colors.pink),
    // ],
  };

  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedEvent = _events[selectedDay] ?? [];
    });
    print(selectedDay);
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedEvent = _events[selectedDay] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60, left: 20),
                height: 150,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigitalClockBuilder(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: Lottie.network(
                              'https://assets6.lottiefiles.com/packages/lf20_if77rL.json',
                              fit: BoxFit.cover),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Mange Your Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xfff6f7dd),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(offset: Offset(6, 7), blurRadius: 18)
                    ]),
                height: 350,
                width: 350,
                child: Calendar(
                  startOnMonday: true,
                  selectedColor: Colors.blue,
                  todayColor: Colors.red,
                  eventColor: Colors.green,
                  eventDoneColor: Colors.amber,
                  bottomBarColor: Colors.deepOrange,
                  onRangeSelected: (range) {
                    print('Selected Day ${range.from}, ${range.to}');
                  },
                  onDateSelected: (date) {
                    return _handleData(date);
                  },
                  events: _events,
                  isExpanded: true,
                  dayOfWeekStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  bottomBarTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hideBottomBar: false,
                  isExpandable: true,
                  hideArrows: false,
                  weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10),
                  child: BarChartSample3())
            ],
          ),
        ),
      ),
    );
  }
}
