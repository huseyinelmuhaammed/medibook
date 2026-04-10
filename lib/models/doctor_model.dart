class DoctorModel {
  final String id;
  final String ad;
  final String unvan;
  final String bolum;
  final String hastane;
  final String sehir;
  final double puan;
  final int deneyimYil;
  final String resimUrl;
  final List<String> muzakereSaatleri;
  final bool aktif;

  const DoctorModel({
    required this.id,
    required this.ad,
    required this.unvan,
    required this.bolum,
    required this.hastane,
    required this.sehir,
    required this.puan,
    required this.deneyimYil,
    this.resimUrl = 'https://via.placeholder.com/150',
    required this.muzakereSaatleri,
    this.aktif = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'unvan': unvan,
      'bolum': bolum,
      'hastane': hastane,
      'sehir': sehir,
      'puan': puan,
      'deneyimYil': deneyimYil,
      'resimUrl': resimUrl,
      'muzakereSaatleri': muzakereSaatleri,
      'aktif': aktif,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      ad: json['ad'] as String,
      unvan: json['unvan'] as String,
      bolum: json['bolum'] as String,
      hastane: json['hastane'] as String,
      sehir: json['sehir'] as String,
      puan: (json['puan'] as num).toDouble(),
      deneyimYil: json['deneyimYil'] as int,
      resimUrl: json['resimUrl'] as String? ?? 'https://via.placeholder.com/150',
      muzakereSaatleri: List<String>.from(json['muzakereSaatleri'] as List),
      aktif: json['aktif'] as bool? ?? true,
    );
  }
}
