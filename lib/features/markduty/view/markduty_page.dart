import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../viewmodel/get_current_date_view_model.dart';

class MarkdutyPage extends StatefulWidget {
  const MarkdutyPage({super.key});

  @override
  State<MarkdutyPage> createState() => _MarkdutyPageState();
}

class _MarkdutyPageState extends State<MarkdutyPage> {
  String? timeDateIn;

  @override
  void initState() {
    super.initState();
    _loadCurrentDateTime();
  }

  Future<void> _loadCurrentDateTime() async {
    final sessionManager = SessionManager();
    final getCurrentDateViewModel = GetCurrentDateViewModel();

    try {
      // Fetch current date from the API
      final currentDateTime = await getCurrentDateViewModel.getTimeDate();

      if (currentDateTime != null) {
        // Format and save the date from the API
        final formattedDateTime = Utils.formatDateTime(currentDateTime);
        await sessionManager.saveCurrentDateTime(formattedDateTime);
        setState(() {
          timeDateIn = formattedDateTime;
        });
      } else {
        // If API fails or returns null, fallback to device time
        _setDeviceDateTime();
      }
    } catch (e) {
      // In case of error, fallback to device time
      _setDeviceDateTime();
    }
  }

  void _setDeviceDateTime() {
    String currentDateTime = DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
    setState(() {
      timeDateIn = currentDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Text(
                timeDateIn ?? 'Loading...', // Display the timeDateIn or loading text
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 300,
            width: double.infinity,
            child: MapPage(latLong: ''),
          ),
        ],
      ),
    );
  }
}
