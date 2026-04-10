class AppointmentModel {
  final String? id;

  // Step 1 - Kişisel Bilgiler
  final String ad;
  final String soyad;
  final String tc;
  final String email;
  final String telefon;
  final String dogumTarihi;
  final String cinsiyet;
  final String adres;

  // Step 2 - Sigorta & Sağlık
  final String sigortaTuru;
  final String sigortaFirma;
  final List<String> kronikHastaliklar;
  final List<String> kullanilanIlaclar;
  final bool alerjisi;
  final String alerjiAciklama;

  // Step 3 - Bölüm & Doktor
  final String sehir;
  final String hastane;
  final String bolum;
  final String doktorId;
  final String doktorAdi;

  // Step 4 - Tarih & Saat
  final String tarih;
  final String saat;
  final bool acilRandevu;
  final String notlar;

  // Step 5 - Ek Hizmetler & Onaylar
  final bool kanTahlili;
  final bool mr;
  final bool rontgen;
  final int refakatciSayisi;
  final String ulasimYardimi;
  final List<String> hatirlatmalar;
  final bool kvkkKabul;
  final bool acikRizaKabul;

  const AppointmentModel({
    this.id,
    this.ad = '',
    this.soyad = '',
    this.tc = '',
    this.email = '',
    this.telefon = '',
    this.dogumTarihi = '',
    this.cinsiyet = '',
    this.adres = '',
    this.sigortaTuru = '',
    this.sigortaFirma = '',
    this.kronikHastaliklar = const [],
    this.kullanilanIlaclar = const [],
    this.alerjisi = false,
    this.alerjiAciklama = '',
    this.sehir = '',
    this.hastane = '',
    this.bolum = '',
    this.doktorId = '',
    this.doktorAdi = '',
    this.tarih = '',
    this.saat = '',
    this.acilRandevu = false,
    this.notlar = '',
    this.kanTahlili = false,
    this.mr = false,
    this.rontgen = false,
    this.refakatciSayisi = 0,
    this.ulasimYardimi = '',
    this.hatirlatmalar = const [],
    this.kvkkKabul = false,
    this.acikRizaKabul = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ad': ad,
        'soyad': soyad,
        'tc': tc,
        'email': email,
        'telefon': telefon,
        'dogumTarihi': dogumTarihi,
        'cinsiyet': cinsiyet,
        'adres': adres,
        'sigortaTuru': sigortaTuru,
        'sigortaFirma': sigortaFirma,
        'kronikHastaliklar': kronikHastaliklar,
        'kullanilanIlaclar': kullanilanIlaclar,
        'alerjisi': alerjisi,
        'alerjiAciklama': alerjiAciklama,
        'sehir': sehir,
        'hastane': hastane,
        'bolum': bolum,
        'doktorId': doktorId,
        'doktorAdi': doktorAdi,
        'tarih': tarih,
        'saat': saat,
        'acilRandevu': acilRandevu,
        'notlar': notlar,
        'kanTahlili': kanTahlili,
        'mr': mr,
        'rontgen': rontgen,
        'refakatciSayisi': refakatciSayisi,
        'ulasimYardimi': ulasimYardimi,
        'hatirlatmalar': hatirlatmalar,
        'kvkkKabul': kvkkKabul,
        'acikRizaKabul': acikRizaKabul,
      };

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json['id'],
        ad: json['ad'] ?? '',
        soyad: json['soyad'] ?? '',
        tc: json['tc'] ?? '',
        email: json['email'] ?? '',
        telefon: json['telefon'] ?? '',
        dogumTarihi: json['dogumTarihi'] ?? '',
        cinsiyet: json['cinsiyet'] ?? '',
        adres: json['adres'] ?? '',
        sigortaTuru: json['sigortaTuru'] ?? '',
        sigortaFirma: json['sigortaFirma'] ?? '',
        kronikHastaliklar:
            List<String>.from(json['kronikHastaliklar'] ?? []),
        kullanilanIlaclar:
            List<String>.from(json['kullanilanIlaclar'] ?? []),
        alerjisi: json['alerjisi'] ?? false,
        alerjiAciklama: json['alerjiAciklama'] ?? '',
        sehir: json['sehir'] ?? '',
        hastane: json['hastane'] ?? '',
        bolum: json['bolum'] ?? '',
        doktorId: json['doktorId'] ?? '',
        doktorAdi: json['doktorAdi'] ?? '',
        tarih: json['tarih'] ?? '',
        saat: json['saat'] ?? '',
        acilRandevu: json['acilRandevu'] ?? false,
        notlar: json['notlar'] ?? '',
        kanTahlili: json['kanTahlili'] ?? false,
        mr: json['mr'] ?? false,
        rontgen: json['rontgen'] ?? false,
        refakatciSayisi: json['refakatciSayisi'] ?? 0,
        ulasimYardimi: json['ulasimYardimi'] ?? '',
        hatirlatmalar: List<String>.from(json['hatirlatmalar'] ?? []),
        kvkkKabul: json['kvkkKabul'] ?? false,
        acikRizaKabul: json['acikRizaKabul'] ?? false,
      );
}
