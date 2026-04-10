# MediBook — Akıllı Hastane Randevu Sistemi

Ad Soyad: <HÜSEYİN ELMUHAMMED>/
Öğrenci No: <22080410209>
Ders/Lab:bmu1422

> **Paket Adı:** `com.bmu1422.medibook`  
> **Versiyon:** 1.0.0+1  
> **Flutter SDK:** ≥3.11.1

---

## Proje Açıklaması

MediBook, Flutter ile geliştirilmiş 6 adımlı wizard tabanlı bir hastane randevu alma uygulamasıdır. Kullanıcılar kişisel bilgilerinden doktor seçimine, tarih & saatten ek hizmetlere kadar adım adım ilerleyerek randevularını oluşturabilir.

### Temel Özellikler

| Özellik | Detay |
|---|---|
| 6 Adımlı Wizard | Kişisel → Sigorta → Doktor → Tarih → Hizmetler → Özet |
| State Yönetimi | Provider (global, adımlar arası kalıcı) |
| Draft Kayıt | SharedPreferences ile taslak otomatik kaydedilir |
| TC Doğrulama | Algoritma + mock async kontrol |
| Cascading Dropdown | Şehir → Hastane → Bölüm → Doktor |
| Slot Picker | 30 dk'lık slotlar, dolu/boş gösterimi |
| Form Validasyon | Tüm alanlarda, koşullu validasyon dahil |
| Material 3 | Modern, premium sağlık teması |

---

## Klasör Yapısı

```
lib/
├── main.dart
├── app.dart
├── models/
│   ├── appointment_model.dart
│   └── doctor_model.dart
├── providers/
│   └── appointment_provider.dart
├── screens/
│   ├── wizard_screen.dart
│   ├── success_screen.dart
│   └── steps/
│       ├── step1_personal.dart
│       ├── step2_insurance.dart
│       ├── step3_department.dart
│       ├── step4_datetime.dart
│       ├── step5_services.dart
│       └── step6_summary.dart
├── widgets/
│   ├── step_header.dart
│   ├── navigation_buttons.dart
│   ├── doctor_card.dart
│   ├── section_card.dart
│   └── slot_grid.dart
├── services/
│   ├── draft_service.dart
│   └── tc_validation_service.dart
├── utils/
│   ├── validators.dart
│   ├── formatters.dart
│   └── constants.dart
└── data/
    └── mock_data.dart
```

---

## Kurulum ve Çalıştırma

```bash
flutter pub get
flutter run
flutter analyze   # No issues found
flutter test
```

---

## Widget Key Referansları (Test Sistemi)

### Adım 1 — Kişisel Bilgiler
```
input_ad  input_soyad  input_tc  input_email
input_telefon  input_dogum  input_adres
radio_erkek  radio_kadin
```

### Adım 2 — Sigorta & Sağlık
```
dropdown_sigorta  input_sigorta_firma
switch_alerji  input_alerji_aciklama
```

### Adım 3 — Bölüm & Doktor
```
dropdown_sehir  dropdown_hastane  dropdown_bolum  dropdown_doktor
doktor_item_0  doktor_item_1  doktor_item_2 ...
```

### Adım 4 — Tarih & Saat
```
btn_tarih_sec
slot_09:00  slot_09:30 ... slot_16:30
switch_acil  input_notlar
```

### Adım 5 — Ek Hizmetler
```
chip_kan_tahlili  chip_mr  chip_rontgen
stepper_refakatci_plus  stepper_refakatci_minus
checkbox_kvkk  checkbox_acik_riza
```

### Navigasyon (tüm adımlar)
```
btn_geri  btn_ileri  btn_onayla (sadece adım 6)
```

---

## TC Kimlik Doğrulama

```
Geçerli  : 10000000146
Geçersiz : 12345678901

Algoritma:
  tekToplam  = d[0]+d[2]+d[4]+d[6]+d[8]
  ciftToplam = d[1]+d[3]+d[5]+d[7]
  (tekToplam*7 - ciftToplam) % 10 == d[9]   ← 10. basamak
  ilk10Toplam % 10 == d[10]                  ← 11. basamak
```

---

## Kullanılan Paketler

| Paket | Kullanım |
|---|---|
| provider ^6.1.2 | Global state |
| shared_preferences ^2.3.2 | Draft kayıt |
| uuid ^4.4.2 | Randevu ID |
| intl ^0.20.2 | Tarih/para biçimlendirme |
| flutter_localizations (SDK) | Türkçe DatePicker |

---

## Kullanılan Yapay Zeka

**Claude Sonnet 4.6** (Anthropic) — tüm mimari tasarım, kod üretimi ve hata giderme.

### 5 Örnek Prompt

1. *"Flutter'da Provider tabanlı 6 adımlı wizard mimarisi tasarla. IndexedStack ile adımlar arası veri kaybolmasın, SharedPreferences ile taslak kaydedilsin."*

2. *"TC Kimlik No için algoritma tabanlı Dart validator yaz. 10000000146 geçerli, 12345678901 geçersiz. Mock async kontrol servisi de ekle."*

3. *"Şehir→Hastane→Bölüm→Doktor cascading DropdownButton oluştur. Üst seçim değişince alt seçimler sıfırlansın. Hata mesajları provider'da yönetilsin."*

4. *"30 dakikalık randevu slot picker yaz. InkWell key ValueKey('slot_HH:mm') olsun. Dolu slotlar disabled, hafta sonu ve tatil günleri seçilemesin."*

5. *"Test pipeline için widget key'leri eksiksiz uygula: Radio(key: ValueKey('radio_erkek')), Switch(key: ValueKey('switch_alerji')), FilterChip(key: ValueKey('chip_mr')). Key isimlerini değiştirme."*

---

## Lisans

Eğitim amaçlı geliştirilmiştir — BMU1422 dersi ödevi.
