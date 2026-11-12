import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
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

  // Listar tarefas
  Future<List<Task>> getTasks() async {
    final response = await http.get(_tasksUrl, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((item) => Task.fromJson(item)).toList();
    }

    throw Exception('Erro ao carregar tarefas: ${response.statusCode}');
  }

  // Buscar tarefa por ID
  Future<Task> getTask(int id) async {
    final response = await http.get(
      Uri.parse('$_tasksUrl/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Task.fromJson(json['data']);
    }

    throw Exception('Erro ao buscar tarefa: ${response.statusCode}');
  }

  // Cadastrar tarefa
  Future<Task> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    bool isCompleted = false,
  }) async {
    final response = await http.post(
      _tasksUrl,
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'description': description,
        'due_date': _formatDate(dueDate),
        'is_completed': isCompleted,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Task.fromJson(json['data']);
    }

    throw Exception('Erro ao cadastrar tarefa: ${response.statusCode}');
  }

  // Atualizar tarefa
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

    throw Exception('Erro ao atualizar tarefa: ${response.statusCode}');
  }

  // Excluir tarefa
  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$_tasksUrl/$id'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir tarefa: ${response.statusCode}');
    }
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
