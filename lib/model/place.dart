import 'package:flutter/material.dart';

class Place {
  final UniqueKey id;
  final String name;
  final String address;
  final String icon;
  final String iconBgColor;
  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.icon,
    required this.iconBgColor,
  });
}
