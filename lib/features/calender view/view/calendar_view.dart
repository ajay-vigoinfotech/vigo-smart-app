import 'package:flutter/material.dart';

import '../view model/calendar_view_model.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarViewModel calendarViewModel = CalendarViewModel();
  List<Map<String, dynamic>> getCalendarResponseListData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    fetchCalendarResponseListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar View '),
      ),
    );
  }

  Future<void> fetchCalendarResponseListData() async {
    String? token = await calendarViewModel.sessionManager.getToken();

    if (token != null) {
      await calendarViewModel.fetchCalendarResponseList(token);

      setState(() {
        getCalendarResponseListData = calendarViewModel.getCalendarResponseList!
            .map((entry) => {
                  'attendanceDate': entry.attendanceDate,
                  'code': entry.code,
                  'status': entry.status,
                })
            .toList();
      });
    }
  }
}
