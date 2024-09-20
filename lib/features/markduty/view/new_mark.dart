import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkDuty extends StatefulWidget {
  const MarkDuty({Key? key}) : super(key: key);

  @override
  State<MarkDuty> createState() => _MarkDutyState();
}

class _MarkDutyState extends State<MarkDuty> {
  String? inTimestamp;
  String? outTimestamp;
  List<String> punchHistory = [];
  bool isOnLeaveOrWeekOff = false;
  DateTime? leaveStartDate;
  bool isWeekOffApplied = false;

  @override
  Widget build(BuildContext context) {
    String currentDateTime = DateFormat('dd MMM yyyy').format(DateTime.now());
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mark Duty'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'PUNCH'),
              Tab(text: 'PUNCH HISTORY'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPunchTab(currentDateTime, currentTime),
                  _buildPunchHistoryTab(),
                ],
              ),
            ),],
        ),
      ),
    );
  }

  Widget _buildPunchTab(String currentDateTime, String currentTime) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [


              const Text(
                'Current Date and Time:',
                style: TextStyle(fontSize: 18),
              ),


              const SizedBox(height: 10),


              Text(
                '$currentDateTime / $currentTime',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),


        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [


            ElevatedButton.icon(
              icon: const Icon(Icons.input, color: Colors.white),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                fixedSize: MaterialStateProperty.all(const Size(170, 50)),
              ),
              onPressed: () {
                _handlePunch('Punch In');
              },
              label: const Text('Punch In', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),


            ElevatedButton.icon(
              icon: const Icon(Icons.output, color: Colors.white),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                fixedSize: MaterialStateProperty.all(const Size(170, 50)),
              ),
              onPressed: () {
                _handlePunch('Punch Out');
              },
              label: const Text('Punch Out', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),


          ],
        ),


        const SizedBox(height: 10),


        ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            fixedSize: MaterialStateProperty.all(const Size(200, 50)),
          ),
          onPressed: () async {
            await _confirmLeave();
          },
          icon: const Icon(Icons.leave_bags_at_home, color: Colors.white),
          label: const Text('Leave', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),


        const SizedBox(height: 10),


        ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            fixedSize: MaterialStateProperty.all(const Size(200, 50)),
          ),
          onPressed: () async {
            await _confirmWeekOff();
          },
          icon: const Icon(Icons.next_week_outlined, color: Colors.white),
          label: const Text('Week Off', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),


        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPunchHistoryTab() {
    return ListView.builder(
      itemCount: punchHistory.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                punchHistory[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handlePunch(String type) {
    if (type == 'Punch In' && inTimestamp != null) {
      _showErrorDialog('You have already Punched In.');
    } else if (type == 'Punch Out' && (inTimestamp == null || outTimestamp != null)) {
      _showErrorDialog('You must Punch In first before Punching Out, or you have already Punched Out.');
    } else if (isOnLeaveOrWeekOff) {
      _showErrorDialog('You cannot Punch In or Punch Out during Leave or Week Off.');
    } else {
      setState(() {
        String timestamp = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
        print('$type Timestamp: $timestamp');
        if (type == 'Punch In') {
          inTimestamp = timestamp;
        } else {
          outTimestamp = timestamp;
        }
      });

      _handlePunchHistory(type);

    }
  }

  Future<void> _confirmLeave() async {
    if (leaveStartDate == null || DateTime.now().difference(leaveStartDate!) > Duration(days: 1)) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Leave Confirmation'),
          content: const Text('Are you sure you want to apply for leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (confirmed ?? false) {
        setState(() {
          isOnLeaveOrWeekOff = true;
          leaveStartDate = DateTime.now();
        });

        _handlePunchHistory('Applied for Leave');
      }
    } else {
      _showErrorDialog('You have already applied for leave today.');
    }
  }

  Future<void> _confirmWeekOff() async {
    if (!isWeekOffApplied) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Week Off Confirmation'),
          content: const Text('Are you sure you want to take a Week Off?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (confirmed ?? false) {
        setState(() {
          isOnLeaveOrWeekOff = true;
          isWeekOffApplied = true;
        });

        _handlePunchHistory('Took a Week off');
      }
    } else {
      _showErrorDialog('You have already taken a Week Off.');
    }
  }

  void _handlePunchHistory(String type) {
    setState(() {
      String timestamp = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
      punchHistory.add('$type: $timestamp');
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}