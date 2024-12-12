import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Halaman Profil
  final List<String>
      completedTasks; //berfungsi untuk menyimpan tugas yang sudah selesai
  final List<String>
      pendingTasks; //berfungsi untuk menyimpan tugas yang belum selesai

  ProfileScreen({required this.completedTasks, required this.pendingTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Profil'), //tittle dibagian atas
        title: Text('TasklyMate'),
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(223, 135, 37, 83),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFFFDE6E9), // Warna pink muda
        backgroundColor: const Color.fromARGB(255, 241, 174, 174),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tugas Selesai',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight
                        .bold)), // teks untuk tugas yang sudah selesai
            ...completedTasks.map((task) => ListTile(
                  // leading: Icon(Icons.check_circle, color: Colors.green), // cek warna yang sudah selesai
                  leading: Icon(Icons.check_circle,
                      color: const Color.fromARGB(255, 76, 129, 175)),
                  title: Text(task),
                )),
            SizedBox(height: 20),
            Text('Tugas Tertunda',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight
                        .bold)), // teks untuk tugas yang belum selesai
            ...pendingTasks.map((task) => ListTile(
                  // leading: Icon(Icons.pending, color: Colors.orange),
                  leading: Icon(Icons.pending,
                      color: Colors.red), // cek warna yang belum selesai
                  title: Text(task),
                )),
          ],
        ),
      ),
    );
  }
}
