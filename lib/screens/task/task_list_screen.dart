import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../core/databases/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await DBHelper.instance.getAllTasks();

    setState(() {
      _tasks = data.map((e) => Task.fromMap(e)).toList();
    });
  }

  Future<void> _toggleTask(int index) async {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });

    await DBHelper.instance.updateTask(
      _tasks[index].toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D9B8F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 90,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Tugas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan tugas terlebih dahulu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return _TaskCard(
                  task: _tasks[index],
                  onToggle: () => _toggleTask(index),
                );
              },
            ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const _TaskCard({required this.task, required this.onToggle});

  bool get _isPenting => task.isImportant;

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);

    return DateFormat(
      'dd MMM yyyy',
      'id_ID',
    ).format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: task.isDone
                      ? const Color(0xFF3D9B8F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: task.isDone
                        ? const Color(0xFF3D9B8F)
                        : const Color(0xFFBBBBBB),
                    width: 2,
                  ),
                ),
                child: task.isDone
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // Title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: task.isDone
                          ? const Color(0xFFAAAAAA)
                          : const Color(0xFF222222),
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: const Color(0xFFAAAAAA),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDate(task.date)} · ${task.isImportant ? "Penting" : "Biasa"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isDone
                          ? const Color(0xFFBBBBBB)
                          : const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Play button
            Icon(
              Icons.play_arrow,
              color: _isPenting
                  ? const Color(0xFFE53935)
                  : const Color(0xFF3D9B8F),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
