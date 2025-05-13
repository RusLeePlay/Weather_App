// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle heading = GoogleFonts.prompt(
      textStyle: const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  ));
  static TextStyle body = GoogleFonts.prompt(
      textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Color.fromARGB(255, 255, 255, 255),
  ));
  static TextStyle main = GoogleFonts.prompt(
      textStyle: const TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  ));
  static TextStyle sign = GoogleFonts.prompt(
      textStyle: const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  ));

  static TextStyle varBody = GoogleFonts.prompt(
      textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.amber,
    shadows: [
      Shadow(
          offset: Offset(1, 1),
          blurRadius: 5,
          color: Color.fromARGB(105, 0, 0, 0))
    ],
  ));
  static TextStyle clockStyle = GoogleFonts.jura(
      textStyle: const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(114, 0, 0, 0),
  ));
  static TextStyle buttonBody = GoogleFonts.prompt(
      textStyle: const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.normal,
    color: Color.fromARGB(255, 255, 255, 255),
  ));

  static TextStyle details = GoogleFonts.jura(
      textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(149, 251, 251, 251)));

  static TextStyle day_additional = GoogleFonts.prompt(
      textStyle: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 255, 255)));
  static TextStyle weatherdetails = GoogleFonts.jura(
      textStyle: const TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ));
  static TextStyle prev = GoogleFonts.jura(
      textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(114, 0, 0, 0),
  ));
}
