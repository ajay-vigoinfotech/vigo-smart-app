import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import '../../home/view/home_page.dart';
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
  bool isLoading = false;
  String selectedDateStatus = '';
  DateTime selectedDate = DateTime.now();
  int _presentCount = 0;
  int _absentCount = 0;
  int _weekOffCount = 0;
  List<String> holidayDates = [];

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
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
                  height: 375,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CalendarCarousel<Event>(
                      headerMargin: const EdgeInsets.symmetric(vertical: 8.0),
                      // onHeaderTitlePressed: () => _selectDateFromPicker(),
                      headerTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      // showIconBehindDayText: true,
                      onDayPressed: (date, events) async {
                        setState(() {
                          selectedDate = date;
                          isLoading = true;
                        });
                        // final month = date.month.toString();
                        // final year = date.year.toString();
                        // await _fetchCalendarData(month, year);

                        final selectedDateString =
                            date.toIso8601String().split('T')[0];

                        final selectedDateData =
                            getCalendarResponseListData.firstWhere(
                          (entry) => entry['attendanceDate']
                              .startsWith(selectedDateString),
                          orElse: () => <String, String?>{},
                        );

                        setState(() {
                          if (selectedDateData.isNotEmpty) {
                            selectedDateStatus = selectedDateData['status'] ??
                                '';
                          } else {
                            selectedDateStatus = 'No status available!';
                          }
                          isLoading = false;
                        });
                      },
                      onCalendarChanged: (DateTime date) async {
                        setState(() {
                          isLoading = true;
                        });
                        final month = date.month;
                        final year = date.year;
                        await _fetchCalendarData(
                            month.toString(), year.toString());
                        setState(() {
                          isLoading = false;
                        });
                      },
                      markedDatesMap: _markedDateMap,
                      todayButtonColor: Colors.transparent,
                      todayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      selectedDayTextStyle:
                          const TextStyle(color: Colors.white),
                      minSelectedDate: DateTime(2015),
                      maxSelectedDate: DateTime.now(),
                      headerTitleTouchable: true,
                      weekendTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      daysTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      markedDateShowIcon: true,
                      showIconBehindDayText: true,
                      pageScrollPhysics: const ScrollPhysics(),
                      markedDateIconBuilder: (event) {
                        return event.icon ?? event.dot;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 75,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Status By Date',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          Text(
                            '${DateFormat('dd-MM-yyyy').format(selectedDate)} - $selectedDateStatus',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.black, width: 1),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Present Count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Absent Count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Leave Count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                          decoration: BoxDecoration(color: Colors.white),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$_presentCount',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$_absentCount',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$_weekOffCount',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                holidayDates.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                        'assets/images/ic_holiday.webp'),
                                  ),
                                  Text(
                                    'Upcoming Holidays:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                          ...holidayDates.map(
                            (holiday) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    holiday,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Holiday',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    'assets/images/ic_holiday.webp'),
                              ),
                              Text(
                                'Upcoming Holidays',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Text(
                            'No Holidays in the current month',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                SizedBox(height: 50),
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

    final selectedDateString = now.toIso8601String().split('T')[0];

    final selectedDateData = getCalendarResponseListData.firstWhere(
      (entry) => entry['attendanceDate'].startsWith(selectedDateString),
      orElse: () => <String, String?>{},
    );

    setState(() {
      selectedDate = now;
      if (selectedDateData.isNotEmpty) {
        selectedDateStatus =
            selectedDateData['status'] ?? 'No status available!';
      } else {
        selectedDateStatus = 'No status available!';
      }
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
        // Store the fetched data
        getCalendarResponseListData = calendarViewModel.getCalendarResponseList
                ?.map((entry) => {
                      'attendanceDate': entry.attendanceDate,
                      'code': entry.code,
                      'status': entry.status,
                    })
                .toList() ??
            [];

        // Build the event list for the calendar
        _markedDateMap = _buildEventList(getCalendarResponseListData);

        // Calculate the counts
        _calculateStatusCounts();

        holidayDates = getCalendarResponseListData
            .where((entry) => entry['code'] == 'H')
            .map((entry) => DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(entry['attendanceDate'])))
            .toList();
      });
    } else {
      debugPrint("Token is null. Unable to fetch data.");
    }
  }

  void _calculateStatusCounts() {
    int presentCount = 0;
    int absentCount = 0;
    int weekOffCount = 0;

    for (var item in getCalendarResponseListData) {
      switch (item['code']) {
        case 'P':
          presentCount++;
          break;
        case 'A':
          absentCount++;
          break;
        case 'WO':
          weekOffCount++;
          break;
        default:
          break;
      }
    }

    setState(() {
      _presentCount = presentCount;
      _absentCount = absentCount;
      _weekOffCount = weekOffCount;
    });
  }

  EventList<Event> _buildEventList(List<Map<String, dynamic>> data) {
    EventList<Event> eventList = EventList<Event>(events: {});

    for (var item in data) {
      DateTime eventDate = DateTime.parse(item['attendanceDate']);
      Event event;

      if (item['code'] == 'H') {
        event = Event(
          date: eventDate,
          title: item['status'],
          icon: Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/ic_holiday.webp',
              height: 25.0,
              width: 25.0,
            ),
          ),
        );
      } else {
        Color dotColor;

        switch (item['code']) {
          case 'A':
            dotColor = Colors.red;
            break;
          case 'P':
            dotColor = Colors.green;
            break;
          case 'WO':
            dotColor = Colors.orange;
            break;
          default:
            dotColor = Colors.grey;
        }

        event = Event(
          date: eventDate,
          title: item['status'],
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: dotColor,
            height: 5.0,
            width: 5.0,
          ),
        );
      }
      eventList.add(eventDate, event);
    }
    return eventList;
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Show dialog to ask user to turn on internet connection
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content:
          const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pushAndRemoveUntil(
                this.context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
              ),
              // Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
