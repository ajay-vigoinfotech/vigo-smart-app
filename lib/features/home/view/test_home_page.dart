import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../markduty/view/mark_duty_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String>? moduleCodes;

  @override
  void initState() {
    super.initState();
    _loadModuleCodes();
  }

  Future<void> _loadModuleCodes() async {
    final sessionManager = SessionManager();
    final codes = await sessionManager.getModuleCodes();
    setState(() {
      moduleCodes = codes;
    });
  }

  // Method to return the customization for each module
  Map<String, dynamic>? _getModuleDetails(String moduleCode) {
    switch (moduleCode) {
      case 'markDuty':
        return {
          'icon': AppConstants.markDutyIcon,
          'name': Strings.markDuty,
          'color': Pallete.btn1,
          'page': const MarkDutyPage(),
        };
      case 'anotherModule':
        return {
          'icon': AppConstants.markDutyIcon,
          'name': Strings.markDuty,
          'color': Pallete.btn1,
          'page': const MarkDutyPage(),
        };
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (moduleCodes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final validModules = moduleCodes!
        .map((module) => _getModuleDetails(module))
        .where((details) => details != null)
        .toList();

    if (validModules.isEmpty) {
      return const Center(child: Text('No Valid Modules Found'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemCount: validModules.length,
      itemBuilder: (context, index) {
        final moduleDetails = validModules[index]!;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => moduleDetails['page'],
              ),
            );
          },
          child: Card(
            color: moduleDetails['color'],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(moduleDetails['icon'], size: 40),
                const SizedBox(height: 10),
                Text(
                  moduleDetails['name'],
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
