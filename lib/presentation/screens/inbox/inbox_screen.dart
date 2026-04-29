import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../providers/task_providers.dart';
import 'widgets/quick_add_bar.dart';
import 'widgets/inbox_task_tile.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(inboxTasksProvider);
    final doneAsync = ref.watch(doneTasksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.inbox),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(inboxTasksProvider);
                ref.invalidate(doneTasksProvider);
              },
              child: tasksAsync.when(
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(
                  message: e.toString(),
                  onRetry: () {
                    ref.invalidate(inboxTasksProvider);
                    ref.invalidate(doneTasksProvider);
                  },
                ),
                data: (tasks) {
                  return CustomScrollView(
                    slivers: [
                      if (tasks.isEmpty)
                        const SliverToBoxAdapter(child: SizedBox.shrink())
                      else
                        SliverReorderableList(
                          itemCount: tasks.length,
                          onReorder: (oldIndex, newIndex) {
                            ref
                                .read(taskActionsProvider.notifier)
                                .reorderInboxTasks(oldIndex, newIndex);
                          },
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Padding(
                              key: ValueKey(task.id),
                              padding: EdgeInsets.only(
                                left: AppDimensions.paddingL,
                                right: AppDimensions.paddingL,
                                top: index == 0 ? AppDimensions.paddingL : 0,
                                bottom: AppDimensions.paddingS,
                              ),
                              child: InboxTaskTile(task: task)
                                  .animate()
                                  .fadeIn(
                                    duration: 300.ms,
                                    delay: (index * 50).ms,
                                  )
                                  .slideX(
                                    begin: 0.1,
                                    end: 0,
                                    duration: 300.ms,
                                    delay: (index * 50).ms,
                                  ),
                            );
                          },
                        ),
                      SliverToBoxAdapter(
                        child: doneAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (doneTasks) {
                            if (doneTasks.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingL,
                              ),
                              child: Column(
                                children: [
                                  const Gap(AppDimensions.paddingM),
                                  const Divider(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusM),
                                    onTap: () => setState(() =>
                                        _showCompleted = !_showCompleted),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingM,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _showCompleted
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            size: 20,
                                            color: theme.colorScheme.outline,
                                          ),
                                          const Gap(AppDimensions.paddingS),
                                          Text(
                                            '已完成 (${doneTasks.length})',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color:
                                                  theme.colorScheme.outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_showCompleted)
                                    ...doneTasks.map(
                                      (task) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppDimensions.paddingS,
                                        ),
                                        child: InboxTaskTile(task: task),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const QuickAddBar(),
        ],
      ),
    );
  }
}
