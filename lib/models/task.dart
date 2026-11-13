import 'category.dart';
import 'tag.dart';

class Task {
  final int id;
  final int userId;
  final int? categoryId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final Category? category;
  final List<Tag> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
    this.category,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      categoryId: json['category_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      isCompleted: json['is_completed'] as bool,
      category: json['category'] is Map
          ? Category.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,
      tags: json['tags'] is List
          ? (json['tags'] as List)
                .map(
                  (item) =>
                      Tag.fromJson(Map<String, dynamic>.from(item as Map)),
                )
                .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'due_date': dueDate == null
          ? null
          : '${dueDate!.year.toString().padLeft(4, '0')}-'
                '${dueDate!.month.toString().padLeft(2, '0')}-'
                '${dueDate!.day.toString().padLeft(2, '0')}',
      'is_completed': isCompleted,
      'category_id': categoryId,
      'tags': tags.map((tag) => tag.id).toList(),
    };
  }
}
