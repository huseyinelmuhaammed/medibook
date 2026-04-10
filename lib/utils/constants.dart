class AppConstants {
  static const List<String> sigortaTurleri = ['SGK', 'Özel', 'Yok'];

  static const List<String> ekHizmetlerListesi = [
    'Kan Tahlili',
    'MR',
    'Röntgen',
    'EKG',
    'Ultrason',
  ];

  static const Map<String, String> ekHizmetlerKeys = {
    'Kan Tahlili': 'chip_kan_tahlili',
    'MR': 'chip_mr',
    'Röntgen': 'chip_rontgen',
    'EKG': 'chip_ekg',
    'Ultrason': 'chip_ultrason',
  };
}
