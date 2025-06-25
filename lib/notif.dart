import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification List
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 160, 32, 16), // Adjusted padding to avoid overlap with header
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(
                        context,
                        index == 0 ? 'png/toilet.png' :
                        index == 1 ? 'png/kelazmerah.png' : 'png/perpusmerah.png',
                        index == 0 ? 'Toilet Gedung C dan D sedang dalam perbaikan untuk sementara gunakan toilet Gedung A.' :
                        index == 1 ? 'Kelas H.JUSUF KALLA D2-6 sedang mengalami kerusakan , untuk sementara kelas dipindahkan ke H. JUSUF KALLA D1-5.' :
                        'Kami mengingatkan bahwa batas waktu pengembalian buku Tanggal: 20 September 2025 Pastikan untuk mengembalikan buku pinjam tepat waktu',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Header
          Positioned(
            top: 32,
            right: 32,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              elevation: 2,
              child: IconButton(
                icon: Image.asset('assets/png/Untitled.png', width: 20, height: 20),
                onPressed: () {
                  // Tambahkan logika pencarian di sini
                },
              ),
            ),
          ),
          // Page Title
          Positioned(
            top: 80,
            left: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'NOTIFIKASI',
                  style: TextStyle(
                    color: const Color(0xFF075A8E),
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Halaman informasi seputar kampus',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, String iconPath, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}