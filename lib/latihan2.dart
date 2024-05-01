import 'package:flutter/material.dart'; // Memuat modul Material Design Flutter.
import 'package:http/http.dart'
    as http; // Memuat modul HTTP untuk melakukan permintaan ke API.
import 'dart:convert'; // Memuat modul untuk mengonversi JSON.

void main() {
  runApp(const MyApp()); // Memulai aplikasi Flutter.
}

// menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // Menyimpan aktivitas yang diperoleh dari API.
  String jenis; // Menyimpan jenis aktivitas yang diperoleh dari API.

  Activity(
      {required this.aktivitas,
      required this.jenis}); // Constructor untuk kelas Activity.

  //map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json[
          'activity'], // Mengambil nilai 'activity' dari objek JSON dan menyimpannya ke dalam atribut 'aktivitas'.
      jenis: json[
          'type'], // Mengambil nilai 'type' dari objek JSON dan menyimpannya ke dalam atribut 'jenis'.
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key); // Constructor untuk kelas MyApp.

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat dan mengembalikan objek dari kelas MyAppState.
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; //menampung hasil

  //late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  //fetch data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity =
        init(); // Memulai proses asynchronous untuk mendapatkan data awal.
  }

  @override
  Widget build(Object context) { // Fungsi ini digunakan untuk membangun tampilan widget.
    return MaterialApp( // Menginisialisasi aplikasi menggunakan material design.
        home: Scaffold( // Membuat tata letak dasar aplikasi.
      body: Center( // Membuat tata letak pusat untuk menempatkan widget di tengah.
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ // Membuat kolom vertikal untuk menempatkan widget.
          Padding( // Membungkus widget dengan padding.
            padding: EdgeInsets.only(bottom: 20), // Menentukan padding di bagian bawah.
            child: ElevatedButton( // Membuat tombol dengan latar belakang yang ditinggikan.
              onPressed: () { // Menentukan fungsi yang dijalankan saat tombol ditekan.
                setState(() { // Memperbarui state widget.
                  futureActivity =
                      fetchData(); // Memuat data baru ketika tombol ditekan.
                });
              },

              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              // Membangun antarmuka berdasarkan status snapshot.
              if (snapshot.hasData) {
                // Jika data sudah tersedia, tampilkan aktivitas dan jenis.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot
                          .data!.aktivitas), // Menampilkan aktivitas dari data.
                      Text(
                          "Jenis: ${snapshot.data!.jenis}") // Menampilkan jenis aktivitas dari data.
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi kesalahan, tampilkan pesan kesalahan.
                return Text('${snapshot.error}');
              }
              // Jika sedang memuat data, tampilkan indikator loading.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}