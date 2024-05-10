import 'dart:math';

import 'package:animated_date_picker/colors.dart';
import 'package:animated_date_picker/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime selectedMonth;

  DateTime? selectedDate;

  bool isMinimized = true;
  int counter = 0;

  @override
  void initState() {
    selectedMonth = DateTime.now().monthStart;
    selectedDate = DateTime.now().dayStart;
    getCounter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: calendarGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Header(
                    selectedMonth: selectedMonth,
                    selectedDate: selectedDate,
                    isMinimized: isMinimized,
                    counter: counter,
                    onCounterChange: (value) {
                      setState(() {
                        counter = value;
                      });
                    },
                    onChange: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    },
                  ),
                  _Body(
                    selectedDate: selectedDate,
                    selectedMonth: selectedMonth,
                    counter: counter,
                    isMinimized: isMinimized,
                    selectDate: (DateTime value) => setState(() {
                      selectedDate = value;
                    }),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isMinimized = !isMinimized;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 15,
                        spreadRadius: 3,
                        color: machineGunMetal.withOpacity(0.4))
                  ], color: paperWhite, borderRadius: BorderRadius.circular(4)),
                  child: Icon(
                    isMinimized
                        ? CupertinoIcons.chevron_down
                        : CupertinoIcons.chevron_up,
                    size: 14,
                    color: machineGunMetal,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCounter() {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );

    DateTime today = DateTime.now();

    for (int i = 0; i < data.weeks.length; i++) {
      if (data.weeks[i].indexWhere((element) {
            return (element.date.day == today.day &&
                element.date.month == today.month &&
                element.date.year == today.year);
          }) !=
          -1) {
        setState(() {
          counter = i;
        });
      }
    }
  }
}

class _Body extends StatelessWidget {
  const _Body(
      {required this.selectedMonth,
      required this.selectedDate,
      required this.selectDate,
      this.counter = 0,
      this.isMinimized = false});

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final bool isMinimized;
  final int counter;

  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );
    TextStyle dayTextStyle =
        TextStyle(fontSize: 12, color: paperWhite, fontWeight: FontWeight.w600);

    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return AnimatedSize(
      curve: Curves.ease,
      duration: Duration(milliseconds: 400),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map((item) => Container(
                      width: 30,
                      child: Center(
                        child: Text(
                          item.toUpperCase(),
                          style: dayTextStyle,
                        ),
                      ),
                    ))
                .toList(),
          ),
          // const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isMinimized
                ? [
                    Row(
                      children: data.weeks[counter].map((d) {
                        return Expanded(
                          child: _RowItem(
                            hasRightBorder: false,
                            date: d.date,
                            isActiveMonth: d.isActiveMonth,
                            onTap: () => selectDate(d.date),
                            isSelected: selectedDate != null &&
                                selectedDate!.isSameDate(d.date),
                          ),
                        );
                      }).toList(),
                    ),
                  ]
                : [
                    for (var week in data.weeks)
                      Row(
                        children: week.map((d) {
                          return Expanded(
                            child: _RowItem(
                              hasRightBorder: false,
                              date: d.date,
                              isActiveMonth: d.isActiveMonth,
                              onTap: () => selectDate(d.date),
                              isSelected: selectedDate != null &&
                                  selectedDate!.isSameDate(d.date),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.hasRightBorder,
    required this.isActiveMonth,
    required this.isSelected,
    required this.date,
    required this.onTap,
  });

  final bool hasRightBorder;
  final bool isActiveMonth;
  final VoidCallback onTap;
  final bool isSelected;

  final DateTime date;
  @override
  Widget build(BuildContext context) {
    final int number = date.day;
    // final isToday = date.isToday;
    // final bool isPassed = date.isBefore(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: 35,
        decoration: isSelected
            ? BoxDecoration(
                color: paperWhite,
                shape: BoxShape.circle,
                boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                        color: machineGunMetal.withOpacity(0.5))
                  ])
            : null,
        child: Text(
          number.toString(),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isSelected
                  ? machineGunMetal
                  : isActiveMonth
                      ? paperWhite
                      : paperWhite.withOpacity(0.5)),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.selectedMonth,
      required this.selectedDate,
      required this.onChange,
      this.counter = 0,
      required this.onCounterChange,
      this.isMinimized = false});

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final bool isMinimized;
  final int counter;

  final ValueChanged<DateTime> onChange;
  final ValueChanged<int> onCounterChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                isMinimized && counter > 0
                    ? onCounterChange(counter - 1)
                    : onChange(selectedMonth.addMonth(-1));
              },
              icon: Icon(
                Icons.arrow_left_sharp,
                color: paperWhite,
              ),
            ),
            Expanded(
              child: Text(
                DateFormat('MMM yyyy').format(selectedMonth),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: paperWhite,
                    fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                isMinimized && counter < 4
                    ? onCounterChange(counter + 1)
                    : onChange(selectedMonth.addMonth(1));
              },
              icon: Icon(
                Icons.arrow_right_sharp,
                color: paperWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CalendarMonthData {
  final int year;
  final int month;

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);
  int get firstDayOfWeekIndex => 0;

  int get weeksCount => ((daysInMonth + firstDayOffset) / 7).ceil();

  const CalendarMonthData({
    required this.year,
    required this.month,
  });

  int get firstDayOffset {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    return (weekdayFromMonday - ((firstDayOfWeekIndex - 1) % 7)) % 7 - 1;
  }

  List<List<CalendarDayData>> get weeks {
    final res = <List<CalendarDayData>>[];
    var firstDayMonth = DateTime(year, month, 1);
    var firstDayOfWeek = firstDayMonth.subtract(Duration(days: firstDayOffset));

    for (var w = 0; w < weeksCount; w++) {
      final week = List<CalendarDayData>.generate(
        7,
        (index) {
          final date = firstDayOfWeek.add(Duration(days: index));

          final isActiveMonth = date.year == year && date.month == month;

          return CalendarDayData(
            date: date,
            isActiveMonth: isActiveMonth,
            isActiveDate: date.isToday,
          );
        },
      );
      res.add(week);
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
    }
    return res;
  }
}

class CalendarDayData {
  final DateTime date;
  final bool isActiveMonth;
  final bool isActiveDate;

  const CalendarDayData({
    required this.date,
    required this.isActiveMonth,
    required this.isActiveDate,
  });
}
