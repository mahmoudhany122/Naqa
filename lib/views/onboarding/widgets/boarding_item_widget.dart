import 'package:flutter/material.dart';
import '../../../models/boarding_model.dart';

Widget buildBoardingItem(BoardingModel model) => Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.asset(
      model.image,
      height: 300,
      fit: BoxFit.cover,
    ),
    const SizedBox(height: 10.0),
    Center(
      child: Text(
        model.title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const SizedBox(height: 5),
    Center(
      child: Text(
        model.title1,
        style: const TextStyle(fontSize: 20),
      ),
    ),
    const SizedBox(height: 10.0),
    Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          model.body,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  ],
);