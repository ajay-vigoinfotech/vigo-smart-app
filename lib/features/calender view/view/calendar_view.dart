import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../model/calendar_request_model.dart';
import '../view model/calendar_view_model.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarViewModel calendarViewModel = CalendarViewModel();
  List<Map<String, dynamic>> getCalendarResponseListData = [];
  EventList<Event> _markedDateMap = EventList<Event>(events: {});
  String _selectedDateDetails = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar View'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CalendarCarousel<Event>(
                      onDayPressed: (date, events) {
                        setState(() {
                          _selectedDateDetails = _getDateDetails(date);
                        });
                      },
                      onCalendarChanged: (DateTime date) async {
                        setState(() {
                          isLoading = true;
                        });
                        final month = date.month;
                        final year = date.year;
                        await _fetchCalendarData(month.toString(), year.toString());
                        setState(() {
                          isLoading = false;
                        });
                      },
                      markedDatesMap: _markedDateMap,
                      todayButtonColor : Colors.transparent,
                        todayTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                        ),
                        selectedDayTextStyle : TextStyle(color: Colors.white),
                      minSelectedDate: DateTime(2015),
                      maxSelectedDate: DateTime.now(),
                      headerTitleTouchable: true,
                      weekendTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                      ),
                      daysTextStyle: const TextStyle(
                        color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),
                      markedDateShowIcon: true,
                        showIconBehindDayText: true,
                      markedDateIconBuilder: (event) {
                        return event.dot;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedDateDetails.isNotEmpty
                      ? _selectedDateDetails
                      : 'Select a date to view details',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      isLoading = true;
    });
    final now = DateTime.now();
    await _fetchCalendarData(now.month.toString(), now.year.toString());
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchCalendarData(String month, String year) async {
    String? token = await calendarViewModel.sessionManager.getToken();

    if (token != null) {
      await calendarViewModel.fetchCalendarResponseList(
        token,
        CalendarRequestModel(month: month, year: year),
      );

      setState(() {
        getCalendarResponseListData = calendarViewModel.getCalendarResponseList
            ?.map((entry) => {
          'attendanceDate': entry.attendanceDate,
          'code': entry.code,
          'status': entry.status,
        })
            .toList() ??
            [];

        _markedDateMap = _buildEventList(getCalendarResponseListData);
      });
    } else {
      debugPrint("Token is null. Unable to fetch data.");
    }
  }

  EventList<Event> _buildEventList(List<Map<String, dynamic>> data) {
    EventList<Event> eventList = EventList<Event>(events: {});

    for (var item in data) {
      DateTime eventDate = DateTime.parse(item['attendanceDate']);
      Color dotColor;

      switch (item['code']) {
        case 'A':
          dotColor = Colors.red; // Absent
          break;
        case 'P':
          dotColor = Colors.green; // Present
          break;
        case 'WO':
          dotColor = Colors.orange; // Week Off
          break;
        case 'H':
          dotColor = Colors.blue; // Holiday
          break;
        default:
          dotColor = Colors.grey; // Default
      }

      eventList.add(
        eventDate,
        Event(
          date: eventDate,
          title: item['status'],
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: dotColor,
            height: 5.0,
            width: 5.0,
          ),
        ),
      );
    }

    return eventList;
  }

  String _getDateDetails(DateTime date) {
    final selectedDate = getCalendarResponseListData.firstWhere(
          (item) => DateTime.parse(item['attendanceDate']).isAtSameMomentAs(date),
      orElse: () => {'attendanceDate': '', 'status': 'No data available'},
    );

    return selectedDate['attendanceDate'].isNotEmpty
        ? 'Date: ${selectedDate['attendanceDate']}\nStatus: ${selectedDate['status']}'
        : selectedDate['status'];
  }
}
