class AppointmentModel {
  final String id;
  final String ad;
  final String soyad;
  final String tc;
  final String email;
  final String telefon;
  final String dogumTarihi;
  final String adres;
  final String cinsiyet;
  final String sigortaTuru;
  final String sigortaFirma;
  final bool alerjisi;
  final String alerjiAciklama;
  final String sehir;
  final String hastane;
  final String bolum;
  final String doktorId;
  final String doktorAdi;
  final DateTime? randevuTarihi;
  final String? randevuSaati;
  final bool acilDurum;
  final String notlar;
  final List<String> ekHizmetler;
  final int refakatciSayisi;
  final bool kvkkOnay;
  final bool acikRizaOnay;
  final DateTime? olusturmaTarihi;

  const AppointmentModel({
    required this.id,
    this.ad = '',
    this.soyad = '',
    this.tc = '',
    this.email = '',
    this.telefon = '',
    this.dogumTarihi = '',
    this.adres = '',
    this.cinsiyet = 'erkek',
    this.sigortaTuru = '',
    this.sigortaFirma = '',
    this.alerjisi = false,
    this.alerjiAciklama = '',
    this.sehir = '',
    this.hastane = '',
    this.bolum = '',
    this.doktorId = '',
    this.doktorAdi = '',
    this.randevuTarihi,
    this.randevuSaati,
    this.acilDurum = false,
    this.notlar = '',
    this.ekHizmetler = const [],
    this.refakatciSayisi = 0,
    this.kvkkOnay = false,
    this.acikRizaOnay = false,
    this.olusturmaTarihi,
  });

  AppointmentModel copyWith({
    String? id,
    String? ad,
    String? soyad,
    String? tc,
    String? email,
    String? telefon,
    String? dogumTarihi,
    String? adres,
    String? cinsiyet,
    String? sigortaTuru,
    String? sigortaFirma,
    bool? alerjisi,
    String? alerjiAciklama,
    String? sehir,
    String? hastane,
    String? bolum,
    String? doktorId,
    String? doktorAdi,
    DateTime? randevuTarihi,
    String? randevuSaati,
    bool? acilDurum,
    String? notlar,
    List<String>? ekHizmetler,
    int? refakatciSayisi,
    bool? kvkkOnay,
    bool? acikRizaOnay,
    DateTime? olusturmaTarihi,
    bool clearRandevuTarihi = false,
    bool clearRandevuSaati = false,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      soyad: soyad ?? this.soyad,
      tc: tc ?? this.tc,
      email: email ?? this.email,
      telefon: telefon ?? this.telefon,
      dogumTarihi: dogumTarihi ?? this.dogumTarihi,
      adres: adres ?? this.adres,
      cinsiyet: cinsiyet ?? this.cinsiyet,
      sigortaTuru: sigortaTuru ?? this.sigortaTuru,
      sigortaFirma: sigortaFirma ?? this.sigortaFirma,
      alerjisi: alerjisi ?? this.alerjisi,
      alerjiAciklama: alerjiAciklama ?? this.alerjiAciklama,
      sehir: sehir ?? this.sehir,
      hastane: hastane ?? this.hastane,
      bolum: bolum ?? this.bolum,
      doktorId: doktorId ?? this.doktorId,
      doktorAdi: doktorAdi ?? this.doktorAdi,
      randevuTarihi: clearRandevuTarihi ? null : (randevuTarihi ?? this.randevuTarihi),
      randevuSaati: clearRandevuSaati ? null : (randevuSaati ?? this.randevuSaati),
      acilDurum: acilDurum ?? this.acilDurum,
      notlar: notlar ?? this.notlar,
      ekHizmetler: ekHizmetler ?? this.ekHizmetler,
      refakatciSayisi: refakatciSayisi ?? this.refakatciSayisi,
      kvkkOnay: kvkkOnay ?? this.kvkkOnay,
      acikRizaOnay: acikRizaOnay ?? this.acikRizaOnay,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'tc': tc,
      'email': email,
      'telefon': telefon,
      'dogumTarihi': dogumTarihi,
      'adres': adres,
      'cinsiyet': cinsiyet,
      'sigortaTuru': sigortaTuru,
      'sigortaFirma': sigortaFirma,
      'alerjisi': alerjisi,
      'alerjiAciklama': alerjiAciklama,
      'sehir': sehir,
      'hastane': hastane,
      'bolum': bolum,
      'doktorId': doktorId,
      'doktorAdi': doktorAdi,
      'randevuTarihi': randevuTarihi?.toIso8601String(),
      'randevuSaati': randevuSaati,
      'acilDurum': acilDurum,
      'notlar': notlar,
      'ekHizmetler': ekHizmetler,
      'refakatciSayisi': refakatciSayisi,
      'kvkkOnay': kvkkOnay,
      'acikRizaOnay': acikRizaOnay,
      'olusturmaTarihi': olusturmaTarihi?.toIso8601String(),
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      ad: json['ad'] as String? ?? '',
      soyad: json['soyad'] as String? ?? '',
      tc: json['tc'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefon: json['telefon'] as String? ?? '',
      dogumTarihi: json['dogumTarihi'] as String? ?? '',
      adres: json['adres'] as String? ?? '',
      cinsiyet: json['cinsiyet'] as String? ?? 'erkek',
      sigortaTuru: json['sigortaTuru'] as String? ?? '',
      sigortaFirma: json['sigortaFirma'] as String? ?? '',
      alerjisi: json['alerjisi'] as bool? ?? false,
      alerjiAciklama: json['alerjiAciklama'] as String? ?? '',
      sehir: json['sehir'] as String? ?? '',
      hastane: json['hastane'] as String? ?? '',
      bolum: json['bolum'] as String? ?? '',
      doktorId: json['doktorId'] as String? ?? '',
      doktorAdi: json['doktorAdi'] as String? ?? '',
      randevuTarihi: json['randevuTarihi'] != null
          ? DateTime.tryParse(json['randevuTarihi'] as String)
          : null,
      randevuSaati: json['randevuSaati'] as String?,
      acilDurum: json['acilDurum'] as bool? ?? false,
      notlar: json['notlar'] as String? ?? '',
      ekHizmetler: json['ekHizmetler'] != null
          ? List<String>.from(json['ekHizmetler'] as List)
          : [],
      refakatciSayisi: json['refakatciSayisi'] as int? ?? 0,
      kvkkOnay: json['kvkkOnay'] as bool? ?? false,
      acikRizaOnay: json['acikRizaOnay'] as bool? ?? false,
      olusturmaTarihi: json['olusturmaTarihi'] != null
          ? DateTime.tryParse(json['olusturmaTarihi'] as String)
          : null,
    );
  }
}
