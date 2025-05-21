import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

enum Priority { low, medium, high }

class Subtask {
  String title;
  bool completed;
  Subtask(this.title, {this.completed = false});
}

class Task {
  final String title;
  final Priority priority;
  bool completed;
  final List<Subtask> subtasks;

  Task({
    required this.title,
    required this.priority,
    this.completed = false,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? [];
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(
      title: "Buy groceries",
      priority: Priority.low,
      subtasks: [
        Subtask("Milk"),
        Subtask("Eggs"),
        Subtask("Bread"),
        Subtask("Vegetables"),
      ],
    ),
    Task(
      title: "Finish project report",
      priority: Priority.high,
      subtasks: [
        Subtask("Write intro"),
        Subtask("Add charts"),
        Subtask("Proofread"),
      ],
    ),
    Task(
      title: "Call plumber",
      priority: Priority.medium,
      subtasks: [
        Subtask("Check kitchen sink"),
        Subtask("Fix bathroom tap"),
      ],
    ),
    Task(
      title: "Read a book",
      priority: Priority.low,
      subtasks: [
        Subtask("Read chapter 1"),
        Subtask("Read chapter 2"),
      ],
    ),
    Task(
      title: "Workout",
      priority: Priority.medium,
      subtasks: [
        Subtask("Push-ups"),
        Subtask("Jogging"),
      ],
    ),
    Task(
      title: "Pay bills",
      priority: Priority.high,
      subtasks: [
        Subtask("Electricity"),
        Subtask("Internet"),
      ],
    ),
  ];

  void _addTask() async {
    String? newTitle;
    Priority selectedPriority = Priority.low;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(labelText: "Task Title"),
              onChanged: (value) => newTitle = value,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Priority>(
              value: selectedPriority,
              items: Priority.values
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                      ))
                  .toList(),
              onChanged: (p) {
                if (p != null) selectedPriority = p;
              },
              decoration: const InputDecoration(labelText: "Priority"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newTitle != null && newTitle!.trim().isNotEmpty) {
                setState(() {
                  _tasks.add(Task(title: newTitle!.trim(), priority: selectedPriority));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(Priority priority, ColorScheme colorScheme) {
    switch (priority) {
      case Priority.low:
        return Colors.green.shade200;
      case Priority.medium:
        return Colors.orange.shade200;
      case Priority.high:
        return Colors.red.shade200;
    }
  }

  IconData _priorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.arrow_downward;
      case Priority.medium:
        return Icons.arrow_forward;
      case Priority.high:
        return Icons.arrow_upward;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskZen'),
        backgroundColor: colorScheme.surfaceVariant,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              themeProvider.toggleTheme(!isDark);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _tasks.isEmpty
            ? const Center(child: Text("No tasks yet. Add one!"))
            : MasonryGridView.builder(
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _tasks.length,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailPage(task: task),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    child: Card(
                      elevation: 2,
                      color: _priorityColor(task.priority, colorScheme),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: task.completed,
                              onChanged: (checked) {
                                setState(() {
                                  task.completed = checked ?? false;
                                });
                              },
                            ),
                            Icon(
                              _priorityIcon(task.priority),
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.completed
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: task.completed
                                      ? Colors.black38
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                      .move(begin: const Offset(0, 20), duration: 500.ms, curve: Curves.easeOut);
                },
              ),
      ),
    );
  }
}

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _subtaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Subtasks",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.task.subtasks.length,
              itemBuilder: (context, index) {
                final subtask = widget.task.subtasks[index];
                return CheckboxListTile(
                  value: subtask.completed,
                  onChanged: (checked) {
                    setState(() {
                      subtask.completed = checked ?? false;
                    });
                  },
                  title: Text(
                    subtask.title,
                    style: TextStyle(
                      decoration: subtask.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: subtask.completed ? Colors.black38 : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: const InputDecoration(
                      labelText: "Add subtask",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final text = _subtaskController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        widget.task.subtasks.add(Subtask(text));
                        _subtaskController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}