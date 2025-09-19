import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final bool isNew;
  final String routeName;
  final Map<String, dynamic>? parameters;

  const MenuItemModel({
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle,
    this.isNew = false,
    required this.routeName,
    this.parameters,
  });

  bool get hasSubtitle => subtitle != null && subtitle!.isNotEmpty;
}
