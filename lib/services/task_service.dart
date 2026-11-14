import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../core/constants/app_strings.dart';
import '../models/task.dart';

class TaskService {
  final String token;

  TaskService({required this.token});

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Uri get _tasksUrl =>
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.tasks}');

  // Buscar todas as tarefas
  Future<List<Task>> getTasks() async {
    final response = await http.get(_tasksUrl, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((item) => Task.fromJson(item)).toList();
    }

    throw Exception('${AppStrings.tasksLoadError}: ${response.statusCode}');
  }

  // Buscar uma tarefa pelo ID
  Future<Task> getTask(int id) async {
    final response = await http.get(
      Uri.parse('$_tasksUrl/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Task.fromJson(json['data']);
    }

    throw Exception('${AppStrings.fetchTaskError}: ${response.statusCode}');
  }

  // Cadastrar uma tarefa
  Future<Task> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    bool isCompleted = false,
    int? categoryId,
    List<int> tagIds = const [],
  }) async {
    final response = await http.post(
      _tasksUrl,
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'description': description,
        'due_date': _formatDate(dueDate),
        'is_completed': isCompleted,
        'category_id': categoryId,
        'tags': tagIds,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Task.fromJson(json['data']);
    }

    throw Exception('${AppStrings.createTaskError}: ${response.statusCode}');
  }

  // Atualizar uma tarefa
  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$_tasksUrl/${task.id}'),
      headers: _headers,
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Task.fromJson(json['data']);
    }

    throw Exception('${AppStrings.updateTaskError}: ${response.statusCode}');
  }

  // Excluir uma tarefa
  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$_tasksUrl/$id'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('${AppStrings.deleteTaskError}: ${response.statusCode}');
    }
  }

  // Formatar a data para o Laravel
  String? _formatDate(DateTime? date) {
    if (date == null) return null;

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
