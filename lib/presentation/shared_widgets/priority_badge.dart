import 'package:flutter/material.dart';
import '../../domain/enums/task_priority.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final label = compact ? priority.name.toUpperCase() : priority.shortLabel;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _color {
    return switch (priority) {
      TaskPriority.p1 => Colors.red,
      TaskPriority.p2 => Colors.orange,
      TaskPriority.p3 => Colors.green,
      TaskPriority.p4 => Colors.grey,
    };
  }
}
