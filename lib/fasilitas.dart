import 'package:flutter/material.dart';

class FasilitasPage extends StatelessWidget {
  const FasilitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/png/Untitled.png', width: 30, height: 30),
                      onPressed: () {
                        // Search logic
                      },
                    ),
                  ],
                ),
              ),
              // Title
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
              // Sections
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection('FASILITAS UMUM', [
                          _buildFacilityItem('png/Toilet_biru.png', 'Toilet'),
                          _buildFacilityItem('png/Perpustakaan.png', 'Library'),
                          _buildFacilityItem('png/Kantin.png', 'Kantin'),
                          _buildFacilityItem('png/Masjid.png', 'Mushola'),
                          _buildFacilityItem('png/Communal.png', 'Taman'),
                          _buildFacilityItem('png/Lift.png', 'Lift'),
                          _buildFacilityItem('png/Tangga.png', 'Tangga'),
                          _buildFacilityItem('png/EmergencyExit.png', 'Emergency'),
                          _buildFacilityItem('png/Parkir.png', 'Parkir'),
                          _buildFacilityItem('png/PosSecurity.png', 'Security'),
                        ]),
                        _buildSection('LAB KELAS', [
                          _buildFacilityItem('png/LabKom.png', 'Komputer'),
                          _buildFacilityItem('png/LabGame.png', 'Lab.Game'),
                          _buildFacilityItem('png/LabDesign.png', 'Design'),
                          _buildFacilityItem('png/LabPhoto.png', 'Photo'),
                        ]),
                        _buildSection('RUANG KANTOR', [
                          _buildFacilityItem('png/Rektorat.png', 'Rektorat'),
                          _buildFacilityItem('png/Prodi.png', 'Prodi'),
                          _buildFacilityItem('png/RuangRapat.png', 'R.Rapat'),
                          _buildFacilityItem('png/Tendik.png', 'Tendik'),
                          _buildFacilityItem('png/Humas.png', 'Humas'),
                          _buildFacilityItem('png/TU.png', 'Tata Usaha'),
                        ]),
                        _buildSection('FASILITAS LAINNYA', [
                          _buildFacilityItem('png/Gudang.png', 'Gudang'),
                          _buildFacilityItem('png/Janitor.png', 'Janitor'),
                        ]),
                      ],
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

  Widget _buildFacilityItem(String iconPath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 82,
          height: 100, // Increased height to accommodate text
          decoration: BoxDecoration(
            color: const Color(0xFF075A8E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  iconPath,
                  width: 48,
                  height: 48,
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