import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompletionCheckbox extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onToggle;
  final double size;

  const CompletionCheckbox({
    super.key,
    required this.isCompleted,
    required this.onToggle,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: 200.ms,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted
              ? theme.colorScheme.primary
              : Colors.transparent,
          border: Border.all(
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withAlpha(100),
            width: 2,
          ),
        ),
        child: isCompleted
            ? Icon(
                Icons.check,
                size: size - 6,
                color: theme.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
