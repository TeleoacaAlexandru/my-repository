import 'package:flutter/material.dart';
import 'package:flutter_forms_files/models/todo.dart';
import 'package:flutter_forms_files/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Todo> todos = [
    const Todo(
      title: 'Milk',
      description: '2 liters of low-fat milk',
      priority: Priority.high,
      category: ItemCategory.groceries,
    ),
    const Todo(
      title: 'Eggs',
      description: 'One dozen eggs',
      priority: Priority.medium,
      category: ItemCategory.groceries,
    ),
    const Todo(
      title: 'Chicken breast',
      description: '1 kg for meal prep',
      priority: Priority.high,
      category: ItemCategory.food,
    ),
    const Todo(
      title: 'Bread',
      description: 'Whole wheat loaf',
      priority: Priority.low,
      category: ItemCategory.food,
    ),
    const Todo(
      title: 'Dish soap',
      description: 'Lemon scent',
      priority: Priority.medium,
      category: ItemCategory.cleaning,
    ),
    const Todo(
      title: 'Laundry detergent',
      description: 'Refill pack',
      priority: Priority.urgent,
      category: ItemCategory.cleaning,
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.medium;
  ItemCategory _selectedCategory = ItemCategory.groceries;

  String? _requiredFieldValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a $fieldName';
    }
    return null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final newTodo = Todo(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      category: _selectedCategory,
    );

    setState(() {
      todos.insert(0, newTodo);
      _titleController.clear();
      _descriptionController.clear();
      _selectedPriority = Priority.medium;
      _selectedCategory = ItemCategory.groceries;
    });
  }

  Future<void> _editTodo(int index) async {
    final existingTodo = todos[index];
    final titleController = TextEditingController(text: existingTodo.title);
    final descriptionController =
        TextEditingController(text: existingTodo.description);
    var selectedPriority = existingTodo.priority;
    var selectedCategory = existingTodo.category;
    final formKey = GlobalKey<FormState>();

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit todo'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            _requiredFieldValidator(value, 'title'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            _requiredFieldValidator(value, 'description'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Priority>(
                        value: selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: Priority.values
                            .map(
                              (priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.title),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            selectedPriority = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ItemCategory>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: ItemCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.title),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) return;
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldSave == true) {
      setState(() {
        todos[index] = Todo(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          priority: selectedPriority,
          category: selectedCategory,
        );
      });
    }

    titleController.dispose();
    descriptionController.dispose();
  }

  void _deleteTodo(int index) {
    final deletedTodo = todos[index];
    setState(() {
      todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${deletedTodo.title}" deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Things to Buy'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TodoList(
                todos: todos,
                onEdit: _editTodo,
                onDelete: _deleteTodo,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Add new item',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            _requiredFieldValidator(value, 'title'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            _requiredFieldValidator(value, 'description'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Priority>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: Priority.values
                            .map(
                              (priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.title),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ItemCategory>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: ItemCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.title),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _addTodo,
                        icon: const Icon(Icons.add),
                        label: const Text('Add item'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}