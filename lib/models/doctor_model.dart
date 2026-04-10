class DoctorModel {
  final String id;
  final String ad;
  final String soyad;
  final String uzmanlik;
  final double rating;
  final int reviewCount;
  final String bolum;
  final String hastane;
  final String tecrube;

  const DoctorModel({
    required this.id,
    required this.ad,
    required this.soyad,
    required this.uzmanlik,
    required this.rating,
    required this.reviewCount,
    required this.bolum,
    required this.hastane,
    this.tecrube = '',
  });

  String get fullName => 'Dr. $ad $soyad';

  String get initials =>
      '${ad.isNotEmpty ? ad[0] : ''}${soyad.isNotEmpty ? soyad[0] : ''}'.toUpperCase();

  Map<String, dynamic> toJson() => {
        'id': id,
        'ad': ad,
        'soyad': soyad,
        'uzmanlik': uzmanlik,
        'rating': rating,
        'reviewCount': reviewCount,
        'bolum': bolum,
        'hastane': hastane,
        'tecrube': tecrube,
      };

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json['id'] ?? '',
        ad: json['ad'] ?? '',
        soyad: json['soyad'] ?? '',
        uzmanlik: json['uzmanlik'] ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] ?? 0,
        bolum: json['bolum'] ?? '',
        hastane: json['hastane'] ?? '',
        tecrube: json['tecrube'] ?? '',
      );
}
