import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('notifications');

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 160, 32, 16),
                  child: StreamBuilder(
                    stream: _databaseReference.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Terjadi kesalahan saat memuat data'));
                      }
                      if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                        return const Center(child: Text('Tidak ada data tersedia'));
                      }

                      final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                      List<MapEntry<dynamic, dynamic>> notifications = data.entries.toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index].value as Map<dynamic, dynamic>;
                          return _buildNotificationItem(
                            context,
                            notification['iconUrl'] ?? '',
                            notification['message'] ?? '',
                            notification['name'] ?? '',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Header dan Judul Halaman (tidak berubah)
          Positioned(
            top: 32,
            right: 32,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              elevation: 2,
            ),
          ),
          Positioned(
            top: 80,
            left: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'NOTIFIKASI',
                  style: TextStyle(
                    color: Color(0xFF075A8E),
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

  Widget _buildNotificationItem(BuildContext context, String iconUrl, String message, String name) {
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
          Image.network(
            iconUrl,
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$name: $message',
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