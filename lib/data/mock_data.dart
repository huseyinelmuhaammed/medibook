import 'dart:math';

import '../models/doctor_model.dart';

class MockData {
  MockData._();

  // ── Cities ──────────────────────────────────────────────────────────────────
  static const List<String> cities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
  ];

  // ── Hospitals by city ────────────────────────────────────────────────────────
  static const Map<String, List<String>> hospitalsByCity = {
    'İstanbul': [
      'Acıbadem Maslak',
      'Florence Nightingale',
      'Memorial Şişli',
    ],
    'Ankara': [
      'Hacettepe Üniversitesi',
      'Ankara Şehir Hastanesi',
      'Güven Hastanesi',
    ],
    'İzmir': [
      'Ege Üniversitesi Hastanesi',
      'Kent Hastanesi',
      'Medical Park İzmir',
    ],
    'Bursa': [
      'Uludağ Üniversitesi Hastanesi',
      'Medical Park Bursa',
      'Medicana Bursa',
    ],
  };

  // ── Departments by hospital ──────────────────────────────────────────────────
  static const Map<String, List<String>> departmentsByHospital = {
    'Acıbadem Maslak': [
      'Kardiyoloji',
      'Ortopedi',
      'Nöroloji',
      'Dahiliye',
      'Göz Hastalıkları',
    ],
    'Florence Nightingale': [
      'Kardiyoloji',
      'Genel Cerrahi',
      'Kadın Hastalıkları',
      'Pediatri',
      'Psikiyatri',
    ],
    'Memorial Şişli': [
      'Onkoloji',
      'Nöroloji',
      'Kardiyoloji',
      'Ortopedi',
      'Üroloji',
    ],
    'Hacettepe Üniversitesi': [
      'Dahiliye',
      'Genel Cerrahi',
      'Nöroloji',
      'Kardiyoloji',
      'Ortopedi',
    ],
    'Ankara Şehir Hastanesi': [
      'Pediatri',
      'Dahiliye',
      'Kardiyoloji',
      'Ortopedi',
      'Genel Cerrahi',
    ],
    'Güven Hastanesi': [
      'Kardiyoloji',
      'Dahiliye',
      'Ortopedi',
      'Psikiyatri',
      'Dermatoloji',
    ],
    'Ege Üniversitesi Hastanesi': [
      'Nöroloji',
      'Kardiyoloji',
      'Onkoloji',
      'Dahiliye',
      'Pediatri',
    ],
    'Kent Hastanesi': [
      'Kardiyoloji',
      'Ortopedi',
      'Genel Cerrahi',
      'Dahiliye',
      'Göz Hastalıkları',
    ],
    'Medical Park İzmir': [
      'Kardiyoloji',
      'Ortopedi',
      'Kadın Hastalıkları',
      'Pediatri',
      'Nöroloji',
    ],
    'Uludağ Üniversitesi Hastanesi': [
      'Dahiliye',
      'Kardiyoloji',
      'Nöroloji',
      'Ortopedi',
      'Onkoloji',
    ],
    'Medical Park Bursa': [
      'Kardiyoloji',
      'Genel Cerrahi',
      'Ortopedi',
      'Pediatri',
      'Dahiliye',
    ],
    'Medicana Bursa': [
      'Kardiyoloji',
      'Ortopedi',
      'Dahiliye',
      'Kadın Hastalıkları',
      'Üroloji',
    ],
  };

  // ── Doctor name pools ───────────────────────────────────────────────────────
  static const List<String> _erkekAdlari = [
    'Mehmet', 'Ahmet', 'Ali', 'Mustafa', 'Hasan',
    'Hüseyin', 'İbrahim', 'Kemal', 'Emre', 'Burak',
    'Can', 'Murat', 'Cem', 'Tarık', 'Sinan',
    'Levent', 'Okan', 'Taner', 'Alper', 'Serkan',
    'Deniz', 'Volkan', 'Ufuk', 'Bülent', 'Fatih',
    'Barış', 'Erkan', 'Selim', 'Yusuf', 'Onur',
    'Arda', 'Tolga', 'Cenk', 'Berke', 'Kaan',
    'Erdem', 'Umut', 'Koray', 'Bora', 'Doruk',
  ];

  static const List<String> _kadinAdlari = [
    'Ayşe', 'Fatma', 'Elif', 'Zeynep', 'Merve',
    'Gül', 'Selin', 'İpek', 'Gamze', 'Pınar',
    'Ceyda', 'Özge', 'Esra', 'Gizem', 'Hülya',
    'Nilüfer', 'Derya', 'Başak', 'Burcu', 'Nihan',
    'Aslı', 'Ebru', 'Defne', 'Beren', 'Cansu',
    'Dilan', 'İrem', 'Melis', 'Nazlı', 'Serra',
    'Tuğba', 'Sevgi', 'Büşra', 'Yağmur', 'Deniz',
    'Simge', 'Ece', 'Sude', 'Hazal', 'Ceren',
  ];

  static const List<String> _soyadlar = [
    'Yılmaz', 'Kaya', 'Demir', 'Şahin', 'Çelik',
    'Arslan', 'Öztürk', 'Koç', 'Yıldız', 'Güneş',
    'Doğan', 'Aydın', 'Polat', 'Aktaş', 'Kara',
    'Uçar', 'Karahan', 'Şen', 'Erdoğan', 'Altan',
    'Kılıç', 'Toprak', 'Güler', 'Demirci', 'Yıldırım',
    'Kaplan', 'Başar', 'Çetin', 'Acar', 'Korkmaz',
    'Cengiz', 'Tuncer', 'Özkan', 'Sezer', 'Taşkın',
    'Peker', 'Akbaş', 'Balkır', 'Durmuş', 'Tekin',
  ];

  static const Map<String, List<String>> _uzmanliklar = {
    'Kardiyoloji': [
      'Kardiyoloji Uzmanı',
      'İntervansiyon Kardiyolojisi',
      'Pediatrik Kardiyoloji',
      'Elektrofizyoloji',
      'Ekokardiyografi Uzmanı',
    ],
    'Ortopedi': [
      'Ortopedi ve Travmatoloji',
      'Spor Ortopedisi',
      'El Cerrahisi',
      'Omurga Cerrahisi',
      'Diz ve Kalça Protezi',
    ],
    'Nöroloji': [
      'Nöroloji Uzmanı',
      'Klinik Nöroloji',
      'Nörovasküler Hastalıklar',
      'Epilepsi Uzmanı',
      'Nörodejeneratif Hastalıklar',
    ],
    'Dahiliye': [
      'İç Hastalıkları Uzmanı',
      'Endokrinoloji',
      'Gastroenteroloji',
      'Romatoloji',
      'Hematoloji',
    ],
    'Göz Hastalıkları': [
      'Oftalmoloji Uzmanı',
      'Retina Uzmanı',
      'Glokom Uzmanı',
      'Katarakt Cerrahisi',
      'Pediatrik Oftalmoloji',
    ],
    'Genel Cerrahi': [
      'Genel Cerrahi Uzmanı',
      'Laparoskopik Cerrahi',
      'Tiroid Cerrahisi',
      'Meme Cerrahisi',
      'Kolorektal Cerrahi',
    ],
    'Kadın Hastalıkları': [
      'Kadın Hastalıkları ve Doğum',
      'Jinekolojik Onkoloji',
      'Perinatoloji',
      'Tüp Bebek Uzmanı',
      'Jinekoloji Uzmanı',
    ],
    'Pediatri': [
      'Çocuk Sağlığı ve Hastalıkları',
      'Neonatoloji',
      'Pediatrik Alerji',
      'Pediatrik Nöroloji',
      'Pediatrik Kardiyoloji',
    ],
    'Psikiyatri': [
      'Psikiyatri Uzmanı',
      'Çocuk Psikiyatrisi',
      'Bağımlılık Psikiyatrisi',
      'Geriatrik Psikiyatri',
      'Klinik Psikolog',
    ],
    'Onkoloji': [
      'Tıbbi Onkoloji Uzmanı',
      'Radyasyon Onkolojisi',
      'Cerrahi Onkoloji',
      'Hematolojik Onkoloji',
      'Pediatrik Onkoloji',
    ],
    'Üroloji': [
      'Üroloji Uzmanı',
      'Androloji',
      'Endoüroloji',
      'Üroonkoloji',
      'Pediatrik Üroloji',
    ],
    'Dermatoloji': [
      'Dermatoloji Uzmanı',
      'Medikal Dermatoloji',
      'Kozmetik Dermatoloji',
      'Dermatopatoloji',
      'Pediatrik Dermatoloji',
    ],
  };

  // ── Doctor generation ───────────────────────────────────────────────────────
  static final Map<String, List<DoctorModel>> _doctorCache = {};

  static List<DoctorModel> getDoctors(String hastane, String bolum) {
    final key = '${hastane}_$bolum';
    return _doctorCache.putIfAbsent(key, () => _generateDoctors(hastane, bolum));
  }

  static List<DoctorModel> _generateDoctors(String hastane, String bolum) {
    final seed = hastane.codeUnits.fold<int>(0, (a, b) => a * 31 + b) +
        bolum.codeUnits.fold<int>(0, (a, b) => a * 37 + b);
    final rng = Random(seed.abs());

    final uzmanlikList = _uzmanliklar[bolum] ?? ['Uzman'];
    final doctors = <DoctorModel>[];

    for (int i = 0; i < 5; i++) {
      final isKadin = rng.nextBool();
      final adList = isKadin ? _kadinAdlari : _erkekAdlari;
      final ad = adList[rng.nextInt(adList.length)];
      final soyad = _soyadlar[rng.nextInt(_soyadlar.length)];
      final uzmanlik = uzmanlikList[i % uzmanlikList.length];
      final rating = 4.3 + rng.nextDouble() * 0.7;
      final reviewCount = 80 + rng.nextInt(300);
      final tecrube = 6 + rng.nextInt(20);

      doctors.add(DoctorModel(
        id: 'doc_${seed.abs() % 10000}_${i}',
        ad: ad,
        soyad: soyad,
        uzmanlik: uzmanlik,
        rating: double.parse(rating.toStringAsFixed(1)),
        reviewCount: reviewCount,
        bolum: bolum,
        hastane: hastane,
        tecrube: '$tecrube yıl',
      ));
    }

    return doctors;
  }

  // ── Time slots ────────────────────────────────────────────────────────────────
  static List<String> generateSlots() {
    final slots = <String>[];
    for (int h = 9; h < 17; h++) {
      slots.add('${h.toString().padLeft(2, '0')}:00');
      slots.add('${h.toString().padLeft(2, '0')}:30');
    }
    return slots;
  }

  static const List<String> defaultOccupiedSlots = [
    '09:00',
    '10:30',
    '13:00',
    '15:30',
  ];

  static const List<String> busyDayOccupiedSlots = [
    '09:00',
    '09:30',
    '10:00',
    '11:30',
    '12:30',
    '13:00',
    '14:00',
    '15:30',
    '16:00',
  ];

  static bool isSlotOccupied(DateTime date, String slot) {
    if (date.day % 3 == 0) {
      return busyDayOccupiedSlots.contains(slot);
    }
    return defaultOccupiedSlots.contains(slot);
  }

  // ── Holidays ──────────────────────────────────────────────────────────────────
  static final List<DateTime> holidays = [
    DateTime(2025, 1, 1),
    DateTime(2025, 4, 23),
    DateTime(2025, 5, 1),
    DateTime(2025, 5, 19),
    DateTime(2025, 7, 15),
    DateTime(2025, 8, 30),
    DateTime(2025, 10, 29),
    DateTime(2026, 1, 1),
    DateTime(2026, 4, 23),
    DateTime(2026, 5, 1),
  ];

  static bool isHoliday(DateTime date) {
    return holidays.any(
      (h) => h.year == date.year && h.month == date.month && h.day == date.day,
    );
  }

  // ── Insurance types ───────────────────────────────────────────────────────────
  static const List<String> sigortaTurleri = [
    'SGK',
    'Özel Sigorta',
    'Yok',
  ];

  // ── Kronik hastalıklar ────────────────────────────────────────────────────────
  static const List<String> kronikHastaliklar = [
    'Diyabet',
    'Hipertansiyon',
    'Astım',
    'Kalp Hastalığı',
    'Tiroid',
    'KOAH',
    'Epilepsi',
    'Böbrek Yetmezliği',
    'Romatizma',
    'Migren',
  ];

  // ── Ulaşım seçenekleri ────────────────────────────────────────────────────────
  static const List<String> ulasimSecenekleri = [
    'Kendi Aracım',
    'Servis',
    'Ambulans',
    'Gerekmiyor',
  ];

  // ── Hatırlatma seçenekleri ────────────────────────────────────────────────────
  static const List<String> hatirlatmaSecenekleri = [
    'SMS',
    'E-posta',
    'Uygulama Bildirimi',
  ];

  // ── Pricing ───────────────────────────────────────────────────────────────────
  static const double muayeneBedeli = 350.0;
  static const double kanTahlilifiyati = 150.0;
  static const double mrFiyati = 800.0;
  static const double rontgenFiyati = 200.0;
  static const double refakatciFiyati = 50.0;

  static double hesaplaToplam({
    required bool kanTahlili,
    required bool mr,
    required bool rontgen,
    required int refakatciSayisi,
  }) {
    double toplam = muayeneBedeli;
    if (kanTahlili) toplam += kanTahlilifiyati;
    if (mr) toplam += mrFiyati;
    if (rontgen) toplam += rontgenFiyati;
    toplam += refakatciSayisi * refakatciFiyati;
    return toplam;
  }
}
