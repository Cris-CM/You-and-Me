import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:you_and_me/core/home/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          title: 'You_And_Me',
          home: HomePage(),
        );
      },
    );
  }
}
