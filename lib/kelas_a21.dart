import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'widgets/bottom_nav_bar.dart';

class KelasA21Page extends StatefulWidget {
  const KelasA21Page({super.key});

  @override
  State<KelasA21Page> createState() => _KelasA21PageState();
}

class _KelasA21PageState extends State<KelasA21Page> {
  int _selectedIndex = 0;
  final String roomId = '-OT2AhnFuHr359cR6TsU'; // ID node di Realtime Database
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('ruangan').child('-OT2AhnFuHr359cR6TsU');

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

  Widget _buildFacilityItem(String imagePath, String text) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: StreamBuilder<DatabaseEvent>(
          stream: _databaseReference.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              print('Loading or no data: ${snapshot.connectionState}');
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final roomData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};
            print('Room Data: $roomData'); // Debug data yang diterima

            final name_ruangan = roomData['name_ruangan'] as String? ?? 'A2-1';
            final images = (roomData['images'] as List<dynamic>?)?.cast<String>() ?? ['images/A211.jpg', 'images/A212.jpg', 'images/A213.jpg', 'images/A214.jpg'];
            final totalPapanTulis = roomData['total_papan_tulis'] as String? ?? '0';
            final totalTelevisi = roomData['total_televisi'] as String? ?? '0';
            final description = 'Kelas $name_ruangan ini dilengkapi dengan fasilitas sebagai berikut:';
            final locationImage = 'png/DenahA21.png'; // Fallback default

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'png/backbutton.png',
                          width: 30,
                          height: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/nurcholis');
                        },
                      ),
                      Container(
                        width: 136,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDD998),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'KELAS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                  items: images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        name_ruangan,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3,
                        children: [
                          _buildFacilityItem('png/classroom.png', '= $totalPapanTulis papan tulis'),
                          _buildFacilityItem('png/TV.png', '= $totalTelevisi televisi'),
                          _buildFacilityItem('png/whiteboard.png', '= $totalPapanTulis papan tulis'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'images/a21.gif',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      const Text(
                        'Denah Lokasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          locationImage,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}