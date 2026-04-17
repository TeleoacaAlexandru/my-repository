import 'package:flutter/material.dart';

enum ItemCategory {
  groceries(icon: Icons.local_grocery_store, title: 'Groceries'),
  food(icon: Icons.restaurant, title: 'Food'),
  cleaning(icon: Icons.cleaning_services, title: 'Cleaning');

  const ItemCategory({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

enum Priority {
  urgent(color: Colors.red, title: 'Urgent'),
  high(color: Colors.orange, title: 'High'),
  medium(color: Colors.amber, title: 'Medium'),
  low(color: Colors.green, title: 'Low');

  const Priority({required this.color, required this.title});

  final Color color;
  final String title;
}

class Todo {
  const Todo({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
  });

  final String title;
  final String description;
  final Priority priority;
  final ItemCategory category;
}