import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/auth/view/profile_page.dart';
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
      'icon': AppConstants.markDutyIcon,
      'name': Strings.markDuty,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },{
      'icon': AppConstants.markDutyIcon,
      'name': Strings.markDuty,
      'color': Pallete.btn1,
      'page': ProfilePage(),
    },
    // Add more modules here
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the available height dynamically
    final screenHeight = MediaQuery.of(context).size.height;
    final infoScreenHeight = screenHeight * 0.2; // 20% of the screen height
    final gridPadding = screenHeight * 0.01; // 2% of the screen height

    return Scaffold(
      body: Column(
        children: [
          InfoScreen(barheight: infoScreenHeight),
          SizedBox(
              height:
                  gridPadding),
          // Dynamic space between InfoScreen and the grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: gridPadding),
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
        ],
      ),
    );
  }
}
