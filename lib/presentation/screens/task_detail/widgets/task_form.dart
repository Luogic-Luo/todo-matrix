import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../domain/enums/task_priority.dart';
import '../../../../domain/enums/eisenhower_quadrant.dart';

class TaskForm extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final DateTime? dueDate;
  final TaskPriority priority;
  final EisenhowerQuadrant quadrant;
  final ValueChanged<DateTime?> onDueDateChanged;
  final ValueChanged<TaskPriority> onPriorityChanged;
  final ValueChanged<EisenhowerQuadrant> onQuadrantChanged;

  const TaskForm({
    super.key,
    required this.titleCtrl,
    required this.descCtrl,
    this.dueDate,
    required this.priority,
    required this.quadrant,
    required this.onDueDateChanged,
    required this.onPriorityChanged,
    required this.onQuadrantChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            hintText: AppStrings.titleHint,
            labelText: '标题',
          ),
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
        ),
        const Gap(AppDimensions.paddingL),
        TextField(
          controller: descCtrl,
          decoration: const InputDecoration(
            hintText: AppStrings.descriptionHint,
            labelText: '描述',
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        const Gap(AppDimensions.paddingL),

        // Due date picker
        _buildDatePicker(context, theme),
        const Gap(AppDimensions.paddingL),

        // Priority selector
        _buildPrioritySelector(theme),
        const Gap(AppDimensions.paddingL),

        // Quadrant selector
        _buildQuadrantSelector(theme),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: dueDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          // Preserve time if it was set, otherwise use noon
          final newDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            dueDate?.hour ?? 12,
            dueDate?.minute ?? 0,
          );
          onDueDateChanged(newDate);
        }
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '截止日期',
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          dueDate != null
              ? DateFormat.yMMMd().format(dueDate!)
              : '无截止日期',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: dueDate != null
                ? theme.colorScheme.onSurface
                : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('优先级',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            )),
        const Gap(AppDimensions.paddingS),
        Wrap(
          spacing: AppDimensions.paddingS,
          children: TaskPriority.values.map((p) {
            final isSelected = p == priority;
            return ChoiceChip(
              label: Text(p.shortLabel),
              selected: isSelected,
              onSelected: (_) => onPriorityChanged(p),
              selectedColor: _priorityChipColor(p).withAlpha(40),
              labelStyle: TextStyle(
                color: isSelected ? _priorityChipColor(p) : null,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuadrantSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('象限',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            )),
        const Gap(AppDimensions.paddingS),
        Wrap(
          spacing: AppDimensions.paddingS,
          runSpacing: AppDimensions.paddingS,
          children: EisenhowerQuadrant.values.map((q) {
            final isSelected = q == quadrant;
            return ChoiceChip(
              label: Text(q.description),
              selected: isSelected,
              onSelected: (_) => onQuadrantChanged(q),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _priorityChipColor(TaskPriority p) {
    return switch (p) {
      TaskPriority.p1 => Colors.red,
      TaskPriority.p2 => Colors.orange,
      TaskPriority.p3 => Colors.green,
      TaskPriority.p4 => Colors.grey,
    };
  }
}
