import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Day extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:
            fetchLocationsFromFirebase(), // Mengambil data lokasi dari Firebase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            List<DocumentSnapshot> locations =
                snapshot.data as List<DocumentSnapshot>;
            return buildItemList(
                locations.length, locations); // Membangun daftar item lokasi
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> fetchLocationsFromFirebase() async {
    await Firebase.initializeApp();
    CollectionReference locationRef =
        FirebaseFirestore.instance.collection('locations');

    DateTime now = DateTime.now();
    // Mendapatkan awal hari dari tanggal saat ini
    DateTime startOfDay = DateTime(now.year, now.month, now.day - 0);
    // Mendapatkan akhir hari dari tanggal saat ini
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

    QuerySnapshot snapshot = await locationRef
        .where('uid', isEqualTo: user?.uid) // Filter berdasarkan UID pengguna
        .get();

    List<DocumentSnapshot> filteredLocations = snapshot.docs.where((location) {
      DateTime uploadTimestamp = location['uploadTimestamp'].toDate();
      DateTime zeroDaysAgo = DateTime.now().subtract(Duration(days: 1));
      return uploadTimestamp.isAfter(zeroDaysAgo) &&
          uploadTimestamp.isAfter(startOfDay) &&
          uploadTimestamp.isBefore(endOfDay);
    }).toList();

    return filteredLocations; // Mengembalikan daftar lokasi yang telah difilter
  }

  Widget buildItemList(int itemCount, List<DocumentSnapshot> locations) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(itemCount, (index) {
                DocumentSnapshot location = locations[index];
                String locationName = location['name'] ?? '';
                String locationAddress = location['address'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    width: 380,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check In - $locationName',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              locationAddress,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
