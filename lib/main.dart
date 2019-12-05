
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'true shoe',
      home: Scaffold(
        appBar: AppBar(
          title: Text('true shoe'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}