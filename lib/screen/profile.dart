import 'package:flutter/material.dart';

class profileee extends StatefulWidget {
  const profileee({super.key});

  @override
  State<profileee> createState() => _profileeeState();
}

class _profileeeState extends State<profileee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'this is profile page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
