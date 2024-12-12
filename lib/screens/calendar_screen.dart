import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final List<Map<String, String>> tasks;

  CalendarScreen({required this.tasks, required Map tasksByDate});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 213, 213),
      appBar: AppBar(
        title: Text('Kalender'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _showTasksForDay(selectedDay);
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 179, 10, 165),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: const Color.fromARGB(223, 134, 57, 93),
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.10),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          eventLoader: (day) => _getEventsForDay(day),
        ),
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    String formattedDay = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    return widget.tasks
        .where((task) => task['date'] == formattedDay)
        .map((task) => task['task']!)
        .toList();
  }

  void _showTasksForDay(DateTime day) {
    String formattedDay = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    List<Map<String, String>> tasksForDay = widget.tasks.where((task) => task['date'] == formattedDay).toList();

    if (tasksForDay.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak ada tugas untuk tanggal ini.")),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            itemCount: tasksForDay.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasksForDay[index]['task']!),
                subtitle: Text(tasksForDay[index]['category']!),
              );
            },
          );
        },
      );
    }
  }
}
