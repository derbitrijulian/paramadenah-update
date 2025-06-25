import 'package:flutter/material.dart';
import 'widgets/bottom_nav_bar.dart';

class NurcholisPage extends StatefulWidget {
  const NurcholisPage({super.key});

  @override
  State<NurcholisPage> createState() => _NurcholisPageState();
}

class _NurcholisPageState extends State<NurcholisPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
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
            title: const Text(
              'Nurcholis Madjid',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                child: Image.asset(
                  'png/gedunga.png',
                  width: 384,
                  fit: BoxFit.cover,
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
            // Lantai 1
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                {'kelas': 'A1-1', 'route': '/kelas_a11'},
                {'kelas': 'A1-2', 'route': '/kelas_a12'},
                {'kelas': 'A1-3', 'route': '/kelas_a13'},
                {'kelas': 'A1-4', 'route': '/kelas_a14'},
                {'kelas': 'A1-5', 'route': '/kelas_a15'},
                {'kelas': 'A1-6', 'route': '/kelas_a16'},
                {'kelas': 'A1-7', 'route': '/kelas_a17'},
                {'kelas': 'A1-8', 'route': '/kelas_a18'},
                {'kelas': 'A1-9', 'route': '/kelas_a19'},
              ].map((item) => _buildClassroomCard(context, item['kelas']!, item['route'])).toList(),
            ),
            // Lantai 2
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                {'kelas': 'A2-1', 'route': '/kelas_a21'},
                {'kelas': 'A2-2', 'route': '/kelas_a22'},
                {'kelas': 'A2-3', 'route': '/kelas_a23'},
                {'kelas': 'A2-4', 'route': '/kelas_a24'},
                {'kelas': 'A2-5', 'route': '/kelas_a25'},
                {'kelas': 'A2-6', 'route': '/kelas_a26'},
                {'kelas': 'A2-7', 'route': '/kelas_a27'},
                {'kelas': 'A2-8', 'route': '/kelas_a28'},
                {'kelas': 'A2-9', 'route': '/kelas_a29'},
              ].map((item) => _buildClassroomCard(context, item['kelas']!, item['route'])).toList(),
            ),
            // Lantai 3
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                {'kelas': 'A3-1', 'route': '/kelas_a31'},
                {'kelas': 'A3-4', 'route': '/kelas_a34'},
                {'kelas': 'A3-5', 'route': '/kelas_a35'},
                {'kelas': 'A3-6', 'route': '/kelas_a36'},
                {'kelas': 'A3-7', 'route': '/kelas_a37'},
                {'kelas': 'A3-8', 'route': '/kelas_a38'},
              ].map((item) => _buildClassroomCard(context, item['kelas']!, item['route'])).toList(),
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

  Widget _buildClassroomCard(BuildContext context, String kelas, String? route) {
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
                Text(
                  kelas,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            GestureDetector(
              onTap: route != null
                  ? () {
                Navigator.pushNamed(context, route);
              }
                  : null,
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
}