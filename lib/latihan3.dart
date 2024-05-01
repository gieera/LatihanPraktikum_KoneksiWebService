import 'package:flutter/material.dart'; // Import pustaka Flutter yang menyediakan berbagai widget UI dan alat pengembangan untuk membuat aplikasi mobile.
import 'package:http/http.dart'
    as http; // Import paket HTTP dari Flutter, yang memungkinkan untuk melakukan panggilan HTTP ke server.
import 'dart:convert'; // Import pustaka dart:convert, yang menyediakan fungsi-fungsi untuk mengonversi data antara format JSON dan objek Dart.

// Kelas untuk menyimpan nama dan situs universitas.
class SitusNama {
  String nama; // Variabel untuk menyimpan nama universitas.
  String situs; // Variabel untuk menyimpan situs web universitas.

  // Konstruktor untuk inisialisasi variabel nama dan situs.
  SitusNama({required this.nama, required this.situs});
}

// Kelas untuk menyimpan daftar nama dan situs universitas.
class Situs {
  List<SitusNama> ListPop = <SitusNama>[];

  // Konstruktor untuk membuat objek Situs dari data JSON.
  Situs(List<dynamic> json) {
    // Isi listPop di sini
    for (var data in json) {
      var nama = data['name']; // Mengambil nama universitas dari JSON.
      var situs = data['web_pages']
          [0]; // Mengambil situs web pertama dari daftar situs web universitas.
      ListPop.add(SitusNama(nama: nama, situs: situs));
    }
  }

  // Metode factory untuk membuat objek Situs dari JSON.
  factory Situs.fromJson(List<dynamic> json) {
    return Situs(json);
  }
}

void main() {
  runApp(MyApp());
}

// Kelas MyApp adalah widget utama aplikasi.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

// State widget MyApp
class MyAppState extends State<MyApp> {
  late Future<Situs> futureSitus;

  // URL untuk mengambil data universitas dari API.
  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  // Metode untuk mengambil data dari API.
  Future<Situs> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika server mengembalikan 200 OK (berhasil),
      // parsing JSON untuk membuat objek Situs.
      return Situs.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal (bukan 200 OK),
      // lempar exception.
      throw Exception('Gagal load');
    }
  }

  // Override initState untuk inisialisasi state widget.
  @override
  void initState() {
    super.initState();
    // Memanggil metode fetchData saat initState dipanggil.
    futureSitus =
        fetchData(); // Memanggil metode fetchData untuk mendapatkan data dari API.
  }

  // Override build untuk membangun UI aplikasi.
  @override
  Widget build(BuildContext context) {
    // Mengembalikan MaterialApp sebagai root widget aplikasi.
    return MaterialApp(
      // Judul aplikasi.
      title: 'Nama dan Situs Universitas',
      // Scaffold adalah layout utama aplikasi.
      home: Scaffold(
        // AppBar berisi judul aplikasi.
        appBar: AppBar(
          title: const Text('Nama dan Situs Universitas'),
        ),
        // Body aplikasi terletak di tengah-tengah layar.
        body: Center(
          // FutureBuilder digunakan untuk menampilkan widget berdasarkan Future yang sedang berjalan.
          child: FutureBuilder<Situs>(
            // Future yang sedang dimonitor.
            future: futureSitus,
            // Builder digunakan untuk menentukan bagaimana tampilan akan dirender berdasarkan state Future.
            builder: (context, snapshot) {
              // Jika snapshot memiliki data.
              if (snapshot.hasData) {
                // Tampilkan ListView builder dengan daftar universitas.
                return Center(
                  child: ListView.builder(
                    // Jumlah item dalam ListView sesuai dengan panjang ListPop.
                    itemCount: snapshot.data!.ListPop.length,
                    // itemBuilder digunakan untuk membangun item ListView.
                    itemBuilder: (context, index) {
                      return Container(
                        // Membuat border pada container.
                        decoration: BoxDecoration(border: Border.all()),
                        // Padding diatur agar konten dalam container tidak terlalu rapat.
                        padding: const EdgeInsets.all(14),
                        // Menampilkan nama universitas.
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(snapshot.data!.ListPop[index].nama.toString()),
                            // Menampilkan situs web universitas.
                            Text(
                                snapshot.data!.ListPop[index].situs.toString()),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                // Jika terjadi error, tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Jika belum ada data, tampilkan indikator loading.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}