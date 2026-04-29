import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../providers/task_providers.dart';
import 'widgets/day_task_list.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(allTasksProvider);

    List<dynamic> eventLoader(DateTime day) {
      final tasks = allTasks.valueOrNull ?? [];
      return tasks.where((t) {
        if (t.dueDate == null) return false;
        final due = t.dueDate!;
        return due.year == day.year &&
            due.month == day.month &&
            due.day == day.day;
      }).toList();
    }

    final dateFormat = DateFormat.yMMMd('zh_CN');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.calendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar — natural size (roughly half the screen)
          TableCalendar(
              locale: 'zh',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
              },
              eventLoader: eventLoader,
              rowHeight: 40,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;
                  final isSelected =
                      _selectedDay != null && isSameDay(date, _selectedDay);
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 16,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(2),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withAlpha(50),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                headerMargin: EdgeInsets.only(bottom: 2),
                headerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
          ),
          const Divider(height: 1),
          // Date header + add button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDay != null
                      ? dateFormat.format(_selectedDay!)
                      : '选择日期',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final dueDate = _selectedDay != null
                        ? DateTime(
                            _selectedDay!.year,
                            _selectedDay!.month,
                            _selectedDay!.day,
                            12,
                          )
                        : null;
                    context.pushNamed(
                      'taskNew',
                      queryParameters: dueDate != null
                          ? {
                              'dueDate':
                                  dueDate.millisecondsSinceEpoch.toString(),
                            }
                          : {},
                    );
                  },
                  tooltip: AppStrings.newTask,
                ),
              ],
            ),
          ),
          // Task list — bottom half
          Expanded(
            flex: 1,
            child: _selectedDay != null
                ? _buildTaskList(_selectedDay!)
                : const EmptyCalendarPrompt(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(DateTime day) {
    final tasksAsync = ref.watch(tasksByDateProvider(day));

    return tasksAsync.when(
      loading: () => const LoadingWidget(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(tasksByDateProvider(day)),
      ),
      data: (tasks) => DayTaskList(tasks: tasks, selectedDay: day),
    );
  }
}

class EmptyCalendarPrompt extends StatelessWidget {
  const EmptyCalendarPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '选择日期以查看任务',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}
