import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../screens/inbox/inbox_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/matrix/matrix_screen.dart';
import '../screens/task_detail/task_detail_screen.dart';
import '../shared_widgets/app_scaffold.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(AutoDisposeProviderRef<GoRouter> ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/inbox',
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inbox',
                name: 'inbox',
                builder: (context, state) => const InboxScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                name: 'calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/matrix',
                name: 'matrix',
                builder: (context, state) => const MatrixScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/task/new',
        name: 'taskNew',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            const TaskDetailScreen(mode: TaskDetailMode.create),
      ),
      GoRoute(
        path: '/task/:id',
        name: 'taskDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(mode: TaskDetailMode.edit, taskId: id);
        },
      ),
    ],
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
