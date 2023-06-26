import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

// variabl simpan sts pilih user
class _HomeState extends State<Home> {
  bool isCheckedIn = false;
  bool isPhinconSelected = false;
  bool isTelkomSelected = false;
  bool isRumahSelected = false;
  late String currentHour;
  late String currentDate;
//akses data yangdisimpan lalu interaksi database
  late SharedPreferences sharedPreferences;
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    getCurrentDateTime();
    initializeSharedPreferences();
    initializeFirebase();
    checkUserCheckedIn();
  }

  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    currentHour = DateFormat('HH:mm').format(now);
    currentDate = DateFormat('d MMMM yyyy').format(now);
  }

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void initializeFirebase() {
    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
  }

  // sudah unggah lihat data di database // atur stts unggah
  void checkUserCheckedIn() async {
    String userId = auth.currentUser?.uid ?? '';
    DocumentSnapshot snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('checkins')
        .doc(currentDate)
        .get();

    if (snapshot.exists) {
      setState(() {
        isCheckedIn = true;
      });
    }
  }

// perbaharui stts unggah database
// ambil id lagi login atur kapan unggah data lagi
  void setUserCheckedIn() async {
    String userId = auth.currentUser?.uid ?? '';
    await firestore
        .collection('users')
        .doc(userId)
        .collection('checkins')
        .doc(currentDate)
        .set({'isCheckedIn': true});

    setState(() {
      isCheckedIn = true;
    });
  }

  void uploadLocationData(String name, String address) async {
    if (isCheckedIn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Anda sudah melakukan absensi hari ini'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      // batasi waktu untuk absen jam 5
    } else if (currentHour.compareTo('17:00') > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Waktu unggah data telah berakhir'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      DateTime now = DateTime.now();

      String userId = auth.currentUser?.uid ?? '';
      await firestore.collection('locations').add({
        'uid': userId,
        'name': name,
        'address': address,
        'hour': '${now.hour}:${now.minute}',
        'day': now.day,
        'month': now.month,
        'year': now.year,
        'uploadTimestamp': FieldValue.serverTimestamp()
      }).then((value) {
        setUserCheckedIn();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Anda berhasil absen hari ini'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        print('An error occurred while uploading data: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/image/latar.png"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 85),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Attendance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 405,
                      height: 340,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Hour: $currentHour',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              currentDate,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCheckedIn = !isCheckedIn;
                                });
                              },
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCheckedIn
                                      ? Colors.amber
                                      : Color.fromARGB(215, 45, 218, 51),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.9),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 390,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isPhinconSelected
                          ? Color.fromARGB(255, 12, 127, 221)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhinconSelected = true;
                          isTelkomSelected = false;
                          isRumahSelected = false;
                        });
                        uploadLocationData(
                          'PT. Phincon',
                          'Office. 88 @Kasablanka Office Tower',
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'lib/image/pt.png',
                              width: 4,
                              height: 4,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PT. Phincon',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  // color: isPhinconSelected
                                  //     ? Colors.white
                                  //     : Colors.black,
                                ),
                              ),
                              Text(
                                'Office. 88 @Kasablanka Office Tower',
                                style: TextStyle(
                                  color: isPhinconSelected
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 390,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isTelkomSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhinconSelected = false;
                          isTelkomSelected = true;
                          isRumahSelected = false;
                        });
                        uploadLocationData(
                          'Telkomsel Office Tower',
                          'Jl. Jend. Gatot Subroto Kav. 52. Jakarta',
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'lib/image/telkom.png',
                              width: 4,
                              height: 4,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Telkom Office Tower',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Jl. Jend. Gatot Subroto Kav. 52. Jakarta',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 390,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isRumahSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhinconSelected = false;
                          isTelkomSelected = false;
                          isRumahSelected = true;
                        });
                        uploadLocationData('Rumah', 'Jakarta Selatan');
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'lib/image/rumah.png',
                              width: 4,
                              height: 4,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rumah',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Jakarta Selatan',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
