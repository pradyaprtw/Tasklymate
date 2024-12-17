import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = ['Kerja', 'Pribadi', 'Kuliah', 'Lainnya'];
  TextEditingController _otherCategoryController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty && _selectedDate != null && (_selectedCategory != null && (_selectedCategory != 'Lainnya' || _otherCategoryController.text.isNotEmpty))) {
      String task = _taskController.text;
      String notes = _notesController.text;
      String date = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      String category = _selectedCategory == 'Lainnya' ? _otherCategoryController.text : _selectedCategory!;

      // Tambah task ke kategori 'Lainnya' jika kategori tersebut dipilih
      if (category == 'Lainnya') {
        category = _otherCategoryController.text;
      }

      Navigator.pop(context, "$task|$date|$category|$notes");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tugas, tanggal, dan kategori harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 213, 213),
      appBar: AppBar(
        title: Text('Tambah Tugas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: ListView(
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Nama Tugas',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null 
                        ? 'Tanggal Belum Dipilih!'
                        : 'Tanggal: ${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}',
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Pilih Tanggal'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  hintText: 'Pilih Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    if (_selectedCategory == 'Lainnya') {
                      _otherCategoryController.text = '';
                    }
                  });
                },
              ),
              if (_selectedCategory == 'Lainnya') ...[
                SizedBox(height: 20),
                TextField(
                  controller: _otherCategoryController,
                  decoration: InputDecoration(
                    labelText: 'Kategori Lainnya',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTask,
                child: Text('Tambahkan Tugas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
