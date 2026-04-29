// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTasksHash() => r'b37054de138c7e31b5220ab86b2231677e37a24a';

/// See also [allTasks].
@ProviderFor(allTasks)
final allTasksProvider = AutoDisposeFutureProvider<List<Task>>.internal(
  allTasks,
  name: r'allTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTasksRef = AutoDisposeFutureProviderRef<List<Task>>;
String _$inboxTasksHash() => r'145caf333c10bac1485c4ea9e9cb91c9c2e2da4d';

/// See also [inboxTasks].
@ProviderFor(inboxTasks)
final inboxTasksProvider = AutoDisposeFutureProvider<List<Task>>.internal(
  inboxTasks,
  name: r'inboxTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inboxTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InboxTasksRef = AutoDisposeFutureProviderRef<List<Task>>;
String _$tasksByQuadrantHash() => r'2b95e7ed1853b67a4bccda63c693986f59bf65ce';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [tasksByQuadrant].
@ProviderFor(tasksByQuadrant)
const tasksByQuadrantProvider = TasksByQuadrantFamily();

/// See also [tasksByQuadrant].
class TasksByQuadrantFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [tasksByQuadrant].
  const TasksByQuadrantFamily();

  /// See also [tasksByQuadrant].
  TasksByQuadrantProvider call(
    EisenhowerQuadrant quadrant,
  ) {
    return TasksByQuadrantProvider(
      quadrant,
    );
  }

  @override
  TasksByQuadrantProvider getProviderOverride(
    covariant TasksByQuadrantProvider provider,
  ) {
    return call(
      provider.quadrant,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksByQuadrantProvider';
}

/// See also [tasksByQuadrant].
class TasksByQuadrantProvider extends AutoDisposeFutureProvider<List<Task>> {
  /// See also [tasksByQuadrant].
  TasksByQuadrantProvider(
    EisenhowerQuadrant quadrant,
  ) : this._internal(
          (ref) => tasksByQuadrant(
            ref as TasksByQuadrantRef,
            quadrant,
          ),
          from: tasksByQuadrantProvider,
          name: r'tasksByQuadrantProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksByQuadrantHash,
          dependencies: TasksByQuadrantFamily._dependencies,
          allTransitiveDependencies:
              TasksByQuadrantFamily._allTransitiveDependencies,
          quadrant: quadrant,
        );

  TasksByQuadrantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quadrant,
  }) : super.internal();

  final EisenhowerQuadrant quadrant;

  @override
  Override overrideWith(
    FutureOr<List<Task>> Function(TasksByQuadrantRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksByQuadrantProvider._internal(
        (ref) => create(ref as TasksByQuadrantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quadrant: quadrant,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Task>> createElement() {
    return _TasksByQuadrantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByQuadrantProvider && other.quadrant == quadrant;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quadrant.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksByQuadrantRef on AutoDisposeFutureProviderRef<List<Task>> {
  /// The parameter `quadrant` of this provider.
  EisenhowerQuadrant get quadrant;
}

class _TasksByQuadrantProviderElement
    extends AutoDisposeFutureProviderElement<List<Task>>
    with TasksByQuadrantRef {
  _TasksByQuadrantProviderElement(super.provider);

  @override
  EisenhowerQuadrant get quadrant =>
      (origin as TasksByQuadrantProvider).quadrant;
}

String _$tasksByDateHash() => r'e605a7bf85c58657b2a6359d58245f221ab4df79';

/// See also [tasksByDate].
@ProviderFor(tasksByDate)
const tasksByDateProvider = TasksByDateFamily();

/// See also [tasksByDate].
class TasksByDateFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [tasksByDate].
  const TasksByDateFamily();

  /// See also [tasksByDate].
  TasksByDateProvider call(
    DateTime date,
  ) {
    return TasksByDateProvider(
      date,
    );
  }

  @override
  TasksByDateProvider getProviderOverride(
    covariant TasksByDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksByDateProvider';
}

/// See also [tasksByDate].
class TasksByDateProvider extends AutoDisposeFutureProvider<List<Task>> {
  /// See also [tasksByDate].
  TasksByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => tasksByDate(
            ref as TasksByDateRef,
            date,
          ),
          from: tasksByDateProvider,
          name: r'tasksByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksByDateHash,
          dependencies: TasksByDateFamily._dependencies,
          allTransitiveDependencies:
              TasksByDateFamily._allTransitiveDependencies,
          date: date,
        );

  TasksByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<List<Task>> Function(TasksByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksByDateProvider._internal(
        (ref) => create(ref as TasksByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Task>> createElement() {
    return _TasksByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksByDateRef on AutoDisposeFutureProviderRef<List<Task>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _TasksByDateProviderElement
    extends AutoDisposeFutureProviderElement<List<Task>> with TasksByDateRef {
  _TasksByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as TasksByDateProvider).date;
}

String _$doneTasksHash() => r'67dc03adf6efe9df04637836c1ba515290d94864';

/// See also [doneTasks].
@ProviderFor(doneTasks)
final doneTasksProvider = AutoDisposeFutureProvider<List<Task>>.internal(
  doneTasks,
  name: r'doneTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$doneTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoneTasksRef = AutoDisposeFutureProviderRef<List<Task>>;
String _$taskByIdHash() => r'b44ef822e001b5d93a6c484b0131e1d2476cbe62';

/// See also [taskById].
@ProviderFor(taskById)
const taskByIdProvider = TaskByIdFamily();

/// See also [taskById].
class TaskByIdFamily extends Family<AsyncValue<Task?>> {
  /// See also [taskById].
  const TaskByIdFamily();

  /// See also [taskById].
  TaskByIdProvider call(
    String id,
  ) {
    return TaskByIdProvider(
      id,
    );
  }

  @override
  TaskByIdProvider getProviderOverride(
    covariant TaskByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskByIdProvider';
}

/// See also [taskById].
class TaskByIdProvider extends AutoDisposeFutureProvider<Task?> {
  /// See also [taskById].
  TaskByIdProvider(
    String id,
  ) : this._internal(
          (ref) => taskById(
            ref as TaskByIdRef,
            id,
          ),
          from: taskByIdProvider,
          name: r'taskByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskByIdHash,
          dependencies: TaskByIdFamily._dependencies,
          allTransitiveDependencies: TaskByIdFamily._allTransitiveDependencies,
          id: id,
        );

  TaskByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Task?> Function(TaskByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskByIdProvider._internal(
        (ref) => create(ref as TaskByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Task?> createElement() {
    return _TaskByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskByIdRef on AutoDisposeFutureProviderRef<Task?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TaskByIdProviderElement extends AutoDisposeFutureProviderElement<Task?>
    with TaskByIdRef {
  _TaskByIdProviderElement(super.provider);

  @override
  String get id => (origin as TaskByIdProvider).id;
}

String _$taskActionsHash() => r'5f502dd27d7b9bd2bd9707b624aa71296d693157';

/// See also [TaskActions].
@ProviderFor(TaskActions)
final taskActionsProvider =
    AutoDisposeNotifierProvider<TaskActions, AsyncValue<void>>.internal(
  TaskActions.new,
  name: r'taskActionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$taskActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskActions = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
