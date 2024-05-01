import 'dart:convert';

void main() {
  // JSON transkrip mahasiswa
  String transkripJson = '''
  {
    "nama": "ENGIE RAMADHANI",
    "npm": "22082010029",
    "program_studi": "Sistem Informasi",
    "jumlah_semester": 3,
    "transkrip": [
      {
        "semester": 1,
        "mata_kuliah": [
          {
            "kode": "SI211101",
            "nama": "Pengantar Sistem Informasi",
            "sks": 3,
            "nilai": "A-"
          },
          {
            "kode": "SI2111102",
            "nama": "Pancasila",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "SI211103",
            "nama": "Logika dan Algoritma",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "SI2111104",
            "nama": "Bahasa Inggris",
            "sks": 3,
            "nilai": "A-"
          }
        ]
      },
      {
        "semester": 2,
        "mata_kuliah": [
          {
            "kode": "SI211105",
            "nama": "Rekayasa Perangkat Lunak",
            "sks": 3,
            "nilai": "B+"
          },
          {
            "kode": "SI211106",
            "nama": "Sistem Informasi Manajemen",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "SI211107",
            "nama": "Analisis Proses Bisnis",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "SI211108",
            "nama": "Bahasa Pemrograman 2",
            "sks": 3,
            "nilai": "A-"
          }
        ]
      },
      {
        "semester": 3,
        "mata_kuliah": [
          {
            "kode": "SI211109",
            "nama": "Penelitian Metodelogi",
            "sks": 3,
            "nilai": "A-"
          },
          {
            "kode": "SI211110",
            "nama": "Administrasi Basis Data",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "SI211111",
            "nama": "Desain Manajemen Jaringan",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "SI211112",
            "nama": "Interaksi Manusia Komputer",
            "sks": 3,
            "nilai": "B+"
          }
        ]
      }
    ]
  }
  ''';

  Map<String, dynamic> transkrip = jsonDecode(transkripJson);

  print('Transkrip Nilai Mahasiswa:');
  print('Nama: ${transkrip['nama']}');
  print('NPM: ${transkrip['npm']}');
  print('Program Studi: ${transkrip['program_studi']}');
  print('Jumlah Semester: ${transkrip['jumlah_semester']}');

  double ipk = hitungIPK(transkrip['transkrip']);

  print('IPK: ${ipk.toStringAsFixed(2)}');
}

double hitungIPK(List<dynamic> transkrip) {
  double totalBobot = 0;
  int totalSKS = 0;

  for (var semester in transkrip) {
    for (var matkul in semester['mata_kuliah']) {
      double bobot = konversiNilaiKeBobot(matkul['nilai']);
      int sks = matkul['sks'];

      totalBobot += bobot * sks;
      totalSKS += sks;
    }
  }

  double ipk = totalBobot / totalSKS;
  return ipk;
}

double konversiNilaiKeBobot(String nilai) {
  switch (nilai) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.75;
    case 'B':
      return 3.3;
    case 'B+':
      return 3.5;
    default:
      return 0.0;
  }
}