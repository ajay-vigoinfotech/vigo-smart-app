import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/theme/app_pallete.dart';


class InfoScreen extends StatelessWidget {
  final double barheight;
  const InfoScreen({super.key, required this.barheight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barheight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Pallete.btn1,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 30,
              onPressed: () {
                // refresh logic here
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              iconSize: 30,
              onPressed: () {
                // notification logic here
              },
              icon: const Icon(Icons.notifications),
            ),
            GestureDetector(
              onTap: () {
                //print("you tapped");
                showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomSheet(
                    onClosing: () {},
                    builder: (context) => SizedBox(
                      height: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: AppConstants.settingsIcon,
                              title: const Text('Settings'),
                              onTap: () {
                                // Handle settings action
                              },
                            ),
                            ListTile(
                              leading: AppConstants.logoutIcon,
                              title: const Text('Logout'),
                              onTap: () {
                                // Handle settings action
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 40,
                // image or background color for the CircleAvatar
              ),
            ),
          ],
        ),
      ),
    );
  }
}