import 'package:flutter/material.dart';
import 'package:flutter_forms_files/models/todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    required this.todos,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Todo> todos;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(
        child: Text('No items yet. Add your first item below.'),
      );
    }

    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        final todo = todos[index];
        return Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: todo.priority.color.withValues(alpha: 0.35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: todo.priority.color,
                  child: Icon(todo.category.icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(todo.description),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Chip(
                            avatar: Icon(
                              todo.category.icon,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text(todo.category.title),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text(todo.priority.title),
                            backgroundColor:
                                todo.priority.color.withValues(alpha: 0.18),
                            side: BorderSide(
                              color: todo.priority.color.withValues(alpha: 0.5),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit(index);
                      return;
                    }
                    if (value == 'delete') {
                      onDelete(index);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit item')),
                    PopupMenuItem(value: 'delete', child: Text('Delete item')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}