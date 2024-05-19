import 'package:flutter/material.dart';

class FollowingEmptyPage extends StatelessWidget {
  const FollowingEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New videos right to you',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
              child: Text(
                'Follow to get the latest videos from user you love.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
