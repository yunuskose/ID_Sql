SELECT USERNAME as [Kullanıcı Adı],
       FIRMNO   as [Firma No],
       BRANCH as [Çalışma Dönemi],
       DEPARTMENT as [Departman],
       DATE_ as Tarih,
       HOUR_ as Saat,
       MINUTE_  as Dakika,
       SECOND_  as Saniye,
       ( CASE PROCS11
           WHEN 1 THEN 'Ticari Sistem Yönetimi'
           WHEN 2 THEN 'Malzeme Yönetimi'
           WHEN 3 THEN 'Satınalma'
           WHEN 4 THEN 'Satış Dağıtım'
           WHEN 5 THEN 'Finans'
           WHEN 6 THEN 'Genel Muhasebe'
           WHEN 7 THEN 'Sistem Yönetimi'
           WHEN 22 THEN 'İş Akış Yönetimi'
           WHEN 26 THEN 'Kaynak Yönetimi'
           WHEN 27 THEN 'Üretim Tanımları'
           WHEN 28 THEN 'Üretim Kontrol'
           WHEN 33 THEN 'Kalite Kontrol'
           WHEN 34 THEN 'Maliyet Muhasebesi'
           WHEN 35 THEN 'Planlama'
           WHEN 36 THEN 'Dosya'
           WHEN 37 THEN 'Talep Yönetimi'
           WHEN 40 THEN 'İthalat'
           WHEN 41 THEN 'İhracat'
         END )  MODUL,
       ( CASE PROCS11
           WHEN 1 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Çalışma Dönemi Seçimi'
                           WHEN 2 THEN 'Onaylama'
                           WHEN 3 THEN 'Fiş Numaralama'
                           WHEN 4 THEN 'Çalışma Parametreleri'
                           WHEN 5 THEN 'Özel Kod Tanımları'
                           WHEN 6 THEN 'Yetki Kodu Tanımları'
                           WHEN 7 THEN 'Bilgi Aktarımı (Dışarı)'
                           WHEN 8 THEN 'Bilgi Aktarımı (İçeri)'
                           WHEN 9 THEN 'Bakım İşlemleri'
                           WHEN 10 THEN 'Döviz Türleri'
                           WHEN 11 THEN 'Yeniden Değerleme Oranları'
                           WHEN 12 THEN 'Mustahsil Parametleri'
                           WHEN 13 THEN 'Onay Rotası'
                           WHEN 14 THEN 'Onay Rotası Atama'
                           WHEN 15 THEN 'Ortalama Döviz Kurları'
                           WHEN 16 THEN 'Ticari Sistem Parametreleri'
                           WHEN 17 THEN 'Maliyet Periyotları'
                         END )
           WHEN 2 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Malzeme Fişleri'
                           WHEN 2 THEN 'Kur Güncelleştirme'
                           WHEN 3 THEN 'Dönem İşlemleri'
                           WHEN 4 THEN 'Malzemeler'
                           WHEN 5 THEN 'Alternatif Gruplar'
                           WHEN 6 THEN 'Teslimat Kodları'
                           WHEN 7 THEN 'Tanımlı Malzeme Fişleri'
                           WHEN 8 THEN 'Malzeme KDV Ayarlamaları'
                           WHEN 9 THEN 'Maliyetlendirme'
                           WHEN 10 THEN 'Malzeme Grup Kodları'
                           WHEN 11 THEN 'Malzeme Sınıfları'
                           WHEN 12 THEN 'Birim Setleri'
                           WHEN 13 THEN 'Stok Yeri Kodları'
                           WHEN 14 THEN 'Malzeme Özellikleri'
                           WHEN 15 THEN 'Dağıtım Şablonları'
                           WHEN 16 THEN 'Ek Malzemeler'
                           WHEN 17 THEN 'İşlemler'
           WHEN 18 THEN 'Malzeme Hareketleri Standart Maliyet Güncelleme'
           WHEN 19 THEN 'Envanter Değerleme'
           WHEN 20 THEN 'EK Vergiler'
           WHEN 21 THEN 'Marka Tanımları'
           WHEN 22 THEN 'Malzeme Varyantları'
           WHEN 23 THEN 'Giriş Çıkış Hareket İlişkilendirme'
           WHEN 151 THEN 'Maliyet Dağıtım Fişleri'
           WHEN 152 THEN 'Malzeme Özellik Setleri'
                         END )
           WHEN 3 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Alım İrsaliyeleri'
                           WHEN 2 THEN 'Kur Güncelleştirme'
                           WHEN 3 THEN 'Satınalma Siparişleri'
                           WHEN 4 THEN 'Alım Faturaları'
                           WHEN 5 THEN 'Malzeme Alış Fiyat Ayarlamaları'
                           WHEN 6 THEN 'Hizmet Alış Fiyat Ayarlamaları'
                           WHEN 7 THEN 'Tanımlı Alım İrsaliyeleri'
                           WHEN 8 THEN 'Alınan Hizmetler'
                           WHEN 9 THEN 'Alış İndirimleri'
                           WHEN 10 THEN 'Alış Masrafları'
                           WHEN 11 THEN 'Alış Promosyonları'
                           WHEN 12 THEN 'Malzeme Alış Fiyatları'
                           WHEN 13 THEN 'Hizmet Alış Fiyatları'
                           WHEN 14 THEN 'Alış Koşulları Fiş Satırları'
                           WHEN 15 THEN 'Alış Koşulları Fiş Geneli'
                           WHEN 16 THEN 'Mustahsil Parametreleri'
                           WHEN 17 THEN 'Hizmet Alış KDV Ayarlamaları'
                           WHEN 18 THEN 'Alış Kampanyaları'
                           WHEN 19 THEN 'İşlemler'
                           WHEN 20 THEN 'Emir Fişi'
                           WHEN 21 THEN 'Teklif Fişi'
                           WHEN 22 THEN 'Sözleşme'
                         END )
           WHEN 4 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Satış İrsaliyeleri'
                           WHEN 2 THEN 'Kur Güncelleştirme'
                           WHEN 3 THEN 'Satış Siparişleri'
                           WHEN 4 THEN 'ALIM Faturaları'
                           WHEN 5 THEN 'Malzeme Satış Fiyat Ayarlamaları'
                           WHEN 6 THEN 'Hizmet Satış Fiyat Ayarlamaları'
                           WHEN 7 THEN 'Tanımlı Satış İrsaliyeleri'
                           WHEN 8 THEN 'Verilen Hizmetler'
                           WHEN 9 THEN 'Satış İndirimleri'
                           WHEN 10 THEN 'Satış Masrafları'
                           WHEN 11 THEN 'Satış Promosyonları'
                           WHEN 12 THEN 'Malzeme Satış Fiyatları'
                           WHEN 13 THEN 'Hizmet Satış Fiyatları'
                           WHEN 14 THEN 'Satış Koşulları Fiş Satırları'
                           WHEN 15 THEN 'Satış Koşulları Fiş Geneli'
                           WHEN 16 THEN 'Satış Kampanyaları'
                           WHEN 17 THEN 'Hizmet Satış KDV Ayarlamaları'
                           WHEN 18 THEN 'Pozisyon Kodları'
                           WHEN 19 THEN 'Satış Elemanları'
                           WHEN 20 THEN 'Satış Rotası'
                           WHEN 21 THEN 'Satış Hedefi'
                           WHEN 22 THEN 'Sektörler'
                           WHEN 23 THEN 'Müşteriler'
                           WHEN 24 THEN 'Dağıtım Rotaları'
                           WHEN 25 THEN 'Dağıtım Araçları'
                           WHEN 26 THEN 'Dağıtım Emirleri'
                           WHEN 27 THEN 'İşlemler'
                           WHEN 28 THEN 'Satış Fırsatları'
                           WHEN 29 THEN 'Satış Faaliyetleri'
                           WHEN 30 THEN 'Teklif Fişi'
                           WHEN 31 THEN 'Sözleşme'
                           WHEN 32 THEN 'İlgili Kişiler'
                           WHEN 89 THEN 'CH Sevkiyat Adresleri'
                         END )
           WHEN 5 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Cari Hesap İşlemleri'
                           WHEN 2 THEN 'Çek Senet Bordroları'
                           WHEN 3 THEN 'Banka İşlemleri'
                           WHEN 4 THEN 'Kasa İşlemleri'
                           WHEN 5 THEN 'Kur Güncelleştirme'
                           WHEN 6 THEN 'Kur Farkı Hesaplama'
                           WHEN 7 THEN 'Günlük Kur Girişi'
                           WHEN 8 THEN 'Cari Hesaplar'
                           WHEN 9 THEN 'Ödeme Tahsilat Planları'
                           WHEN 10 THEN 'Çekler Senetler'
                           WHEN 11 THEN 'Bankalar'
                           WHEN 12 THEN 'Banka Hesapları'
                           WHEN 13 THEN 'Kasalar'
                           WHEN 14 THEN 'Borç Takip'
                           WHEN 15 THEN 'Cari Hesap Fişleri'
                           WHEN 16 THEN 'Banka Fişleri'
                           WHEN 17 THEN 'Cari Hesap Risk Ayarlamaları'
                           WHEN 18 THEN 'Günlük Kur Girişi'
                           WHEN 19 THEN 'Sevkiyat Adresleri'
                           WHEN 20 THEN 'Ödeme Tahsilat Plan Grupları'
                           WHEN 21 THEN 'İstihbarat Bilgileri'
                           WHEN 22 THEN 'Cari Hesap Hareketleri'
                           WHEN 23 THEN 'Banka Hareketleri'
                           WHEN 24 THEN 'İşlemler'
                         END )
           WHEN 6 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Muhasebe Fişleri'
                           WHEN 2 THEN 'Yevmiye Madde Numaralama'
                           WHEN 3 THEN 'Kur Güncelleştirme'
                           WHEN 4 THEN 'Kur Farkı Hesaplama'
                           WHEN 5 THEN 'Muhasebeleştirme'
                           WHEN 6 THEN 'Muhasebe Hesapları'
                           WHEN 7 THEN 'Masraf Merkezleri'
                           WHEN 8 THEN 'Muhasebe Bağlantı Kodları'
           WHEN 10 THEN 'İş İstasyonları Standart Maliyet Güncelleme'
           WHEN 11 THEN 'İş İstasyonu Grupları Standart Maliyet Güncelleme'
           WHEN 12 THEN 'Çalışanlar Standart Maliyet Güncelleme'
           WHEN 13 THEN 'Çalışan Grupları Standart Maliyet Güncelleme'
           WHEN 14 THEN 'İşlemler'
           WHEN 15 THEN 'Projeler'
           WHEN 16 THEN 'Enflasyon Parametreleri Güncelleme'
           WHEN 17 THEN 'Malzeme Ortalama Stokta Kalma Süresi Güncelleme'
           WHEN 18 THEN 'Tahsis Fişleri'
           WHEN 19 THEN 'Bütçe Revizyon Fişleri'
                         END )
           WHEN 7 THEN ( CASE PROCS12
                           WHEN 1 THEN 'Döviz Dosyaları'
                           WHEN 2 THEN 'Firma Veri Dosyaları'
                           WHEN 3 THEN 'Dönem Dosyaları'
                           WHEN 4 THEN 'Form Master Tanımları'
                         END )
           WHEN 26 THEN ( CASE PROCS12
                            WHEN 1 THEN 'İş İstasyonu Özellikleri'
                            WHEN 2 THEN 'İş İstasyonları'
                            WHEN 3 THEN 'İş İstasyonu Grupları'
                            WHEN 4 THEN 'Çalışanlar'
                            WHEN 5 THEN 'Çalışan Grupları'
                            WHEN 6 THEN 'Standart Maliyet Güncelleme'
                            WHEN 7 THEN 'Standart Kaynak Maliyetleri'
                            WHEN 8 THEN 'Vardiyalar'
                            WHEN 9 THEN 'Çalışan Maliyeti'
                            WHEN 10 THEN 'İş İstasyonu Maliyeti'
                            WHEN 11 THEN 'Otomatik İş İstasyonu Üretme'
                            WHEN 12 THEN 'Otomatik Çalışan Üretme'
                            WHEN 13 THEN 'İşlemler'
                            WHEN 14 THEN 'İş İstasyonu İstisnai Durum Ataması'
                            WHEN 15 THEN 'Çalışan İstisnai Durum Ataması'
                            WHEN 16 THEN 'İş İstasyonu  Vardiya Ataması'
                            WHEN 17 THEN 'Çalışan Vardiya Atamaları'
                          END )
           WHEN 27 THEN ( CASE PROCS12
                            WHEN 1 THEN 'Operasyon Tanımları'
                            WHEN 2 THEN 'ROTA Tanımları'
                            WHEN 3 THEN 'Ürün Reçeteleri'
                            WHEN 4 THEN 'Operasyon Kalite Kontrol Kriterleri'
                            WHEN 5 THEN 'Toplu Reçete Güncelleme'
                            WHEN 6 THEN 'Üretim Reçete Revizyon Güncelleme'
                            WHEN 7 THEN 'Mühendislik Değişikliği İşlemleri'
           WHEN 8 THEN 'Toplu Standart Reçete Maliyet Güncelleme'
           WHEN 9 THEN 'Ürün Hatları'
           WHEN 10 THEN 'Üretim Sabitleri'
                          END )
           WHEN 28 THEN ( CASE PROCS12
                            WHEN 1 THEN 'Üretim Emirleri'
                            WHEN 2 THEN 'İş Emirleri'
                            WHEN 3 THEN 'Durma Nedenleri'
                            WHEN 4 THEN 'İşlemler'
                          END )
           WHEN 35 THEN ( CASE PROCS12
                            WHEN 1 THEN 'Üretim Planlama'
                            WHEN 2 THEN 'Kapasite Planlama'
                            WHEN 3 THEN 'Kaynak Çizelgeleme'
                          END )
         END )  ISLEM_TURU,
       ( CASE PROCS13
           WHEN 1 THEN 'Ekle'
           WHEN 2 THEN 'Ekle'
           WHEN 3 THEN 'Değiştir'
           WHEN 4 THEN 'Çıkar'
           WHEN 5 THEN 'Kopyala'
           WHEN 6 THEN 'İncele'
           WHEN 7 THEN 'Muhasebe Kodları'
           WHEN 12 THEN 'Satınalma İşlemleri'
           WHEN 21 THEN 'Muhasebeleştirme Raporu'
           WHEN 18 THEN 'Ambar Bilgileri'
         END )  ISLEM,
       ( CASE PROCS25
           WHEN 10 THEN 'Eklendi'
           WHEN 9 THEN 'İncelendi'
           WHEN 7 THEN 'Değiştirildi'
           WHEN 11 THEN 'Çıkarıldı'
           WHEN 8 THEN 'Vazgeçildi'
           WHEN 25 THEN 'Oluşturuldu'
           WHEN 16 THEN 'Kopyalandı'
           WHEN 17 THEN 'İptal Edildi'
           WHEN 18 THEN 'Geri Alındı'
           WHEN 19 THEN 'Faturalandı'
           WHEN 22 THEN 'Kapatıldı'
           WHEN 23 THEN 'Geri Alındı'
         END )  SONUC,
       MSGS1,
       MSGS2
FROM   LG_000_SYSLOG SYSLG
WHERE FIRMNO=182
ORDER BY SYSLG.DATE_ DESC,SYSLG.HOUR_ DESC,SYSLG.MINUTE_ DESC,SYSLG.SECOND_ DESC
