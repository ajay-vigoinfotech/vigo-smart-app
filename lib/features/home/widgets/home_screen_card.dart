import 'package:flutter/material.dart';

class HomeScreenCard extends StatelessWidget {
  final Widget icon;
  final String modulename;
  final Color cardColor;
  final Widget nextPage;

  const HomeScreenCard({
    super.key,
    required this.icon,
    required this.modulename,
    required this.nextPage,
    this.cardColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Make corners slightly rounded
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center( // Align contents to the center
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: [
                IconTheme( // Ensures the icon is white
                  data: const IconThemeData(color: Colors.white, size: 50), // Adjust the icon size and color
                  child: icon,
                ),
                const SizedBox(height: 1), // Add space between icon and text
                Text(
                  modulename,
                  textAlign: TextAlign.center, // Ensure text is centered
                  style: const TextStyle(
                    fontSize: 20, // Slightly reduced font size for balance
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
