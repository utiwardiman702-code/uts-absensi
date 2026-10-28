import 'data.dart';
import 'input.dart';

// ============================================================
// Fungsi bantu
// ============================================================

/// Mencari mahasiswa berdasarkan NIM. Mengembalikan null jika tidak ada.
Map<String, dynamic>? cariByNim(String nim) {
  for (final mhs in daftarMahasiswa) {
    if (mhs['nim'] == nim) return mhs;
  }
  return null;
}

/// Mencetak satu baris data mahasiswa.
void cetakMahasiswa(Map<String, dynamic> mhs) {
  print('${mhs['nim']} | ${mhs['nama']}');
}

/// Meminta pengguna memilih status kehadiran.
StatusHadir bacaStatus(String label) {
  final pilihan = bacaInt(
    '$label (1=hadir, 2=izin, 3=sakit, 4=alpa)',
    min: 1,
    max: 4,
  );
  return switch (pilihan) {
    1 => StatusHadir.hadir,
    2 => StatusHadir.izin,
    3 => StatusHadir.sakit,
    _ => StatusHadir.alpa,
  };
}

// ============================================================
// Fitur yang sudah jadi
// ============================================================

/// Menu 1: menampilkan semua mahasiswa.
void tampilkanDaftar() {
  print('\n=== Daftar Mahasiswa ===');
  if (daftarMahasiswa.isEmpty) {
    print('Belum ada data mahasiswa.');
    return;
  }
  for (final mhs in daftarMahasiswa) {
    cetakMahasiswa(mhs);
  }
}

/// Menu 2: mencatat absensi untuk pertemuan berikutnya.
void catatAbsensi() {
  final nomor = absensi.length + 1;
  print('\n=== Catat Absensi Pertemuan $nomor ===');
  final Map<String, StatusHadir> data = {};
  for (final mhs in daftarMahasiswa) {
    data[mhs['nim'] as String] = bacaStatus('Status ${mhs['nama']}');
  }
  absensi[nomor] = data;
  print('Absensi pertemuan $nomor tersimpan.');
}

/// Menu 3: menampilkan absensi pada satu pertemuan.
void tampilkanAbsensiPertemuan() {
  print('\n=== Absensi per Pertemuan ===');
  if (absensi.isEmpty) {
    print('Belum ada absensi.');
    return;
  }
  final nomor = bacaInt('Nomor pertemuan', min: 1, max: absensi.length);
  final data = absensi[nomor]!;
  print('Pertemuan $nomor:');
  for (final mhs in daftarMahasiswa) {
    final status = data[mhs['nim']];
    print('${mhs['nim']} | ${mhs['nama']} | ${status?.name ?? '-'}');
  }
}

// ============================================================
// Fitur pilihan (pilih minimal 3, lihat README.md)
// ============================================================

/// Menu 4 [Mudah]: menambah mahasiswa baru.
void tambahMahasiswa() {
  // TODO: minta NIM dan nama. Tolak jika NIM sudah terdaftar (pakai cariByNim).
  // Tambahkan ke daftarMahasiswa.
  print('Fitur belum tersedia.');
}

/// Menu 5 [Mudah]: mencari mahasiswa berdasarkan sebagian nama.
void cariMahasiswa() {
  // TODO: minta kata kunci, tampilkan semua mahasiswa yang namanya mengandung
  // kata kunci tersebut (huruf besar/kecil tidak dibedakan).
  final kataKunci = bacaTeks('Masukkan nama yang dicari').toLowerCase();

final hasil = daftarMahasiswa.where((mhs) {
  final nama = (mhs['nama'] as String).toLowerCase();
  return nama.contains(kataKunci);
}).toList();

if (hasil.isEmpty) {
  print('Mahasiswa tidak ditemukan.');
  return;
}

print('\n=== Hasil Pencarian ===');

for (final mhs in hasil) {
  cetakMahasiswa(mhs);
}
}

/// Menu 6 [Sedang]: mengubah status absensi seorang mahasiswa.
void ubahStatus() {
  // TODO: minta nomor pertemuan, NIM, dan status baru (pakai bacaStatus).
  // Simpan status baru ke absensi[nomor].
  print('Fitur belum tersedia.');
}

/// Menu 7 [Sedang]: menampilkan jumlah setiap status per mahasiswa.
void tampilkanRekap() {
  // TODO: untuk setiap mahasiswa, hitung berapa kali hadir, izin, sakit, dan alpa
  // dari semua pertemuan.
 print('\n=== Rekap Absensi ===');

for (final mhs in daftarMahasiswa) {
  final nim = mhs['nim'] as String;

  int hadir = 0;
  int izin = 0;
  int sakit = 0;
  int alpa = 0;

  for (final data in absensi.values) {
    final status = data[nim];

    switch (status) {
      case StatusHadir.hadir:
        hadir++;
        break;
      case StatusHadir.izin:
        izin++;
        break;
      case StatusHadir.sakit:
        sakit++;
        break;
      case StatusHadir.alpa:
        alpa++;
        break;
      default:
        break;
    }
  }

  print('\n${mhs['nim']} | ${mhs['nama']}');
  print('Hadir : $hadir');
  print('Izin  : $izin');
  print('Sakit : $sakit');
  print('Alpa  : $alpa');
}
}

/// Menu 8 [Sulit]: menampilkan persentase kehadiran setiap mahasiswa.
void tampilkanPersentase() {
  // TODO: persentase = jumlah hadir / jumlah pertemuan x 100.
  // Tampilkan 1 angka di belakang koma.
  print('Fitur belum tersedia.');
}

/// Menu 9 [Sulit]: menampilkan mahasiswa dengan kehadiran di bawah batas.
void tampilkanDiBawahBatas() {
  // TODO: tampilkan mahasiswa yang persentase kehadirannya < batasKehadiran
  // (lihat data.dart) beserta persentasenya.
  {
  const double batasKehadiran = 75.0;

  print('\n=== Kehadiran di Bawah 75% ===');

  if (absensi.isEmpty) {
    print('Belum ada data absensi.');
    return;
  }

  final jumlahPertemuan = absensi.length;
  bool ditemukan = false;

  for (final mhs in daftarMahasiswa) {
    final nim = mhs['nim'] as String;
    final nama = mhs['nama'];

    int jumlahHadir = 0;

    for (final data in absensi.values) {
      if (data[nim] == StatusHadir.hadir) {
        jumlahHadir++;
      }
    }

    final persentase =
        (jumlahHadir / jumlahPertemuan) * 100;

    if (persentase < batasKehadiran) {
      print('$nama | ${persentase.toStringAsFixed(1)}%');
      ditemukan = true;
    }
  }

  if (!ditemukan) {
    print('Tidak ada mahasiswa di bawah batas kehadiran.');
  }
}
}
