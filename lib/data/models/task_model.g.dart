// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'inbox',
      priority: json['priority'] as String? ?? 'p4',
      quadrant: json['quadrant'] as String? ?? 'doFirst',
      dueDate: (json['due_date'] as num?)?.toInt(),
      completedAt: (json['completed_at'] as num?)?.toInt(),
      createdAt: (json['created_at'] as num).toInt(),
      updatedAt: (json['updated_at'] as num).toInt(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'priority': instance.priority,
      'quadrant': instance.quadrant,
      'due_date': instance.dueDate,
      'completed_at': instance.completedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'sort_order': instance.sortOrder,
    };
