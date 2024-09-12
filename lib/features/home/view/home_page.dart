import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../markduty/view/mark_duty_page.dart';
import '../widgets/home_screen_card.dart';
import '../widgets/info_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> modules = [
    {
      'code': 'SupervisorDutyManagementApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.markDuty,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final gridPadding = screenHeight * 0.01;

    return Scaffold(
      body: Column(
        children: [
          const InfoScreen(barheight: 150),
          SizedBox(height: gridPadding),
          Expanded(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return HomeScreenCard(
                      icon: module['icon'],
                      modulename: module['name'],
                      cardColor: module['color'],
                      nextPage: module['page'],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
