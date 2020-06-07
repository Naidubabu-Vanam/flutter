import 'package:flutter/material.dart';
import './app_screens/interest_calculation.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Interest Calulator",
      home: InterestForm(),
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.dark,
      )));
}
