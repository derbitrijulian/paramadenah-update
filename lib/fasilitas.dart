import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FasilitasPage extends StatefulWidget {
  const FasilitasPage({super.key});

  @override
  _FasilitasPageState createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<FasilitasPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, List<Map<dynamic, dynamic>>> facilitiesByCategory = {};

  @override
  void initState() {
    super.initState();
    _fetchFacilities();
  }

  void _fetchFacilities() {
    _database.child('fasilitas').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          facilitiesByCategory.clear();
          data.forEach((categoryKey, categoryValue) {
            if (categoryValue is Map) {
              facilitiesByCategory[categoryKey] = (categoryValue as Map<dynamic, dynamic>).entries.map((entry) {
                final facilityData = entry.value as Map<dynamic, dynamic>? ?? {};
                return {
                  'name': facilityData['name'] ?? entry.key, // Gunakan key jika name tidak ada
                  'imageUrl': facilityData['imageUrl'] ?? '', // Default kosong jika tidak ada
                  'category': categoryKey,
                };
              }).toList();
            }
          });
        });
      } else {
        setState(() {
          facilitiesByCategory.clear(); // Kosongkan jika data tidak ada
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/png/Untitled.png', width: 30, height: 30),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'FASILITAS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF075A8E),
                      ),
                    ),
                    Text(
                      'Halaman informasi fasilitas tersedia di kampus',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: facilitiesByCategory.entries.map((entry) {
                        return _buildSection(entry.key.toUpperCase(), entry.value.map((facility) {
                          return _buildFacilityItem(
                            facility['imageUrl'],
                            facility['name'],
                          );
                        }).toList());
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: items,
        ),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }

  Widget _buildFacilityItem(String imageUrl, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 82,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF075A8E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.white);
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}