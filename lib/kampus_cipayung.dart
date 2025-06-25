import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'widgets/bottom_nav_bar.dart';
import 'room_list_page.dart'; // Impor halaman daftar ruangan

class KampusCipayungPage extends StatefulWidget {
  const KampusCipayungPage({super.key});

  @override
  State<KampusCipayungPage> createState() => _KampusCipayungPageState();
}

class _KampusCipayungPageState extends State<KampusCipayungPage> {
  int _selectedIndex = 0;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('gedung');

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pushReplacementNamed(
        context,
        '/homescreen',
        arguments: index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'png/Heroo.png',
                ),
                IconButton(
                  icon: Image.asset('png/backbutton.png', width: 30, height: 30),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/homescreen');
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gedung Kampus',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<DatabaseEvent>(
                    stream: _databaseReference.onValue,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};
                      print('Raw Data: $data'); // Debugging data mentah
                      final gedungList = data.entries.map((entry) {
                        final value = entry.value as Map<dynamic, dynamic>? ?? {};
                        print('Entry Value: $value'); // Debugging per entri
                        return {
                          'name': value['name'] as String? ?? entry.key as String, // Ambil dari 'name' atau kunci jika 'name' tidak ada
                          'image': value['image'] is String ? value['image'] as String : '',
                        };
                      }).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: gedungList.length,
                        itemBuilder: (context, index) {
                          final gedung = gedungList[index];
                          print('Gedung: $gedung, Image: ${gedung['image']}'); // Debugging gedung yang diproses
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoomListPage(gedungName: gedung['name'] as String),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: gedung['image'] != null && (gedung['image'] as String).isNotEmpty
                                        ? Image.network(
                                      gedung['image'] as String,
                                      width: double.infinity,
                                      height: 153,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Error loading image from URL: $error, using placeholder');
                                        return Container(
                                          width: double.infinity,
                                          height: 153,
                                          color: Colors.grey[300],
                                          child: const Center(child: Text('No Image Available')),
                                        );
                                      },
                                    )
                                        : Container(
                                      width: double.infinity,
                                      height: 153,
                                      color: Colors.grey[300],
                                      child: const Center(child: Text('No Image Available')),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        gedung['name'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}