import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'widgets/bottom_nav_bar.dart';

class RoomDetailPage extends StatefulWidget {
  final String gedungName;
  final String roomId;
  final String lantai;

  const RoomDetailPage({super.key, required this.gedungName, required this.roomId, required this.lantai});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  int _selectedIndex = 0;
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('gedung').child(widget.gedungName).child('kelas').child('lantai_${widget.lantai}').child(widget.roomId);
    print('Database Reference: $_databaseReference'); // Debugging path
    print('Parameters - gedungName: ${widget.gedungName}, lantai: ${widget.lantai}, roomId: ${widget.roomId}'); // Debugging parameters
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              print('Loading or waiting: ${snapshot.connectionState}'); // Debugging
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print('Stream Error: ${snapshot.error}'); // Debugging error
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final roomData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};
            print('Raw Room Data: $roomData'); // Debugging data mentah
            print('Snapshot Key: ${snapshot.data!.snapshot.key}'); // Debugging node yang diakses

            final codeKelas = roomData['code_kelas'] as String? ?? 'Unknown Room';
            final kapasitasOrang = roomData['kapasitas_orang'] as int? ?? 0;
            final totalPapanTulis = roomData['total_papan_tulis'] as int? ?? 0;
            final totalTelevisi = roomData['total_televisi'] as int? ?? 0;
            final images = (roomData['images'] as List<dynamic>?)?.cast<String>() ?? [];
            final denahLokasi = roomData['denah_lokasi'] as String? ?? '';

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
                          Navigator.pushReplacementNamed(context, '/kampus_cipayung');
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
                  items: images.isNotEmpty
                      ? images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading image: $error');
                              return Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(child: Text('No Image Available')),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }).toList()
                      : [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: Text('No Image Available')),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        codeKelas,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kelas $codeKelas ini dilengkapi dengan fasilitas sebagai berikut:',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
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
                          _buildFacilityItem('png/classroom.png', 'Kapasitas: $kapasitasOrang'),
                          _buildFacilityItem('png/whiteboard.png', 'Papan Tulis: $totalPapanTulis'),
                          _buildFacilityItem('png/TV.png', 'Televisi: $totalTelevisi'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                        child: denahLokasi.isNotEmpty
                            ? Image.network(
                          denahLokasi,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading denah: $error');
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(child: Text('No Image Available')),
                            );
                          },
                        )
                            : Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(child: Text('No Image Available')),
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