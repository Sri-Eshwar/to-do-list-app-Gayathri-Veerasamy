import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List Application',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Color(0xFFF3E5F5), // Light purple background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
        ),
      ),
      home: TaskListPage(),
    );
  }
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> _tasks = [];

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title));
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index, String newTitle) {
    setState(() {
      _tasks[index].title = newTitle;
    });
  }

  double get _completionPercentage {
    if (_tasks.isEmpty) return 0;
    int completedTasks = _tasks.where((task) => task.isCompleted).length;
    return (completedTasks / _tasks.length);
  }

  int get _completedCount => _tasks.where((task) => task.isCompleted).length;
  int get _notCompletedCount => _tasks.length - _completedCount;

  void _showAddTaskDialog() {
    TextEditingController _taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(hintText: 'Enter task details'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _addTask(_taskController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    TextEditingController _taskController = TextEditingController();
    _taskController.text = _tasks[index].title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(hintText: 'Edit task details'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _editTask(index, _taskController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Tooltip(
              message:
                  'Completed: $_completedCount | Not Completed: $_notCompletedCount | ${(_completionPercentage * 100).toStringAsFixed(2)}%',
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: _completionPercentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 4.5,
                    ),
                  ),
                  Text(
                    '${(_completionPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks available!',
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      _tasks[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(
                        _tasks[index].isCompleted
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _tasks[index].isCompleted
                            ? Colors.green
                            : Colors.red,
                      ),
                      onPressed: () => _toggleTaskCompletion(index),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditTaskDialog(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
