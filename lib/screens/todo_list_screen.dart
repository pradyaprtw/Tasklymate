import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> tasks = [];
  Map<DateTime, List<String>> tasksByDate = {};
  List<String> completedTasks = [];
  List<String> pendingTasks = [];
  List<String> taskNotes = [];
  String _currentCategory = "Semua";

  void _addTask(String taskDetails) {
    setState(() {
      var parts = taskDetails.split('|');
      String task = parts[0];
      DateTime date = DateTime.parse(parts[1]);
      tasks.add({'task': task, 'date': parts[1], 'category': parts[2], 'notes': parts[3]});

      if (tasksByDate[date] == null) {
        tasksByDate[date] = [];
      }
      tasksByDate[date]!.add(task);

      pendingTasks.add(task);
      taskNotes.add(parts[3]);
    });
  }

  void _removeTask(int index) {
    setState(() {
      String removedTask = tasks[index]['task']!;
      DateTime date = DateTime.parse(tasks[index]['date']!);
      tasks.removeAt(index);
      completedTasks.remove(removedTask);
      pendingTasks.remove(removedTask);
      taskNotes.removeAt(index);

      tasksByDate[date]?.remove(removedTask);
      if (tasksByDate[date]?.isEmpty ?? false) {
        tasksByDate.remove(date);
      }
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      String task = tasks[index]['task']!;
      if (pendingTasks.contains(task)) {
        pendingTasks.remove(task);
        completedTasks.add(task);
      } else {
        completedTasks.remove(task);
        pendingTasks.add(task);
      }
    });
  }

  void _navigateToAddTaskScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (result != null) {
      _addTask(result);
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Map<String, String>> _getFilteredTasks() {
    if (_currentCategory == "Semua") {
      return tasks;
    } else {
      return tasks.where((task) => task['category'] == _currentCategory).toList();
    }
  }

  Widget _buildTodoListScreen() {
    List<Map<String, String>> filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('TasklyMate'),
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(223, 135, 37, 83),
        ),
        backgroundColor: const Color.fromARGB(255, 241, 174, 174),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton("Semua"),
                _buildCategoryButton("Kerja"),
                _buildCategoryButton("Pribadi"),
                _buildCategoryButton("Kuliah"),
                _buildCategoryButton("Lainnya")
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/bg buku.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          filteredTasks.isEmpty
              ? Center(child: Text('Tidak ada tugas dalam kategori ini'))
              : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Checkbox(
                        value: completedTasks.contains(filteredTasks[index]['task']),
                        onChanged: (bool? value) {
                          int originalIndex = tasks.indexOf(filteredTasks[index]);
                          toggleTaskCompletion(originalIndex);
                        },
                      ),
                      title: Text(filteredTasks[index]['task']!),
                      subtitle: Row(
                        children: [
                          Text(
                            filteredTasks[index]['date']!,
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(width: 8),
                          Text(
                            filteredTasks[index]['category']!,
                            style: TextStyle(color: Colors.blue),
                          ),
                          Icon(Icons.notifications, size: 16, color: Colors.grey),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          int originalIndex = tasks.indexOf(filteredTasks[index]);
                          _removeTask(originalIndex);
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Catatan Tugas"),
                              content: Text(taskNotes[tasks.indexOf(filteredTasks[index])]),
                              actions: [
                                TextButton(
                                  child: Text("Tutup"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        backgroundColor: const Color.fromARGB(255, 240, 136, 136),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    bool isSelected = _currentCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(224, 161, 72, 114)
              // ? const Color.fromARGB(255, 229, 139, 139)
              : const Color.fromARGB(255, 250, 213, 213),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () {
          setState(() {
            _currentCategory = label;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 254, 254, 254) : const Color.fromARGB(255, 199, 100, 94),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 1:
        return CalendarScreen(tasks: tasks, tasksByDate: {},);
      case 2:
        return ProfileScreen(completedTasks: completedTasks, pendingTasks: pendingTasks);
      default:
        return _buildTodoListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tugas"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Kalender"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
