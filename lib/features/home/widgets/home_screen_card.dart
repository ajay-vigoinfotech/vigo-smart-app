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
        elevation: 6, // Subtle shadow for better card appearance
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Slightly sharper corners
        ),
        child: Container(
          padding: const EdgeInsets.all(15), // Maintain padding inside the card
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16), // Match the card's border radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTheme(
                data: const IconThemeData(color: Colors.white, size: 50), // Icon size and color
                child: icon,
              ),
              const SizedBox(width: 20), // Increased space between icon and text for balance
              Expanded(
                child: Text(
                  modulename,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 21, // Slightly smaller for balance
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios, // Add a forward arrow for navigation feedback
                color: Colors.white54,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
