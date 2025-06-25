import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'widgets/bottom_nav_bar.dart';
import 'room_detail_page.dart'; // Impor halaman detail ruangan

class RoomListPage extends StatefulWidget {
  final String gedungName;

  const RoomListPage({super.key, required this.gedungName});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late DatabaseReference _databaseReference;
  late DatabaseReference _gedungReference; // Referensi untuk mengambil image gedung

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('gedung').child(widget.gedungName).child('kelas');
    _gedungReference = FirebaseDatabase.instance.ref().child('gedung').child(widget.gedungName); // Untuk mengambil image
    _tabController = TabController(length: 3, vsync: this); // 3 lantai
    print('Initialized RoomListPage with gedungName: ${widget.gedungName}'); // Debugging
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Widget _buildClassroomCard(BuildContext context, String codeKelas, String roomId, String lantai, int kapasitas, int totalPapanTulis, int totalTelevisi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'png/classroom.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$codeKelas',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Kapasitas: $kapasitas orang, Papan Tulis: $totalPapanTulis, TV: $totalTelevisi',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomDetailPage(gedungName: widget.gedungName, roomId: roomId, lantai: lantai),
                  ),
                );
              },
              child: const Text(
                'Detail ↗',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
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

          final kelasData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};
          print('Raw Kelas Data for ${widget.gedungName}: $kelasData'); // Debugging raw data
          print('Snapshot Key: ${snapshot.data!.snapshot.key}'); // Debugging node yang diakses

          final lantai1Data = kelasData['lantai_1'] as Map<dynamic, dynamic>? ?? {};
          final lantai2Data = kelasData['lantai_2'] as Map<dynamic, dynamic>? ?? {};
          final lantai3Data = kelasData['lantai_3'] as Map<dynamic, dynamic>? ?? {};

          print('Lantai 1 Data: $lantai1Data'); // Debugging per lantai
          print('Lantai 2 Data: $lantai2Data');
          print('Lantai 3 Data: $lantai3Data');

          final lantai1Rooms = lantai1Data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>? ?? {};
            print('Lantai 1 Room Entry: $entry, Value: $value'); // Debugging per ruangan
            return {
              'id': entry.key as String? ?? 'Unknown ID',
              'code_kelas': value['code_kelas'] as String? ?? 'Unknown Room',
              'lantai': value['lantai'] as String? ?? '1',
              'kapasitas_orang': value['kapasitas_orang'] as int? ?? 0,
              'total_papan_tulis': value['total_papan_tulis'] as int? ?? 0,
              'total_televisi': value['total_televisi'] as int? ?? 0,
            };
          }).toList();

          final lantai2Rooms = lantai2Data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>? ?? {};
            print('Lantai 2 Room Entry: $entry, Value: $value'); // Debugging per ruangan
            return {
              'id': entry.key as String? ?? 'Unknown ID',
              'code_kelas': value['code_kelas'] as String? ?? 'Unknown Room',
              'lantai': value['lantai'] as String? ?? '2',
              'kapasitas_orang': value['kapasitas_orang'] as int? ?? 0,
              'total_papan_tulis': value['total_papan_tulis'] as int? ?? 0,
              'total_televisi': value['total_televisi'] as int? ?? 0,
            };
          }).toList();

          final lantai3Rooms = lantai3Data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>? ?? {};
            print('Lantai 3 Room Entry: $entry, Value: $value'); // Debugging per ruangan
            return {
              'id': entry.key as String? ?? 'Unknown ID',
              'code_kelas': value['code_kelas'] as String? ?? 'Unknown Room',
              'lantai': value['lantai'] as String? ?? '3',
              'kapasitas_orang': value['kapasitas_orang'] as int? ?? 0,
              'total_papan_tulis': value['total_papan_tulis'] as int? ?? 0,
              'total_televisi': value['total_televisi'] as int? ?? 0,
            };
          }).toList();

          return StreamBuilder<DatabaseEvent>(
            stream: _gedungReference.onValue,
            builder: (context, gedungSnapshot) {
              if (!gedungSnapshot.hasData || gedungSnapshot.connectionState == ConnectionState.waiting) {
                print('Loading gedung image: ${gedungSnapshot.connectionState}'); // Debugging
                return const Center(child: CircularProgressIndicator());
              }
              if (gedungSnapshot.hasError) {
                print('Gedung Image Error: ${gedungSnapshot.error}'); // Debugging error
                return Center(child: Text('Error loading gedung image: ${gedungSnapshot.error}'));
              }

              final gedungData = gedungSnapshot.data!.snapshot.value as Map<dynamic, dynamic>? ?? {};
              final imageUrl = gedungData['image'] as String? ?? '';

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    leading: IconButton(
                      icon: Image.asset('png/backbutton.png', width: 30, height: 30),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/kampus_cipayung');
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: Image.asset('png/Untitled.png', width: 30, height: 30),
                        onPressed: () {},
                      ),
                    ],
                    title: Text(
                      widget.gedungName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                    floating: true,
                    pinned: false,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          width: 384,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image from URL: $error');
                            return Container(
                              width: 384,
                              height: 153,
                              color: Colors.grey[300],
                              child: const Center(child: Text('No Image Available')),
                            );
                          },
                        )
                            : Container(
                          width: 384,
                          height: 153,
                          color: Colors.grey[300],
                          child: const Center(child: Text('No Image Available')),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LIST KELAS',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            indicator: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tabs: const [
                              Tab(text: 'LANTAI 1'),
                              Tab(text: 'LANTAI 2'),
                              Tab(text: 'LANTAI 3'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: lantai1Rooms.map((room) => _buildClassroomCard(
                        context,
                        room['code_kelas'] as String,
                        room['id'] as String,
                        room['lantai'] as String,
                        room['kapasitas_orang'] as int,
                        room['total_papan_tulis'] as int,
                        room['total_televisi'] as int,
                      )).toList(),
                    ),
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: lantai2Rooms.map((room) => _buildClassroomCard(
                        context,
                        room['code_kelas'] as String,
                        room['id'] as String,
                        room['lantai'] as String,
                        room['kapasitas_orang'] as int,
                        room['total_papan_tulis'] as int,
                        room['total_televisi'] as int,
                      )).toList(),
                    ),
                    ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: lantai3Rooms.map((room) => _buildClassroomCard(
                        context,
                        room['code_kelas'] as String,
                        room['id'] as String,
                        room['lantai'] as String,
                        room['kapasitas_orang'] as int,
                        room['total_papan_tulis'] as int,
                        room['total_televisi'] as int,
                      )).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}