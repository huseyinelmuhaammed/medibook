# MediBook — Akıllı Hastane Randevu Sistemi

Ad Soyad: HÜSEYİN ELMUHAMMED  
Öğrenci No: 22080410209  
Ders/Lab: BMU1422

> **Paket Adı:** `com.bmu1422.medibook`  
> **Versiyon:** 1.0.0+1  
> **Flutter SDK:** ≥3.11.1

---

## Proje Açıklaması

MediBook, Flutter ile geliştirilmiş 6 adımlı wizard tabanlı bir hastane randevu alma uygulamasıdır.

### Temel Özellikler

| Özellik | Detay |
|---|---|
| 6 Adımlı Wizard | Kişisel → Sigorta → Doktor → Tarih → Hizmetler → Özet |
| State Yönetimi | Provider (global, adımlar arası kalıcı) |
| Draft Kayıt | SharedPreferences ile taslak otomatik kaydedilir |
| TC Doğrulama | Algoritma + mock async kontrol |
| Cascading Dropdown | Şehir → Hastane → Bölüm → Doktor |
| Slot Picker | 30 dk'lık slotlar (09:00–16:30), dolu/boş gösterimi |
| Form Validasyon | Tüm alanlarda, koşullu validasyon dahil |
| Material 3 | Modern, premium sağlık teması |

---

## Kurulum ve Çalıştırma

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

---

## Widget Key Referansları

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

### Navigasyon
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
