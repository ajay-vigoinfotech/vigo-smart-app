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
            context, MaterialPageRoute(builder: (context) => nextPage));
      },
      child: Card(
        elevation: 10,
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  modulename,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}