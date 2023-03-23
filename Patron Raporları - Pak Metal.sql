
/****** Object:  View [dbo].[IDW_MR_Tahsilatlar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_MR_Tahsilatlar]
as
select
ANTPAK2023.dbo.TRK(KS.KSMAS_NAME) as Tip,
TBLKASA.KSMAS_KOD as Kod,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
TARIH as Tarih,
CASE MONTH(TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
FISNO as BelgeNo,
ANTPAK2023.dbo.TRK(ACIKLAMA) as Aciklama,
'TL' as DovizBirimi,
TUTAR as Tutar,
TBLKASA.SUBE_KODU as SubeKodu,
ISNULL(CASE WHEN C.PLASIYER_KODU='' THEN 'TANIMSIZ' ELSE C.PLASIYER_KODU END,'TANIMSIZ') as PlasiyerKodu
from ANTPAK2023.dbo.TBLKASA WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = TBLKASA.KOD
LEFT OUTER JOIN ANTPAK2023.dbo.TBLKASAMAS KS WITH(NOLOCK) ON KS.KSMAS_KOD = TBLKASA.KSMAS_KOD

Where TARIH >= '2023-01-01'
and IO = 'G' and C.CARI_KOD IS NOT NULL

union all

select
'Müşteri Çeki' as Tip,
SC_VERENK as Kod,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
SC_GIRTRH as Tarih,
CASE MONTH(SC_GIRTRH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
SC_NO as BelgeNo,
SC_ABORCLU as Aciklama,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
TUTAR as Tutar,
TBLMCEK.SUBE_KODU as SubeKodu,
ISNULL(CASE WHEN C.PLASIYER_KODU='' THEN 'TANIMSIZ' ELSE C.PLASIYER_KODU END,'TANIMSIZ') as PlasiyerKodu
From ANTPAK2023.dbo.TBLMCEK WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = TBLMCEK.SC_VERENK
LEFT OUTER JOIN NETSIS.dbo.KUR  WITH(NOLOCK) ON KUR.SIRA = TBLMCEK.DOVTIP
Where 1=1 and SC_GIRTRH <= CAST(GETDATE() as DATE)

union all

select 
'Banka' as Tip,
ANTPAK2023.dbo.TRK(TBLBNKHESTRA.ACIKLAMA) as Kod,
(select top(1) TBLCAHAR.CARI_KOD from ANTPAK2023.dbo.TBLCAHAR WHERE ENT_REF_KEY = ENTEGREFKEY) as CariKodu,
(Select ANTPAK2023.dbo.TRK(C1.CARI_ISIM) From ANTPAK2023.dbo.TBLCASABIT C1 WITH(NOLOCK) Where  C1.CARI_KOD = (select top(1) TBLCAHAR.CARI_KOD from ANTPAK2023.dbo.TBLCAHAR WHERE ENT_REF_KEY = ENTEGREFKEY)) as CariAdi,
--C.CARI_KOD as CariKodu,
--ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
TARIH as Tarih,
CASE MONTH(TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
TBLBNKHESTRA.BELGENO as BelgeNo,
ANTPAK2023.dbo.TRK(TBLBNKHESTRA.ACIKLAMA) as Aciklama,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN TUTAR ELSE TBLBNKHESTRA.DOVIZTUTAR END as Tutar,
TBLBNKHESTRA.SUBE_KODU as SubeKodu,
'' as PlasiyerKodu
from ANTPAK2023.dbo.TBLBNKHESTRA WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLBNKHESSABIT WITH(NOLOCK) ON TBLBNKHESSABIT.BANKAHESNO =TBLBNKHESTRA.NETHESKODU
LEFT OUTER JOIN NETSIS.dbo.KUR  WITH(NOLOCK) ON KUR.SIRA = TBLBNKHESTRA.DOVIZTIPI
Where HARTURU = 2 and BA = 'B'
GO
/****** Object:  View [dbo].[IDW_MR_Siparisler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IDW_MR_Siparisler]
as

select 
(
CASE 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (1, 2) THEN 'SATIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5) THEN 'SATIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (6) THEN 'IHRACAT' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (1, 2) THEN 'ALIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5) THEN 'ALIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = 'A' THEN 'FATURALASTIR IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '3' THEN 'SATIS IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '4' THEN 'ALIS IRSALIYE' 
ELSE 'HATA' END
)  
 AS [Fiş Tipi],
F.SUBE_KODU as SubeKodu,
F.TARIH as Tarih,
SH.FISNO as BelgeNo,
YEAR(F.TARIH) as Yil,
MONTH(F.TARIH) as Ay,
CASE MONTH(F.TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
DAY(F.TARIH) as Gun,
ANTPAK2023.dbo.TRK(C.CARI_KOD) as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) as CariGrupKodu,
ANTPAK2023.dbo.TRK(FE.ACIK4) as Aciklama4,
C.PLASIYER_KODU as CariPlasiyer,
C.KOSULKODU as CariKosulKodu,
C.FIYATGRUBU as CariFiyatGrubu,
SH.PLASIYER_KODU as FaturaPlasiyer,
S.STOK_KODU as StokKodu,
ANTPAK2023.dbo.TRK(S.STOK_ADI) as StokAdi,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) StokGrupKodu,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) GRUP_KODU,
ANTPAK2023.dbo.TRK(S.KOD_1) KOD_1,
ANTPAK2023.dbo.TRK(S.KOD_2) KOD_2,
ANTPAK2023.dbo.TRK(S.KOD_3) KOD_3,
ANTPAK2023.dbo.TRK(S.KOD_4) KOD_4,
ANTPAK2023.dbo.TRK(S.KOD_5) KOD_5,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) MusteriTipi,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CAST(SH.STHAR_GCMIK * CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Miktar,
S.OLCU_BR1 as Birim,
CAST(SH.STHAR_NF as decimal(18,2)) as BirimFiyat,
CAST((SH.STHAR_GCMIK*CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN SH.STHAR_NF ELSE SH.STHAR_DOVFIAT END)* CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Tutar
from ANTPAK2023.dbo.TBLSIPATRA SH WITH(NOLOCK) 
INNER JOIN ANTPAK2023.dbo.TBLSIPAMAS  F WITH(NOLOCK) ON F.FATIRS_NO = SH.FISNO
INNER JOIN ANTPAK2023.dbo.TBLFATUEK  FE WITH(NOLOCK) ON FE.FATIRSNO = SH.FISNO
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = F.CARI_KODU
LEFT OUTER JOIN ANTPAK2023.dbo.TBLSTSABIT S WITH(NOLOCK) ON S.STOK_KODU = SH.STOK_KODU
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.NETSISSIRA = STHAR_DOVTIP
Where 1=1
--and ((F.FTIRSIP = '1' and F.TIPI IN (1,2)) or (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5))) 
--and YEAR(F.TARIH)  = YEAR(GETDATE())-1
--and STHAR_GCMIK - FIRMA_DOVTUT > 0
GO
/****** Object:  View [dbo].[IDW_MR_SevkIrsaliyeleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IDW_MR_SevkIrsaliyeleri]
as
select 
(
CASE 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (1, 2) THEN 'SATIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5) THEN 'SATIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (6) THEN 'IHRACAT' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (1, 2) THEN 'ALIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5) THEN 'ALIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = 'A' THEN 'FATURALASTIR IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '3' THEN 'SATIS IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '4' THEN 'ALIS IRSALIYE' 
ELSE 'HATA' END
)  
 AS [Fiş Tipi],
F.SUBE_KODU as SubeKodu,
F.TARIH as Tarih,
SH.FISNO as BelgeNo,
YEAR(F.TARIH) as Yil,
MONTH(F.TARIH) as Ay,
CASE MONTH(F.TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
DAY(F.TARIH) as Gun,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
C.PLASIYER_KODU as CariPlasiyer,
C.KOSULKODU as CariKosulKodu,
C.FIYATGRUBU as CariFiyatGrubu,
ISNULL(C.GRUP_KODU,'TANIMSIZ') as CariGrupKodu,
ISNULL(C.RAPOR_KODU1,'TANIMSIZ') as CariKod1,
ISNULL(C.RAPOR_KODU2,'TANIMSIZ') as CariKod2,
ISNULL(C.RAPOR_KODU3,'TANIMSIZ') as CariKod3,
ISNULL(C.RAPOR_KODU4,'TANIMSIZ') as CariKod4,
ISNULL(C.RAPOR_KODU5,'TANIMSIZ') as CariKod5,
SH.PLASIYER_KODU as FaturaPlasiyer,
S.STOK_KODU as StokKodu,
ANTPAK2023.dbo.TRK(S.STOK_ADI) as StokAdi,
ISNULL(ANTPAK2023.dbo.TRK(S.GRUP_KODU),'TANIMSIZ') StokGrupKodu,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_1),'TANIMSIZ') StokKod1,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_2),'TANIMSIZ') StokKod2,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_3),'TANIMSIZ') StokKod3,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_4),'TANIMSIZ') StokKod4,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_5),'TANIMSIZ') StokKod5,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) MusteriTipi,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CAST(SH.STHAR_GCMIK * CASE WHEN (SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Miktar,
S.OLCU_BR1 as Birim,
CAST(SH.STHAR_NF as decimal(18,2)) as BirimFiyat,
CAST((SH.STHAR_GCMIK*SH.STHAR_NF)* CASE WHEN (SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Tutar
from ANTPAK2023.dbo.TBLSTHAR SH WITH(NOLOCK) 
INNER JOIN ANTPAK2023.dbo.TBLFATUIRS  F WITH(NOLOCK) ON F.FATIRS_NO = SH.FISNO
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = F.CARI_KODU
LEFT OUTER JOIN ANTPAK2023.dbo.TBLSTSABIT S WITH(NOLOCK) ON S.STOK_KODU = SH.STOK_KODU
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.NETSISSIRA = STHAR_DOVTIP
Where 1=1
and ((F.FTIRSIP = '2' and F.TIPI IN (1,2)) or (SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5))) 
and YEAR(F.TARIH)  = YEAR(GETDATE())
--and S.GRUP_KODU NOT IN ('GRUP_KODU','GGIDER','PROMASYN','HIZMET','DEPOZITO')
--and ISNULL(KOD_1,'') <> ''
--and PLA_KODU <> 'G'
GO
/****** Object:  View [dbo].[IDW_MR_Satislar2022]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IDW_MR_Satislar2022]
as
select 
(
CASE 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (1, 2) THEN 'SATIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5) THEN 'SATIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (6) THEN 'IHRACAT' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (1, 2) THEN 'ALIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5) THEN 'ALIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = 'A' THEN 'FATURALASTIR IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '3' THEN 'SATIS IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '4' THEN 'ALIS IRSALIYE' 
ELSE 'HATA' END
)  
 AS [Fiş Tipi],
F.SUBE_KODU as SubeKodu,
F.TARIH as Tarih,
DATEADD(DAY,F.ODEMEGUNU,F.TARIH) as VadeTarihi,
SH.FISNO as BelgeNo,
YEAR(F.TARIH) as Yil,
MONTH(F.TARIH) as Ay,
CASE MONTH(F.TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
DAY(F.TARIH) as Gun,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) as CariGrupKodu,
C.PLASIYER_KODU as CariPlasiyer,
C.KOSULKODU as CariKosulKodu,
C.FIYATGRUBU as CariFiyatGrubu,
SH.PLASIYER_KODU as FaturaPlasiyer,
S.STOK_KODU as StokKodu,
ANTPAK2023.dbo.TRK(S.STOK_ADI) as StokAdi,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) StokGrupKodu,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) GRUP_KODU,
ANTPAK2023.dbo.TRK(S.KOD_1) KOD_1,
ANTPAK2023.dbo.TRK(S.KOD_2) KOD_2,
ANTPAK2023.dbo.TRK(S.KOD_3) KOD_3,
ANTPAK2023.dbo.TRK(S.KOD_4) KOD_4,
ANTPAK2023.dbo.TRK(S.KOD_5) KOD_5,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) MusteriTipi,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CAST(SH.STHAR_GCMIK * CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Miktar,
S.OLCU_BR1 as Birim,
CAST(CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN SH.STHAR_NF ELSE SH.STHAR_DOVFIAT END * (1+(SH.STHAR_KDV)/100) as decimal(18,2)) as BirimFiyat,
CAST(((SH.STHAR_GCMIK*CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN SH.STHAR_NF ELSE SH.STHAR_DOVFIAT END)* CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END) * (1+(SH.STHAR_KDV)/100) as decimal(18,2)) as Tutar,
CAST(((SH.STHAR_GCMIK* SH.STHAR_NF )* CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END) * (1+(SH.STHAR_KDV)/100) as decimal(18,2)) as TutarTL
from ANTPAK2022.dbo.TBLSTHAR SH WITH(NOLOCK) 
INNER JOIN ANTPAK2022.dbo.TBLFATUIRS  F WITH(NOLOCK) ON F.FATIRS_NO = SH.FISNO
LEFT OUTER JOIN ANTPAK2022.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = F.CARI_KODU
LEFT OUTER JOIN ANTPAK2022.dbo.TBLSTSABIT S WITH(NOLOCK) ON S.STOK_KODU = SH.STOK_KODU
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.NETSISSIRA = STHAR_DOVTIP
Where 1=1
and ((F.FTIRSIP = '1' and F.TIPI IN (1,2)) or (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5))) 
and YEAR(F.TARIH)  = 2023
--and S.GRUP_KODU NOT IN ('GRUP_KODU','GGIDER','PROMASYN','HIZMET','DEPOZITO')
--and ISNULL(KOD_1,'') <> ''
--and PLA_KODU <> 'G'
GO
/****** Object:  View [dbo].[IDW_MR_Satislar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IDW_MR_Satislar]
as
select 
(
CASE 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (1, 2) THEN 'SATIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5) THEN 'SATIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (6) THEN 'IHRACAT' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (1, 2) THEN 'ALIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5) THEN 'ALIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = 'A' THEN 'FATURALASTIR IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '3' THEN 'SATIS IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '4' THEN 'ALIS IRSALIYE' 
ELSE 'HATA' END
)  
 AS [Fiş Tipi],
F.SUBE_KODU as SubeKodu,
F.TARIH as Tarih,
DATEADD(DAY,F.ODEMEGUNU,F.TARIH) as VadeTarihi,
SH.FISNO as BelgeNo,
YEAR(F.TARIH) as Yil,
MONTH(F.TARIH) as Ay,
CASE MONTH(F.TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
DAY(F.TARIH) as Gun,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) as CariGrupKodu,
C.PLASIYER_KODU as CariPlasiyer,
C.KOSULKODU as CariKosulKodu,
C.FIYATGRUBU as CariFiyatGrubu,
SH.PLASIYER_KODU as FaturaPlasiyer,
S.STOK_KODU as StokKodu,
ANTPAK2023.dbo.TRK(S.STOK_ADI) as StokAdi,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) StokGrupKodu,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) GRUP_KODU,
ANTPAK2023.dbo.TRK(S.KOD_1) KOD_1,
ANTPAK2023.dbo.TRK(S.KOD_2) KOD_2,
ANTPAK2023.dbo.TRK(S.KOD_3) KOD_3,
ANTPAK2023.dbo.TRK(S.KOD_4) KOD_4,
ANTPAK2023.dbo.TRK(S.KOD_5) KOD_5,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) MusteriTipi,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CAST(SH.STHAR_GCMIK * CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Miktar,
S.OLCU_BR1 as Birim,
CAST(CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN SH.STHAR_NF ELSE SH.STHAR_DOVFIAT END * (1+(SH.STHAR_KDV)/100) as decimal(18,2)) as BirimFiyat,
CAST(((SH.STHAR_GCMIK*CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN SH.STHAR_NF ELSE SH.STHAR_DOVFIAT END)* CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END) * (1+(SH.STHAR_KDV)/100) as decimal(18,2)) as Tutar,
CAST(((SH.STHAR_GCMIK* SH.STHAR_NF )* CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END) * (1+(SH.STHAR_KDV)/100) as decimal(18,2)) as TutarTL
from ANTPAK2023.dbo.TBLSTHAR SH WITH(NOLOCK) 
INNER JOIN ANTPAK2023.dbo.TBLFATUIRS  F WITH(NOLOCK) ON F.FATIRS_NO = SH.FISNO
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = F.CARI_KODU
LEFT OUTER JOIN ANTPAK2023.dbo.TBLSTSABIT S WITH(NOLOCK) ON S.STOK_KODU = SH.STOK_KODU
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.NETSISSIRA = STHAR_DOVTIP
Where 1=1
and ((F.FTIRSIP = '1' and F.TIPI IN (1,2)) or (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5))) 
and YEAR(F.TARIH)  = YEAR(GETDATE())
--and S.GRUP_KODU NOT IN ('GRUP_KODU','GGIDER','PROMASYN','HIZMET','DEPOZITO')
--and ISNULL(KOD_1,'') <> ''
--and PLA_KODU <> 'G'
GO
/****** Object:  View [dbo].[IDW_MR_KasaHareketleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_MR_KasaHareketleri]
as

SELECT
T1.KSMAS_KOD as HesapKodu,
ANTPAK2023.dbo.TRK(K.KSMAS_NAME) as HesapAdi,
TARIH as Tarih,
ANTPAK2023.dbo.TRK(FISNO) AS BelgeNo,
ANTPAK2023.dbo.TRK(ACIKLAMA) AS Aciklama,
[IO] as GC,
TUTAR as Tutar,
(CASE WHEN K.DOVIZTIPI= 0 THEN 'TL' ELSE (SELECT ISIM FROM NETSIS..KUR WITH(NOLOCK)  WHERE SIRA=K.DOVIZTIPI) END)AS DovizBirimi,
(CASE WHEN DOVIZTUT <>0 THEN T1.TUTAR /T1.DOVIZTUT ELSE 0 END) AS Kur,
ANTPAK2023.dbo.TRK(T1.PLASIYER_KODU) as PlaKodu,
(SELECT top(1) ANTPAK2023.dbo.TRK(PLASIYER_ACIKLAMA) FROM ANTPAK2023.dbo.TBLCARIPLASIYER WITH(NOLOCK) WHERE PLASIYER_KODU=T1.PLASIYER_KODU) AS PlasiyerAdi,
(SELECT top(1) FISNO FROM ANTPAK2023.dbo.TBLMUHFIS WITH(NOLOCK)  WHERE ENTEGREFKEY=T1.ENTEGREFKEY)AS MuhFisNo
FROM ANTPAK2023.dbo.TBLKASA T1 WITH(NOLOCK) 
LEFT OUTER JOIN ANTPAK2023.dbo.TBLKASAMAS K WITH(NOLOCK) ON K.KSMAS_KOD = T1.KSMAS_KOD
Where YEAR(TARIH) = YEAR(GETDATE())
GO
/****** Object:  View [dbo].[IDW_MR_CekSenet]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_MR_CekSenet]
as
select
'Müşteri Çeki' as Tip,
SC_VERENK as Kod,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
SC_GIRTRH as Tarih,
VADETRH as VadeTarihi,
CASE 
WHEN SC_YERI = 'P' and SC_SONDUR = 'B' THEN 'Pörtföyde'
WHEN SC_YERI = 'T' and SC_SONDUR = 'B' THEN 'Bankada'
WHEN SC_YERI = 'C' THEN 'Ciro'
WHEN SC_YERI = 'O' THEN 'Ödenmiş'
WHEN SC_YERI = 'K' THEN 'Karşılıksız'
WHEN SC_YERI = 'I' THEN 'İade'
WHEN SC_YERI = 'B' THEN 'Bankada'

ELSE SC_YERI END as Durum,
SC_YERI+TBLMCEK.SC_SONDUR as SC_YERI,
CASE MONTH(SC_GIRTRH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
SC_NO as BelgeNo,
CEKSERI as SeriNo,
SC_ABORCLU as Aciklama,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
TUTAR as Tutar,
TBLMCEK.SUBE_KODU as SubeKodu,
(select ANTPAK2023.dbo.TRK(TBLCASABIT.CARI_ISIM) From ANTPAK2023.dbo.TBLCASABIT WITH(NOLOCK) Where TBLCASABIT.CARI_KOD = TBLMCEK.SC_VERILENK) CiroEdilen,
'' CiroEden,
ISNULL(CASE WHEN C.PLASIYER_KODU='' THEN 'TANIMSIZ' ELSE C.PLASIYER_KODU END,'TANIMSIZ') as PlasiyerKodu
From ANTPAK2023.dbo.TBLMCEK WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = TBLMCEK.SC_VERENK
LEFT OUTER JOIN NETSIS.dbo.KUR  WITH(NOLOCK) ON KUR.SIRA = TBLMCEK.DOVTIP
Where 1=1 and SC_YERI+TBLMCEK.SC_SONDUR IN ('PB','TB','CB') and VADETRH >= '2023-01-01'
union all
select
'Kendi Çekimiz' as Tip,
SC_VERENK as Kod,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
SC_GIRTRH as Tarih,
VADETRH as VadeTarihi,
CASE 
WHEN SC_YERI = 'P' THEN 'Pörtföyde'
WHEN SC_YERI = 'O' THEN 'Ödenmiş'
WHEN SC_YERI = 'K' THEN 'Karşılıksız'
WHEN SC_YERI = 'I' THEN 'İade'
WHEN SC_YERI = 'B' THEN 'Bankada'

ELSE SC_SONDUR END as Durum,
SC_YERI,
CASE MONTH(SC_GIRTRH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
SC_NO as BelgeNo,
CEKSERI as SeriNo,
SC_ABORCLU as Aciklama,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
TUTAR as Tutar,
TBLBCEK.SUBE_KODU as SubeKodu,
'' CiroEdilen,
'' CiroEden,
ISNULL(CASE WHEN C.PLASIYER_KODU='' THEN 'TANIMSIZ' ELSE C.PLASIYER_KODU END,'TANIMSIZ') as PlasiyerKodu
From ANTPAK2023.dbo.TBLBCEK WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = TBLBCEK.SC_VERENK
LEFT OUTER JOIN NETSIS.dbo.KUR  WITH(NOLOCK) ON KUR.SIRA = TBLBCEK.DOVTIP
Where 1=1
GO
/****** Object:  View [dbo].[IDW_MR_Bekleyenler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IDW_MR_Bekleyenler]
as

select 
(
CASE 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (1, 2) THEN 'SATIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5) THEN 'SATIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (6) THEN 'IHRACAT' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (1, 2) THEN 'ALIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5) THEN 'ALIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = 'A' THEN 'FATURALASTIR IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '3' THEN 'SATIS IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '4' THEN 'ALIS IRSALIYE' 
ELSE 'HATA' END
)  
 AS [Fiş Tipi],
F.SUBE_KODU as SubeKodu,
F.TARIH as Tarih,
SH.FISNO as BelgeNo,
YEAR(F.TARIH) as Yil,
MONTH(F.TARIH) as Ay,
CASE MONTH(F.TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
DAY(F.TARIH) as Gun,
ANTPAK2023.dbo.TRK(C.CARI_KOD) as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
ANTPAK2023.dbo.TRK(FE.ACIK4) as Aciklama4,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) as CariGrupKodu,
C.PLASIYER_KODU as CariPlasiyer,
C.KOSULKODU as CariKosulKodu,
C.FIYATGRUBU as CariFiyatGrubu,
SH.PLASIYER_KODU as FaturaPlasiyer,
S.STOK_KODU as StokKodu,
ANTPAK2023.dbo.TRK(S.STOK_ADI) as StokAdi,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) GRUP_KODU,
ANTPAK2023.dbo.TRK(S.GRUP_KODU) StokGrupKodu,
ANTPAK2023.dbo.TRK(S.KOD_1) KOD_1,
ANTPAK2023.dbo.TRK(S.KOD_2) KOD_2,
ANTPAK2023.dbo.TRK(S.KOD_3) KOD_3,
ANTPAK2023.dbo.TRK(S.KOD_4) KOD_4,
ANTPAK2023.dbo.TRK(S.KOD_5) KOD_5,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) MusteriTipi,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CAST(SH.STHAR_GCMIK * CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Miktar,
S.OLCU_BR1 as Birim,
CAST(SH.STHAR_NF as decimal(18,2)) as BirimFiyat,
CAST((SH.STHAR_GCMIK*CASE WHEN ISNULL(KUR.ISIM,'TL') = 'TL' THEN SH.STHAR_NF ELSE SH.STHAR_DOVFIAT END)* CASE WHEN (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Tutar
from ANTPAK2023.dbo.TBLSIPATRA SH WITH(NOLOCK) 
INNER JOIN ANTPAK2023.dbo.TBLSIPAMAS  F WITH(NOLOCK) ON F.FATIRS_NO = SH.FISNO
INNER JOIN ANTPAK2023.dbo.TBLFATUEK  FE WITH(NOLOCK) ON FE.FATIRSNO = SH.FISNO
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = F.CARI_KODU
LEFT OUTER JOIN ANTPAK2023.dbo.TBLSTSABIT S WITH(NOLOCK) ON S.STOK_KODU = SH.STOK_KODU
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.NETSISSIRA = STHAR_DOVTIP
Where 1=1
--and ((F.FTIRSIP = '1' and F.TIPI IN (1,2)) or (SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5))) 
--and YEAR(F.TARIH)  = YEAR(GETDATE())
and STHAR_GCMIK - FIRMA_DOVTUT > 0
GO
/****** Object:  View [dbo].[IDW_MR_BankaHareketleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_MR_BankaHareketleri]
as

SELECT
        (SELECT
                (SELECT ANTPAK2023.dbo.TRK(BANKAADI) FROM ANTPAK2023.dbo.TBLBNKSABIT WITH(NOLOCK)  WHERE NETBANKAKODU=T5.NETBANKAKODU)
                FROM ANTPAK2023.dbo.TBLBNKHESSABIT T5 WITH(NOLOCK)  WHERE NETHESKODU=T1.NETHESKODU)AS BankaAdi,
    (CASE (SELECT HESAPTIPI FROM ANTPAK2023.dbo.TBLBNKHESSABIT WITH(NOLOCK)  WHERE NETHESKODU=T1.NETHESKODU)
            WHEN 0 THEN '0-Vadesiz_Mevduat'
            WHEN 1 THEN '1-Vadeli_Mevduat'
            WHEN 2 THEN '2-Repo'
            WHEN 3 THEN '3-Teminat_Cekleri'
            WHEN 4 THEN '4-Teminat_Senetleri'
            WHEN 5 THEN '5-Tahsil_Cekleri'
            WHEN 6 THEN '6-Tahsil_Senetleri'
            WHEN 7 THEN '7-Nakit_Kredi_BorcluCariKrediRotatif'
            WHEN 8 THEN '8-Nakit_Kredi_Spot'
            WHEN 9 THEN '9-Nakit_Kredi_Iskonto_Istira'
            WHEN 10 THEN '10-GayriNakdiKredi_TeminatMektubu'
            WHEN 11 THEN '11-GayriNakdiKredi_HariciGaranti'
            WHEN 12 THEN '12-GayriNakdiKredi_IthalatAkreditifi'
            WHEN 13 THEN '13-GayriNakdiKredi_KabulVeAval'
            WHEN 14 THEN '14-KrediKartiHesabi_Pos'
            WHEN 15 THEN '15-Taksitli_Kredi'
            WHEN 16 THEN '16-Uzun_VadeliKredi'
            WHEN 17 THEN '17-Borc_Cekleri'
            WHEN 18 THEN '18-Borc_Senetleri'
            END) AS HesapTipi,
NETHESKODU BankaHesKodu,
(SELECT ANTPAK2023.dbo.TRK(ACIKLAMA) FROM ANTPAK2023.dbo.TBLBNKHESSABIT WITH(NOLOCK)  WHERE NETHESKODU=T1.NETHESKODU)as HesapAdi,
TARIH as Tarih,
ANTPAK2023.dbo.TRK(BELGENO) AS BelgeNo,
    (CASE HARTURU
        WHEN 0 THEN '0-Devir'
        WHEN 2 THEN '2-CariHavale'
        WHEN 3 THEN '3-BankaHavale'
        WHEN 4 THEN '4-Virman'
        WHEN 5 THEN '5-Faiz'
        WHEN 6 THEN '6-Masraf'
END) AS HareketTuru,
ANTPAK2023.dbo.TRK(ACIKLAMA) AS Aciklama,
    (CASE BA WHEN 'B' THEN TUTAR ELSE 0 END)AS Borc,
    (CASE BA WHEN 'A' THEN TUTAR ELSE 0 END)AS Alacak,
    (CASE WHEN T1.DOVIZTIPI= 0 THEN 'TL'
            ELSE
                (SELECT ISIM FROM NETSIS..KUR WITH(NOLOCK)  WHERE SIRA=T1.DOVIZTIPI)
END)AS DovizBirimi,
    (CASE WHEN DOVIZTUTAR <>0 THEN T1.TUTAR /DOVIZTUTAR ELSE 0 END) AS Kur,
    (CASE BA   WHEN 'B' THEN DOVIZTUTAR
        WHEN 'A' THEN DOVIZTUTAR END)AS DovizTutari,
ANTPAK2023.dbo.TRK(PLASIYERKODU) as PlaKodu,
(SELECT top(1) ANTPAK2023.dbo.TRK(PLASIYER_ACIKLAMA) FROM ANTPAK2023.dbo.TBLCARIPLASIYER WITH(NOLOCK) WHERE PLASIYER_KODU=PLASIYERKODU) AS PlasiyerAdi,
(SELECT top(1) FISNO FROM ANTPAK2023.dbo.TBLMUHFIS WITH(NOLOCK)  WHERE ENTEGREFKEY=T1.ENTEGREFKEY)AS MuhFisNo,
KAYITYAPANKUL as Kaydeden,
KAYITTARIHI as KayitTarihi
FROM ANTPAK2023.dbo.TBLBNKHESTRA T1 WITH(NOLOCK) 
Where YEAR(TARIH) = YEAR(GETDATE())
GO
/****** Object:  View [dbo].[IDW_MR_Alislar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IDW_MR_Alislar]
as
select 
(
CASE 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (1, 2) THEN 'SATIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (4, 5) THEN 'SATIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = '1' AND TIPI IN (6) THEN 'IHRACAT' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (1, 2) THEN 'ALIS FATURA' 
	WHEN SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5) THEN 'ALIS FATURA IADE' 
	WHEN SH.sthar_FTIRSIP = 'A' THEN 'FATURALASTIR IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '3' THEN 'SATIS IRSALIYE' 
	WHEN SH.sthar_FTIRSIP = '4' THEN 'ALIS IRSALIYE' 
ELSE 'HATA' END
)  
 AS [Fiş Tipi],
F.SUBE_KODU as SubeKodu,
F.TARIH as Tarih,
SH.FISNO as BelgeNo,
YEAR(F.TARIH) as Yil,
MONTH(F.TARIH) as Ay,
CASE MONTH(F.TARIH) 
WHEN 1 THEN 'Ocak'
WHEN 2 THEN 'Şubat'
WHEN 3 THEN 'Mart'
WHEN 4 THEN 'Nisan'
WHEN 5 THEN 'Mayıs'
WHEN 6 THEN 'Haziran'
WHEN 7 THEN 'Temmuz'
WHEN 8 THEN 'Ağustos'
WHEN 9 THEN 'Eylül'
WHEN 10 THEN 'Ekim'
WHEN 11 THEN 'Kasım'
WHEN 12 THEN 'Aralık'
ELSE '' END
as Ay2,
DAY(F.TARIH) as Gun,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
C.PLASIYER_KODU as CariPlasiyer,
C.KOSULKODU as CariKosulKodu,
C.FIYATGRUBU as CariFiyatGrubu,
ISNULL(C.GRUP_KODU,'TANIMSIZ') as CariGrupKodu,
ISNULL(C.RAPOR_KODU1,'TANIMSIZ') as CariKod1,
ISNULL(C.RAPOR_KODU2,'TANIMSIZ') as CariKod2,
ISNULL(C.RAPOR_KODU3,'TANIMSIZ') as CariKod3,
ISNULL(C.RAPOR_KODU4,'TANIMSIZ') as CariKod4,
ISNULL(C.RAPOR_KODU5,'TANIMSIZ') as CariKod5,
SH.PLASIYER_KODU as FaturaPlasiyer,
S.STOK_KODU as StokKodu,
ANTPAK2023.dbo.TRK(S.STOK_ADI) as StokAdi,
ISNULL(ANTPAK2023.dbo.TRK(S.GRUP_KODU),'TANIMSIZ') StokGrupKodu,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_1),'TANIMSIZ') StokKod1,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_2),'TANIMSIZ') StokKod2,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_3),'TANIMSIZ') StokKod3,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_4),'TANIMSIZ') StokKod4,
ISNULL(ANTPAK2023.dbo.TRK(S.KOD_5),'TANIMSIZ') StokKod5,
ANTPAK2023.dbo.TRK(C.GRUP_KODU) MusteriTipi,
ISNULL(KUR.ISIM,'TL') as DovizBirimi,
CAST(SH.STHAR_GCMIK * CASE WHEN (SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Miktar,
S.OLCU_BR1 as Birim,
CAST(SH.STHAR_NF as decimal(18,2)) as BirimFiyat,
CAST((SH.STHAR_GCMIK*SH.STHAR_NF)* CASE WHEN (SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5)) THEN -1 ELSE 1 END as decimal(18,2)) as Tutar
from ANTPAK2023.dbo.TBLSTHAR SH WITH(NOLOCK) 
INNER JOIN ANTPAK2023.dbo.TBLFATUIRS  F WITH(NOLOCK) ON F.FATIRS_NO = SH.FISNO
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = F.CARI_KODU
LEFT OUTER JOIN ANTPAK2023.dbo.TBLSTSABIT S WITH(NOLOCK) ON S.STOK_KODU = SH.STOK_KODU
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.NETSISSIRA = STHAR_DOVTIP
Where 1=1
and ((F.FTIRSIP = '2' and F.TIPI IN (1,2)) or (SH.sthar_FTIRSIP = '2' AND TIPI IN (4, 5))) 
and YEAR(F.TARIH)  = YEAR(GETDATE())
--and S.GRUP_KODU NOT IN ('GRUP_KODU','GGIDER','PROMASYN','HIZMET','DEPOZITO')
--and ISNULL(KOD_1,'') <> ''
--and PLA_KODU <> 'G'
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariAvukat]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariAvukat](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Avukattaki Cariler' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and C.GRUP_KODU = 'AVUKAT'
Group by C.GRUP_KODU,CH.CARI_KOD,C.CARI_ISIM
Order by SUM(BORC) - SUM(ALACAK) desc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariAlislar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariAlislar](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Alislar
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2 and BelgeNo = @Parametre3
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Alislar
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Alislar
Where 1=1 AND CariKodu = @Parametre1
Group by CariKodu,CariAdi,Ay,Ay2
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Alislar
Where 1=1
Group by CariKodu,CariAdi
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariAlacak320]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariAlacak320](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Alacaklı Tedarikçiler' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and CH.CARI_KOD LIKE '320%'
Group by CH.CARI_KOD,C.CARI_ISIM
having SUM(BORC) - SUM(ALACAK) < -1
Order by SUM(BORC) - SUM(ALACAK) asc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariAlacak120]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariAlacak120](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Borçlu Tedarikçiler' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and CH.CARI_KOD LIKE '320%'
Group by CH.CARI_KOD,C.CARI_ISIM
having SUM(BORC) - SUM(ALACAK) > 1
Order by SUM(BORC) - SUM(ALACAK) desc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_GR_Menuler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[IDP_GR_Menuler](
@MenuID int = 0
)
as
BEGIN
	Select * From ID_GR_Menu WITH(NOLOCK) Where Aktif = 1 and UstMenuID = @MenuID order by Sira
END
GO
/****** Object:  StoredProcedure [dbo].[IDP_EnvanterMarka]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_EnvanterMarka](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0

END
ELSE 
BEGIN

Select
dbo.TRK(S.STOK_KODU) as StokKodu,
dbo.TRK(S.STOK_ADI) as StokAdi,
SUM(SH.STHAR_GCMIK * CASE WHEN SH.STHAR_GCKOD = 'G' THEN 1 ELSE -1 END) as Adet,
'Stok Envanteri' as ParametreBaslik,
@Parametre_id as Parametre_id,
dbo.TRK(S.STOK_KODU) as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From TBLSTSABIT S WITH(NOLOCK)
INNER JOIN TBLSTHAR SH WITH(NOLOCK) ON SH.STOK_KODU = S.STOK_KODU
Where 1=1
Group by S.STOK_KODU,S.STOK_ADI
having SUM(SH.STHAR_GCMIK * CASE WHEN SH.STHAR_GCKOD = 'G' THEN 1 ELSE -1 END) > 0
Order by SUM(SH.STHAR_GCMIK * CASE WHEN SH.STHAR_GCKOD = 'G' THEN 1 ELSE -1 END) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_OngoruYaslandirma]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[IDP_OngoruYaslandirma](
@Tarih datetime=null
)
as
BEGIN
 
select 
Y.VADEGUNU as Isim,
CAST(YEAR(Y.VADEGUNU) as nvarchar(max))+'-'+cast(MONTH(Y.VADEGUNU) as nvarchar(max)) as Kategori,
CAST(SUM(Y.TAHSILAT) as decimal(18,0))  as Tutar2,
CAST(SUM(Y.ODEME) as decimal(18,0)) as Tutar
from ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) 
INNER JOIN ANTPAK2023.dbo.INN_FN_OZELYASLANDIR('','E') as Y ON Y.CARI_KODU = C.CARI_KOD 
Where VADEGUNU <> '2023-01-01'
Group by Y.VADEGUNU
having SUM(Y.TAHSILAT)+SUM(Y.ODEME) >= 10 
order by YEAR(Y.VADEGUNU) desc,MONTH(Y.VADEGUNU) desc ,Y.VADEGUNU desc

END
GO
/****** Object:  View [dbo].[IDW_GenelGiderler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_GenelGiderler]
as
select 
REPLACE(TBLMUHFIS.HES_KOD,'-','') as Kod,
ANTPAK2023.dbo.TRK(TBLMUPLAN.HS_ADI) Isim,
TBLMUHFIS.AY_KODU as Kategori,
SUM(TUTAR)  Tutar
from ANTPAK2023.dbo.TBLMUHFIS
LEFT OUTER JOIN ANTPAK2023.dbo.TBLMUPLAN ON  TBLMUPLAN.HESAP_KODU = TBLMUHFIS.HES_KOD
where HES_KOD IN ('770-01-023','720-01-001','770-01-006',
'770-01-007','770-01-010','770-01-011','730-01-001',
'730-01-004','730-01-005','730-01-001','730-01-017','760-01-001'
,'770-01-029','770-01-001','770-01-003' )
and TARIH >= '2023-01-01'
group by TBLMUHFIS.HES_KOD,TBLMUPLAN.HS_ADI,AY_KODU
GO
/****** Object:  View [dbo].[IDW_CariBakiyeleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_CariBakiyeleri]
as
select
C.CARI_KOD as VergiNumarasi,
C.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
ISNULL(c.PLASIYER_KODU,'') as PlasiyerKodu,
ISNULL(D.ISIM,'TL') as DovizBirimi,
SUM(BORC)-SUM(ALACAK) as Bakiye
from ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK)
INNER JOIN ANTPAK2023.dbo.TBLCAHAR CH WITH(NOLOCK) ON CH.CARI_KOD = C.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR D WITH(NOLOCK) ON D.SIRA = CH.DOVIZ_TURU
Group by c.CARI_KOD,C.CARI_ISIM,C.PLASIYER_KODU,CH.DOVIZ_TURU,D.ISIM
having SUM(BORC)-SUM(ALACAK) <> 0
GO
/****** Object:  View [dbo].[IDW_BankaBakiyeleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[IDW_BankaBakiyeleri]
as
select 
[Hesap Kodu] as HesapKodu,
'BANKA - '+HesapAdi as HesapAdi,
CAST(SUM([Borç])-SUM([Alacak]) as decimal(18,2)) as Tutar,
CAST(SUM([Borç TL])-SUM([Alacak TL]) as decimal(18,2)) as TutarTL,
CAST(SUM([Borç $])-SUM([Alacak $]) as decimal(18,2)) as TutarUSD,
CAST(SUM([Borç ])-SUM([Alacak ]) as decimal(18,2)) as TutarEUR 
from (
SELECT B.BAGLIHESAPKODU + '  ' + ANTPAK2023.dbo.TRK(B.ACIKLAMA) AS [Banka Kodu  Adı],
BH.TARIH AS Tarih, 
BH.BELGENO AS [İşlem No.],
BH.HARTURU,
CASE BH.HARTURU
WHEN 1 THEN 'Banka İşlem Fişi'                WHEN 2 THEN 'Banka Virman Fişi'
WHEN 3 THEN 'Gelen Havale-EFT'                WHEN 4 THEN 'Gönderilen EFT/Havale'
WHEN 5 THEN 'Banka Açılış Fişi'               WHEN 6 THEN 'Banka Kur Farkı Fişi'
WHEN 16 THEN 'Banka Alınan Hizmet Faturası'   WHEN 17 THEN 'Banka Verilen Hizmet Faturası'
WHEN 18 THEN 'Bankadan Çek Ödemesi'           WHEN 19 THEN 'Bankadan Senet Ödemesi'
END AS [İşlem Türü],
B.NETHESKODU  AS [Hesap Kodu],
ANTPAK2023.dbo.TRK(B.ACIKLAMA) AS [HesapAdi],
ISNULL(CASE WHEN BH.BA = 'B' THEN TUTAR END, 0) AS [Borç],
ISNULL(CASE WHEN BH.BA = 'A' THEN TUTAR END, 0) AS [Alacak],
ISNULL(CASE WHEN BH.BA = 'B' AND BH.DOVIZTIPI = 0 THEN TUTAR END, 0) AS [Borç TL],
ISNULL(CASE WHEN BH.BA = 'A' AND BH.DOVIZTIPI = 0 THEN TUTAR END, 0) AS [Alacak TL],
ISNULL(CASE WHEN BH.BA = 'B' AND BH.DOVIZTIPI = 1 THEN DOVIZTUTAR END, 0) AS [Borç $],
ISNULL(CASE WHEN BH.BA = 'A' AND BH.DOVIZTIPI = 1 THEN DOVIZTUTAR END, 0) AS [Alacak $],
ISNULL(CASE WHEN BH.BA = 'B' AND BH.DOVIZTIPI = 2 THEN DOVIZTUTAR END, 0) AS [Borç ],
ISNULL(CASE WHEN BH.BA = 'A' AND BH.DOVIZTIPI = 2 THEN DOVIZTUTAR END, 0) AS [Alacak ]
FROM ANTPAK2023.dbo.TBLBNKHESSABIT B WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLBNKHESTRA  BH WITH(NOLOCK) ON BH.NETHESKODU = B.NETHESKODU
WHERE   1=1 and B.NETHESKODU NOT IN ('104-01-006','103-01-001','104-01-002','108-03-001','104-02-002','108-01-001','126-03-001')
) R1
Where 1=1
group by [Hesap Kodu],HesapAdi
having (SUM([Borç TL])-SUM([Alacak TL]))+(SUM([Borç $])-SUM([Alacak $]))+(SUM([Borç ])-SUM([Alacak ])) <> 0
union all

select 
K.KSMAS_KOD as KasaKodu,
'KASA - '+ANTPAK2023.dbo.TRK(K.KSMAS_NAME) as KasaAdi,
MAX(CASE WHEN DOVIZTIPI = 0 THEN KSSONDEV_T ELSE 0 END) + SUM(CASE WHEN DOVIZTIPI = 0 THEN TUTAR ELSE 0 END * CASE WHEN [IO]= 'G' THEN 1 ELSE -1 END) as Tutar,
MAX(CASE WHEN DOVIZTIPI = 0 THEN KSSONDEV_T ELSE 0 END) + SUM(CASE WHEN DOVIZTIPI = 0 THEN TUTAR ELSE 0 END * CASE WHEN [IO]= 'G' THEN 1 ELSE -1 END) as TutarTL,
MAX(CASE WHEN DOVIZTIPI = 1 THEN KSSONDEV_T ELSE 0 END) + SUM(CASE WHEN DOVIZTIPI = 1 THEN DOVIZTUT ELSE 0 END * CASE WHEN [IO]= 'G' THEN 1 ELSE -1 END) as TutarUSD,
MAX(CASE WHEN DOVIZTIPI = 2 THEN KSSONDEV_T ELSE 0 END) + SUM(CASE WHEN DOVIZTIPI = 2 THEN DOVIZTUT ELSE 0 END * CASE WHEN [IO]= 'G' THEN 1 ELSE -1 END) as TutarEUR
from ANTPAK2023.dbo.TBLKASAMAS K WITH(NOLOCK)
INNER JOIN ANTPAK2023.dbo.TBLKASA KH WITH(NOLOCK) ON KH.KSMAS_KOD = K.KSMAS_KOD
LEFT OUTER JOIN NETSIS.dbo.DOVIZ USD WITH(NOLOCK) ON USD.TARIH = CAST(GETDATE() as DATE) and USD.SIRA = 1
LEFT OUTER JOIN NETSIS.dbo.DOVIZ ERU WITH(NOLOCK) ON ERU.TARIH = CAST(GETDATE() as DATE) and ERU.SIRA = 2
where K.KSMAS_KOD = '100'
Group by 
K.KSMAS_KOD,
K.KSMAS_NAME
GO
/****** Object:  StoredProcedure [dbo].[IDP_AylikAlislar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_AylikAlislar](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
StokKodu as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Alislar
Where 1=1 and Ay = @Parametre1 and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by Ay,FaturaPlasiyer,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Alislar
Where 1=1 and Ay = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by Ay,FaturaPlasiyer,CariKodu,CariAdi
Order by CAST(SUM(Tutar) as decimal(18,2)) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Alislar
Where 1=1 and Ay = @Parametre1
Group by Ay,FaturaPlasiyer
Order by CAST(SUM(Tutar) as decimal(18,2)) desc

END
ELSE 
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Alışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
Ay as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Alislar
Where 1=1
Group by Ay,Ay2
Order by Ay asc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariBorcAlacak320]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariBorcAlacak320](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Cari Borç Alacak' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From ANTPAK2023.dbo.TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and CH.CARI_KOD LIKE '320%'
Group by CH.CARI_KOD,C.CARI_ISIM
having SUM(BORC) - SUM(ALACAK) > 100 or SUM(BORC) - SUM(ALACAK) < -100
Order by SUM(BORC) - SUM(ALACAK) desc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariBorcAlacak]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariBorcAlacak](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
ANTPAK2023.dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Cari Borç Alacak' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From ANTPAK2023.dbo.TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN ANTPAK2023.dbo.TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and CH.CARI_KOD LIKE '120%'
Group by CH.CARI_KOD,C.CARI_ISIM
having SUM(BORC) - SUM(ALACAK) > 100 or SUM(BORC) - SUM(ALACAK) < -100
Order by SUM(BORC) - SUM(ALACAK) desc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariBorc320]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariBorc320](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Alacaklı Müşteriler' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and CH.CARI_KOD LIKE '120%'
Group by CH.CARI_KOD,C.CARI_ISIM
having SUM(BORC) - SUM(ALACAK) < -1
Order by SUM(BORC) - SUM(ALACAK) asc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariBorc120]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariBorc120](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select 0
END
ELSE 
BEGIN

select
--CH.CARI_KOD as CariKodu,
dbo.TRK(C.CARI_ISIM) as CariAdi,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN BORC ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 0 THEN ALACAK ELSE 0 END) as decimal(18,0)) as TL,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 1 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 1 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as USD,
CAST(SUM(CASE WHEN CH.DOVIZ_TURU = 2 and BORC > 0 THEN DOVIZ_TUTAR ELSE 0 END)-SUM(CASE WHEN CH.DOVIZ_TURU = 2 and ALACAK > 0 THEN DOVIZ_TUTAR ELSE 0 END) as decimal(18,0)) as EUR,
'Borçlu Müşteriler' as ParametreBaslik,
@Parametre_id as Parametre_id,
CH.CARI_KOD as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From TBLCAHAR CH WITH(NOLOCK)
LEFT OUTER JOIN TBLCASABIT C WITH(NOLOCK) ON C.CARI_KOD = CH.CARI_KOD
LEFT OUTER JOIN NETSIS.dbo.KUR WITH(NOLOCK) ON KUR.SIRA = CH.DOVIZ_TURU
where 1=1 and CH.CARI_KOD LIKE '120%'
Group by CH.CARI_KOD,C.CARI_ISIM
having SUM(BORC) - SUM(ALACAK) > 1
Order by SUM(BORC) - SUM(ALACAK) desc


END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariBekleyen]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariBekleyen](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
StokKodu as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and CariKodu = @Parametre1 and BelgeNo = @Parametre2
Group by CariKodu,CariAdi,BelgeNo,StokKodu,StokAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Tarih,
BelgeNo,
Aciklama4 as Aciklama,
SUM(MiktaR) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
BelgeNo as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and CariKodu = @Parametre1
Group by CariKodu,CariAdi,Tarih,BelgeNo,Aciklama4
Order by SUM(Tutar) desc
END
ELSE 
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1
Group by CariKodu,CariAdi
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_Tahsilatlar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_Tahsilatlar](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
Tarih,
CAST((CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST((CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST((CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Tahsilatlar
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE()) and MONTH(Tarih) = @Parametre1
and Tip = @Parametre2
--Group by MONTH(Tarih),Tip,CariKodu,CariAdi,Tarih
Order by Tarih desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Tip,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Tip as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Tahsilatlar
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE()) and MONTH(Tarih) = @Parametre1
Group by MONTH(Tarih),Tip
Order by SUM(Tutar) desc
END
ELSE 
BEGIN

Select
CAST(MONTH(Tarih) as nvarchar(max))+'. Ay' as Ay,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
MONTH(Tarih) as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Tahsilatlar
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE())
Group by MONTH(Tarih)
Order by MONTH(Tarih) 

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_SiparislerGunluk]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_SiparislerGunluk](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@PArametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Tarih = @Parametre1 and CariKodu = @Parametre2 and BelgeNo = @Parametre3
Group by Tarih,CariKodu,CariAdi,BelgeNo,StokKodu,StokAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Tarih = @Parametre1 and CariKodu = @Parametre2
Group by Tarih,CariKodu,CariAdi,Tarih,BelgeNo
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Tarih = @Parametre1
Group by Tarih,CariKodu,CariAdi
Order by SUM(Tutar) desc
END
ELSE 
BEGIN

Select
Tarih as Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
Tarih as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by Tarih
Order by Tarih desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_Siparisler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_Siparisler](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@PArametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Ay2+' - '+CAST(Yil as nvarchar(max)) = @Parametre1 and CariKodu = @Parametre2 and BelgeNo = @Parametre3
Group by Yil,Ay2,Ay,CariKodu,CariAdi,BelgeNo,StokKodu,StokAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Ay2+' - '+CAST(Yil as nvarchar(max)) = @Parametre1 and CariKodu = @Parametre2
Group by Yil,Ay2,Ay,CariKodu,CariAdi,Tarih,BelgeNo
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Ay2+' - '+CAST(Yil as nvarchar(max)) = @Parametre1
Group by Yil,Ay2,Ay,CariKodu,CariAdi
Order by SUM(Tutar) desc
END
ELSE 
BEGIN

Select
Ay2+' - '+CAST(Yil as nvarchar(max)) as Ay,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
Ay2+' - '+CAST(Yil as nvarchar(max)) as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by Yil,Ay2,Ay
Order by LEN(Ay),CAST(Ay as INT)

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_PlasiyerSiparisleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_PlasiyerSiparisleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2 and CariKodu = @Parametre3 and BelgeNo = @Parametre4
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi,Tarih,BelgeNo,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
Tarih,
BelgeNo,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
BelgeNo as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2 and CariKodu = @Parametre3
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi,Tarih,BelgeNo
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND FaturaPlasiyer = @Parametre1
Group by FaturaPlasiyer,Ay,Ay2
Order by Ay

END
ELSE 
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
FaturaPlasiyer as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by FaturaPlasiyer
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_PlasiyerSatislari]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_PlasiyerSatislari](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2 and CariKodu = @Parametre3
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND FaturaPlasiyer = @Parametre1
Group by FaturaPlasiyer,Ay,Ay2
Order by Ay

END
ELSE 
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
FaturaPlasiyer as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1
Group by FaturaPlasiyer
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_PlasiyerIrsaliyeleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_PlasiyerIrsaliyeleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2 and CariKodu = @Parametre3
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND FaturaPlasiyer = @Parametre1 and Ay = @Parametre2
Group by FaturaPlasiyer,Ay,Ay2,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND FaturaPlasiyer = @Parametre1
Group by FaturaPlasiyer,Ay,Ay2
Order by Ay

END
ELSE 
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Plasiyer Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
FaturaPlasiyer as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1
Group by FaturaPlasiyer
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_OngoruGrafigiGunluk]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[IDP_OngoruGrafigiGunluk]
as
BEGIN


select 
CAST(DAY(Tarih) as nvarchar(max)) +'-'+
CAST(MONTH(Tarih) as nvarchar(max)) +'-'+
CAST(YEAR(Tarih) as nvarchar(max)) 
as Isim,
SUM(CASE WHEN Tutar > 0 THEN Tutar ELSE 0 END) as Tutar,
SUM(CASE WHEN Tutar < 0 THEN Tutar ELSE 0 END) as Tutar2 
from (
select VadeTarihi as Tarih,Tutar  from IDW_MR_CekSenet where Tip = N'Müsteri Çeki'
union all
select VadeTarihi,Tutar*-1  from IDW_MR_CekSenet where Tip <> N'Müsteri Çeki'
union all
select Tarih,Tutar*-1 from ID_GR_Giderler
union all
select 
IDW_MR_Tahsilatlar.Tarih,
(Tutar * ISNULL(DOVIZ.DOV_SATIS,1)) as Tutar 
from IDW_MR_Tahsilatlar
LEFT OUTER JOIN NETSIS.dbo.KUR ON KUR.ISIM = DovizBirimi
LEFT OUTER JOIN NETSIS.dbo.DOVIZ 
ON DOVIZ.SIRA = KUR.SIRA and DOVIZ.TARIH = IDW_MR_Tahsilatlar.Tarih
where YEAR(IDW_MR_Tahsilatlar.Tarih) = 2023 

) R1
where YEAR(Tarih) = 2023 and Tarih >= CAST(GETDATE() as DATE)
group by Tarih
order by Tarih desc

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_OngoruGrafigi]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[IDP_OngoruGrafigi]
as
BEGIN

select 
Yil,
Ay as Isim,
SUM(CASE WHEN Tutar > 0 THEN Tutar ELSE 0 END) as Tutar, 
SUM(CASE WHEN Tutar < 0 THEN Tutar ELSE 0 END) as Tutar2 
from (
select YEAR(Tarih) as Yil,MONTH(Tarih) as Ay,Tutar  from IDW_MR_CekSenet where Tip = N'Müsteri Çeki'
union all
select YEAR(Tarih) as Yil,MONTH(Tarih) as Ay,Tutar*-1  from IDW_MR_CekSenet where Tip <> N'Müsteri Çeki'
union all
select YEAR(Tarih),MONTH(Tarih),Tutar*-1 from ID_GR_Giderler
union all
select 
YEAR(IDW_MR_Tahsilatlar.Tarih),
MONTH(IDW_MR_Tahsilatlar.Tarih),
(Tutar * ISNULL(DOVIZ.DOV_SATIS,1)) as Tutar 
from IDW_MR_Tahsilatlar
LEFT OUTER JOIN NETSIS.dbo.KUR ON KUR.ISIM = DovizBirimi
LEFT OUTER JOIN NETSIS.dbo.DOVIZ 
ON DOVIZ.SIRA = KUR.SIRA and DOVIZ.TARIH = IDW_MR_Tahsilatlar.Tarih
where YEAR(IDW_MR_Tahsilatlar.Tarih) = 2023 

) R1
where Yil = 2023 and Ay >= MONTH(GETDATE())
group by Yil,Ay
order by Yil,Ay desc

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_Ongoru]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[IDP_Ongoru](
@MenuID nvarchar(max),
@Yil nvarchar(max)=2023,
@Ay nvarchar(max)=null,
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)='',
@ParametreDur int=0
)
as
BEGIN

declare @Deger1 nvarchar(100) = (select Parametre_id From ID_GR_Menu WITH(NOLOCK) Where ID = @MenuID)
declare @Title nvarchar(100) = (select MenuAdi From ID_GR_Menu WITH(NOLOCK) Where ID = @MenuID)

IF @Ay IS NOT NULL
BEGIN

select * from (

select top(9999999)
'Öngörü' as Baslik,
@Deger1 as Parametre_id,
CASE WHEN Tip LIKE 'Kendi Çekimiz%' THEN ISNULL(N'Kendi Çekimiz / '+CariAdi,'') ELSE '' END + 
CASE WHEN Tip = 'Müşteri Çeki' THEN ISNULL(N'Müşteri Çeki / '+CariAdi,'') ELSE '' END  as Isim,
VadeTarihi as Tarih,
Tutar * (CASE WHEN Tip LIKE 'Kendi Çekimiz%' THEN -1 ELSE 1 END) as [Tutar],
CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END * (CASE WHEN Tip LIKE 'Kendi Çekimiz%' THEN -1 ELSE 1 END) as TutarTL,
CASE WHEN DovizBirimi like '%USD%' THEN Tutar ELSE 0 END * (CASE WHEN Tip LIKE 'Kendi Çekimiz%' THEN -1 ELSE 1 END) as TutarUSD,
CASE WHEN DovizBirimi like '%Eur%' THEN Tutar ELSE 0 END * (CASE WHEN Tip LIKE 'Kendi Çekimiz%' THEN -1 ELSE 1 END) as TutarEUR
from IDW_MR_CekSenet
Where 1=1 and Durum IN ('Pörtföyde','Bankada')
and YEAR(VadeTarihi) = @Yil and MONTH(VadeTarihi) = @Ay and Tutar <> 0
--and TutarEUR <> 0
Order by Durum, VadeTarihi
) R1

union all

select 'Öngörü' Baslik,@Deger1 as Parametre_id,Isim,ID_GR_Giderler.Tarih,
CASE WHEN DovizBirimi = 'TL' or DovizBirimi = '' THEN Tutar*-1 WHEN DovizBirimi = 'USD' THEN Tutar*-1 WHEN DovizBirimi = 'EUR' THEN EUR.DOV_SATIS* Tutar*-1  ELSE 0 END as Tutar,
CASE WHEN DovizBirimi = 'TL' or DovizBirimi = '' THEN Tutar*-1 ELSE 0 END as TutarTL,
CASE WHEN DovizBirimi = 'USD' THEN Tutar*-1 ELSE 0 END as TutarUSD,
CASE WHEN DovizBirimi = 'EUR' THEN Tutar*-1 ELSE 0 END as TutarEUR
from ID_GR_Giderler WITH(NOLOCK) 
LEFT OUTER JOIN NETSIS.dbo.DOVIZ USD WITH(NOLOCK) ON USD.TARIH = CAST(GETDATE() as DATE) and USD.SIRA = 1
LEFT OUTER JOIN NETSIS.dbo.DOVIZ EUR WITH(NOLOCK) ON EUR.TARIH = CAST(GETDATE() as DATE) and EUR.SIRA = 2
Where YEAR(ID_GR_Giderler.Tarih) = @Yil 
and MONTH(ID_GR_Giderler.Tarih) = @Ay 
and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE)

union all 
select 
HesapAdi as Baslik,
@Deger1 as Parametre_id,
HesapAdi as Isim,
GETDATE() Tarih,  
Tutar as Tutar,
TutarTL,
TutarUSD,
TutarEUR
from IDW_BankaBakiyeleri Where YEAR(GETDATE()) = @Yil and MONTH(GETDATE()) = @Ay

END
ELSE
BEGIN

select 
'Öngörü' as ParametreBaslik,
@Deger1 as Parametre_id,
YEAR(VadeTarihi) as Parametre1,
MONTH(VadeTarihi) as Parametre2,
@MenuID as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur,
CAST(YEAR(VadeTarihi) as nvarchar(max))+' - '+CAST(MONTH(VadeTarihi) as nvarchar(max))+'. Ay' as Baslik,


CAST(


SUM(CASE WHEN (Tip = N'Müsteri Çeki' or Tip = 'Senet') and DovizBirimi = 'TL' THEN Tutar ELSE 0 END) 
-
ISNULL((
(
SUM(CASE WHEN Tip like 'Kendi Çekimiz%' THEN (CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) ELSE 0 END) 
-
ISNULL((select SUM(ID_GR_Giderler.Tutar)*-1 from ID_GR_Giderler WITH(NOLOCK) Where DovizBirimi = 'TL' and YEAR(ID_GR_Giderler.Tarih) = YEAR(VadeTarihi) and MONTH(ID_GR_Giderler.Tarih) = MONTH(R1.VadeTarihi)  and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE) ),0)
-
ISNULL((select SUM(IDW_BankaBakiyeleri.TutarTL) from IDW_BankaBakiyeleri Where MONTH(GETDATE()) = MONTH(VadeTarihi) and YEAR(GETDATE()) = YEAR(VadeTarihi)),0)
)
),0)

+ ---------------------------
SUM(CASE WHEN Tip = N'Müsteri Çeki'or Tip = 'Senet' THEN (CASE WHEN DovizBirimi like '%USD%' THEN Tutar ELSE 0 END) ELSE 0 END)
-
(
SUM(CASE WHEN Tip like 'Kendi Çekimiz%' THEN (CASE WHEN DovizBirimi like '%USD%' THEN Tutar ELSE 0 END) ELSE 0 END) 
-
ISNULL((select SUM(ID_GR_Giderler.Tutar)*-1 from ID_GR_Giderler WITH(NOLOCK) Where DovizBirimi = 'USD' and YEAR(ID_GR_Giderler.Tarih) = YEAR(R1.VadeTarihi) and MONTH(ID_GR_Giderler.Tarih) = MONTH(R1.VadeTarihi)  and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE) ),0)
-
ISNULL((select SUM(TutarUSD) from IDW_BankaBakiyeleri Where MONTH(GETDATE()) = MONTH(VadeTarihi) and YEAR(GETDATE()) = YEAR(VadeTarihi)),0)
)
* MAX(ISNULL(USD.DOV_SATIS,1))
+ --------------------------
SUM(CASE WHEN Tip = N'Müsteri Çeki'or Tip = 'Senet' THEN (CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) ELSE 0 END)
-
(
SUM(CASE WHEN Tip like 'Kendi Çekimiz%' THEN (CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) ELSE 0 END) 
-
ISNULL((select SUM(ID_GR_Giderler.Tutar)*-1 from ID_GR_Giderler WITH(NOLOCK) Where DovizBirimi = 'EUR' and YEAR(ID_GR_Giderler.Tarih) = YEAR(R1.VadeTarihi) and MONTH(ID_GR_Giderler.Tarih) = MONTH(R1.VadeTarihi)  and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE) ),0)
-
ISNULL((select SUM(TutarEUR) from IDW_BankaBakiyeleri Where MONTH(GETDATE()) = MONTH(VadeTarihi) and YEAR(GETDATE()) = YEAR(VadeTarihi)),0)
)
* MAX(ISNULL(EUR.DOV_SATIS,1))




as decimal(18,2))


as [Fark Toplam TL],
SUM(CASE WHEN (Tip = N'Müsteri Çeki' or Tip = 'Senet') and DovizBirimi = 'TL' THEN Tutar ELSE 0 END) 
-
ISNULL((
(
SUM(CASE WHEN Tip like 'Kendi Çekimiz%' THEN (CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) ELSE 0 END) 
-
ISNULL((select SUM(ID_GR_Giderler.Tutar)*-1 from ID_GR_Giderler WITH(NOLOCK) Where DovizBirimi = 'TL' and YEAR(ID_GR_Giderler.Tarih) = YEAR(VadeTarihi) and MONTH(ID_GR_Giderler.Tarih) = MONTH(R1.VadeTarihi)  and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE) ),0)
-
ISNULL((select SUM(IDW_BankaBakiyeleri.TutarTL) from IDW_BankaBakiyeleri Where MONTH(GETDATE()) = MONTH(VadeTarihi) and YEAR(GETDATE()) = YEAR(VadeTarihi)),0)
)
),0)
as FarkTL,
SUM(CASE WHEN Tip = N'Müsteri Çeki'or Tip = 'Senet' THEN (CASE WHEN DovizBirimi like '%USD%' THEN Tutar ELSE 0 END) ELSE 0 END)
-
(
SUM(CASE WHEN Tip like 'Kendi Çekimiz%' THEN (CASE WHEN DovizBirimi like '%USD%' THEN Tutar ELSE 0 END) ELSE 0 END) 
-
ISNULL((select SUM(ID_GR_Giderler.Tutar)*-1 from ID_GR_Giderler WITH(NOLOCK) Where DovizBirimi = 'USD' and YEAR(ID_GR_Giderler.Tarih) = YEAR(R1.VadeTarihi) and MONTH(ID_GR_Giderler.Tarih) = MONTH(R1.VadeTarihi)  and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE) ),0)
-
ISNULL((select SUM(TutarUSD) from IDW_BankaBakiyeleri Where MONTH(GETDATE()) = MONTH(VadeTarihi) and YEAR(GETDATE()) = YEAR(VadeTarihi)),0)
)
as FarkUSD,
SUM(CASE WHEN Tip = N'Müsteri Çeki'or Tip = 'Senet' THEN (CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) ELSE 0 END)
-
(
SUM(CASE WHEN Tip like 'Kendi Çekimiz%' THEN (CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) ELSE 0 END) 
-
ISNULL((select SUM(ID_GR_Giderler.Tutar)*-1 from ID_GR_Giderler WITH(NOLOCK) Where DovizBirimi = 'EUR' and YEAR(ID_GR_Giderler.Tarih) = YEAR(R1.VadeTarihi) and MONTH(ID_GR_Giderler.Tarih) = MONTH(R1.VadeTarihi)  and ID_GR_Giderler.Tarih >= CAST(GETDATE() as DATE) ),0)
-
ISNULL((select SUM(TutarEUR) from IDW_BankaBakiyeleri Where MONTH(GETDATE()) = MONTH(VadeTarihi) and YEAR(GETDATE()) = YEAR(VadeTarihi)),0)
)
as FarkEUR
from (
select 
Tip	,Kod	,CariKodu	,CariAdi	,Tarih	,VadeTarihi	,Durum	,SC_YERI	,
Ay2	,BelgeNo	,SeriNo	,Aciklama	,DovizBirimi	,Tutar	,SubeKodu	,
CiroEdilen	,CiroEden	,PlasiyerKodu

from  IDW_MR_CekSenet 
union all
Select
'Müsteri Çeki',	''	,''	,''	,Tarih	,Tarih	,''	,
''	,''	,''	,''	,''	,'TL'	,0	as Tutar
,0	,''	,''	,''
From ID_Tarihler
) R1
LEFT OUTER JOIN NETSIS.dbo.DOVIZ USD WITH(NOLOCK) ON USD.TARIH = CAST(GETDATE() as DATE) and USD.SIRA = 1
LEFT OUTER JOIN NETSIS.dbo.DOVIZ EUR WITH(NOLOCK) ON EUR.TARIH = CAST(GETDATE() as DATE) and EUR.SIRA = 2
Where 1=1 and Durum IN ('','Pörtföyde','Bankada')
and YEAR(VadeTarihi) >= YEAR(GETDATE())
and MONTH(VadeTarihi) >= MONTH(GETDATE())
group by YEAR(VadeTarihi),MONTH(VadeTarihi)
Order by YEAR(VadeTarihi),MONTH(VadeTarihi),SUM(CASE WHEN Durum = N'Müsteri Çeki' THEN Tutar ELSE 0 END)

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_NakitTahsilatlar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_NakitTahsilatlar](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Nakit Tahsilatlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
Tarih as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_KasaHareketleri
Where 1=1  and MONTH(Tarih) = @Parametre1 and HesapKodu = @Parametre2
and [GC] = 'G'
Group by MONTH(Tarih),HesapKodu,HesapAdi,Tarih
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
HesapAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Nakit Tahsilatlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
HesapKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_KasaHareketleri
Where 1=1  and MONTH(Tarih) = @Parametre1
and [GC] = 'G'
Group by MONTH(Tarih),HesapKodu,HesapAdi
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CAST(MONTH(Tarih) as nvarchar(max))+'. Ay' as Ay,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Nakit Tahsilatlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
MONTH(Tarih) as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_KasaHareketleri
Where 1=1 
and [GC] = 'G'
Group by MONTH(Tarih)
Order by MONTH(Tarih) asc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_MarkaSiparisleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_MarkaSiparisleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and StokGrupKodu = @Parametre1  and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by StokGrupKodu,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND StokGrupKodu = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by StokGrupKodu,FaturaPlasiyer,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND StokGrupKodu = @Parametre1
Group by StokGrupKodu,FaturaPlasiyer
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
StokGrupKodu as Marka,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
StokGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by StokGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_MarkaSatislari]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_MarkaSatislari](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 and StokGrupKodu = @Parametre1  and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by StokGrupKodu,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND StokGrupKodu = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by StokGrupKodu,FaturaPlasiyer,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND StokGrupKodu = @Parametre1
Group by StokGrupKodu,FaturaPlasiyer
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
StokGrupKodu as Marka,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
StokGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1
Group by StokGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_MarkaIrsaliyeleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_MarkaIrsaliyeleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen Sevk Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 and StokGrupKodu = @Parametre1  and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by StokGrupKodu,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen Sevk Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND StokGrupKodu = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by StokGrupKodu,FaturaPlasiyer,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen Sevk Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND StokGrupKodu = @Parametre1
Group by StokGrupKodu,FaturaPlasiyer
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
StokGrupKodu as Marka,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen Sevk Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
StokGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1
Group by StokGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_MarkaBekleyen]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_MarkaBekleyen](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and StokGrupKodu = @Parametre1 and CariKodu = @Parametre2 and BelgeNo = @Parametre3
Group by StokGrupKodu,CariKodu,CariAdi,Tarih,BelgeNo,StokKodu,StokAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and StokGrupKodu = @Parametre1 and CariKodu = @Parametre2
Group by StokGrupKodu,CariKodu,CariAdi,Tarih,BelgeNo
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and StokGrupKodu = @Parametre1
Group by StokGrupKodu,CariKodu,CariAdi
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
StokGrupKodu as Marka,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Marka Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
StokGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1
Group by StokGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_HavaleGiden]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_HavaleGiden](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
BankaAdi,
Aciklama,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Alacak ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as EUR,
'Giden Havale' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_BankaHareketleri
Where 1=1 and Alacak > 0 and MONTH(Tarih) = @Parametre1 and Tarih = @Parametre2
Group by MONTH(Tarih),Tarih,BankaAdi,Aciklama
Order by (SUM(Borc+Alacak)) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Alacak ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as EUR,
'Giden Havale' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Tarih as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_BankaHareketleri
Where 1=1 and Alacak > 0 and MONTH(Tarih) = @Parametre1
Group by MONTH(Tarih),Tarih
Order by Tarih asc

END
ELSE 
BEGIN

Select
CAST(MONTH(Tarih) as nvarchar(max))+'. Ay' as Ay,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Alacak ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as EUR,
'Giden Havale' as ParametreBaslik,
@Parametre_id as Parametre_id,
MONTH(Tarih) as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_BankaHareketleri
Where 1=1 and Alacak > 0
Group by MONTH(Tarih)
Order by MONTH(Tarih) asc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_HavaleGelen]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_HavaleGelen](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
BankaAdi,
Aciklama,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Borc ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as EUR,
'Gelen Havale' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_BankaHareketleri
Where 1=1 and Borc > 0 and MONTH(Tarih) = @Parametre1 and Tarih = @Parametre2
Group by MONTH(Tarih),Tarih,BankaAdi,Aciklama
Order by (SUM(Borc+Alacak)) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Borc ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as EUR,
'Gelen Havale' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Tarih as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_BankaHareketleri
Where 1=1 and Borc > 0 and MONTH(Tarih) = @Parametre1
Group by MONTH(Tarih),Tarih
Order by Tarih asc

END
ELSE 
BEGIN

Select
CAST(MONTH(Tarih) as nvarchar(max))+'. Ay' as Ay,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Borc ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%Eur%' THEN DovizTutari ELSE 0 END) as decimal(18,2)) as EUR,
'Gelen Havale' as ParametreBaslik,
@Parametre_id as Parametre_id,
MONTH(Tarih) as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_BankaHareketleri
Where 1=1 and Borc > 0
Group by MONTH(Tarih)
Order by MONTH(Tarih) asc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_GunlukSiparisler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_GunlukSiparisler](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Günlük Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Tarih = @Parametre1  and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by Tarih,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Günlük Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Tarih = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by Tarih,FaturaPlasiyer,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Günlük Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Tarih = @Parametre1
Group by Tarih,FaturaPlasiyer
Order by  SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CAST(RIGHT('00'+CAST(DAY(Tarih) as nvarchar(max)),2)+'-'+RIGHT('00'+CAST(MONTH(Tarih) as nvarchar(max)),2) +'-'+CAST(YEAR(Tarih) as nvarchar(max))  as nvarchar(max)) as Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Günlük Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
Tarih as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by Tarih
Order by YEAR(Tarih) desc,MONTH(Tarih) desc,DAY(Tarih) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_GunlukSatislar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_GunlukSatislar](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
StokAdi,
Birim,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
StokKodu as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 and Tarih = @Parametre1  and CariKodu = @Parametre2
Group by Tarih,CariKodu,CariAdi,StokKodu,StokAdi,Birim
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 and Tarih = @Parametre1
Group by Tarih,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CAST(RIGHT('00'+CAST(DAY(Tarih) as nvarchar(max)),2)+'-'+RIGHT('00'+CAST(MONTH(Tarih) as nvarchar(max)),2) +'-'+CAST(YEAR(Tarih) as nvarchar(max))  as nvarchar(max)) as Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
Tarih as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1
Group by Tarih
Order by YEAR(Tarih) desc,MONTH(Tarih) desc,DAY(Tarih) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CekSenetVade]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CekSenetVade](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
Tarih,
VadeTarihi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Vadesi Gelmeyen Çekler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
MONTH(Tarih) as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and Tip = @Parametre1 and MONTH(VadeTarihi) = @Parametre2 and CariKodu = @Parametre3
and VadeTarihi >= GETDATE()
Group by Tip,MONTH(VadeTarihi),CariKodu,CariAdi,Tarih,VadeTarihi
Order by VadeTarihi

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Vadesi Gelmeyen Çekler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and Tip = @Parametre1 and MONTH(VadeTarihi) = @Parametre2
and VadeTarihi >= GETDATE()
Group by Tip,MONTH(VadeTarihi),CariKodu,CariAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CAST(MONTH(VadeTarihi) as nvarchar(max))+'. Ay' as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Vadesi Gelmeyen Çekler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
MONTH(VadeTarihi) as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and Tip = @Parametre1
and VadeTarihi >= GETDATE()
Group by Tip,MONTH(VadeTarihi)
Order by MONTH(VadeTarihi) asc

END
ELSE 
BEGIN

Select
Tip as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Vadesi Gelmeyen Çekler' as ParametreBaslik,
@Parametre_id as Parametre_id,
Tip as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet 
Where 1=1
and VadeTarihi >= GETDATE()
Group by Tip
Order by Tip

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CekSenetAylik]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CekSenetAylik](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
Tarih,
VadeTarihi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Çek Senet' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
MONTH(Tarih) as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and Tip = @Parametre1 and MONTH(Tarih) = @Parametre2 and CariKodu = @Parametre3
Group by Tip,MONTH(Tarih),CariKodu,CariAdi,Tarih,VadeTarihi
Order by Tarih

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Çek Senet' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and Tip = @Parametre1 and MONTH(Tarih) = @Parametre2
Group by Tip,MONTH(Tarih),CariKodu,CariAdi
Order by SUM(TutaR) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CAST(MONTH(Tarih) as nvarchar(max))+'. Ay' as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Çek Senet' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
MONTH(Tarih) as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and Tip = @Parametre1
Group by Tip,MONTH(Tarih)
Order by MONTH(Tarih) asc

END
ELSE 
BEGIN

Select
Tip as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi like '%EUR%' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Çek Senet' as ParametreBaslik,
@Parametre_id as Parametre_id,
Tip as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1
Group by Tip
Order by Tip

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CekSenet]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CekSenet](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
VadeTarihi,
SeriNo,
CiroEdilen,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE()) and Tip = @Parametre1 and Durum = @Parametre2 and CariKodu = @Parametre3
Group by Tip,Durum,CariKodu,CariAdi,VadeTarihi,SeriNo,CiroEdilen
Order by VadeTarihi asc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE()) and Tip = @Parametre1 and Durum = @Parametre2
Group by Tip,Durum,CariKodu,CariAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Durum,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Durum as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE()) and Tip = @Parametre1
Group by Durum
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
Tip,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
Tip as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_CekSenet
Where 1=1 and YEAR(Tarih) = YEAR(GETDATE())
Group by Tip
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariSiparisleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariSiparisleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2 and BelgeNo = @Parametre3
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 AND CariKodu = @Parametre1
Group by CariKodu,CariAdi,Ay,Ay2
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by CariKodu,CariAdi
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_CariSatislari]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_CariSatislari](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Satışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2 and BelgeNo = @Parametre3
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Satışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Satışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND CariKodu = @Parametre1
Group by CariKodu,CariAdi,Ay,Ay2
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Satışlar' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1
Group by CariKodu,CariAdi
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_Carirsaliyeleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_Carirsaliyeleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2 and BelgeNo = @Parametre3
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND CariKodu = @Parametre1 and Ay = @Parametre2
Group by CariKodu,CariAdi,Ay,Ay2,Tarih,BelgeNo
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
Ay as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1 AND CariKodu = @Parametre1
Group by CariKodu,CariAdi,Ay,Ay2
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Cari Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_SevkIrsaliyeleri
Where 1=1
Group by CariKodu,CariAdi
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_BolgeSiparisleri]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_BolgeSiparisleri](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and CariGrupKodu = @Parametre1 and CariKodu = @Parametre2 and BelgeNo = @Parametre3
Group by CariGrupKodu,CariKodu,CariAdi,Tarih,BelgeNo,StokKodu,StokAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and CariGrupKodu = @Parametre1 and CariKodu = @Parametre2
Group by CariGrupKodu,CariKodu,CariAdi,Tarih,BelgeNo
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Siparişleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and CariGrupKodu = @Parametre1
Group by CariGrupKodu,CariKodu,CariAdi
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariGrupKodu as Marka,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Siparisleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by CariGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_BolgeSatislari]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_BolgeSatislari](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 and CariGrupKodu = @Parametre1  and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by CariGrupKodu,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND CariGrupKodu = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by CariGrupKodu,FaturaPlasiyer,CariKodu,CariAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1 AND CariGrupKodu = @Parametre1
Group by CariGrupKodu,FaturaPlasiyer
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariGrupKodu as Bölge,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Satışları' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1
Group by CariGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_BolgeBekleyen]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_BolgeBekleyen](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
StokKodu as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and CariGrupKodu = @Parametre1 and CariKodu = @Parametre2 and BelgeNo = @Parametre3
Group by CariGrupKodu,CariKodu,CariAdi,Tarih,BelgeNo,StokKodu,StokAdi
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
Tarih,
BelgeNo,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
BelgeNo as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and CariGrupKodu = @Parametre1 and CariKodu = @Parametre2
Group by CariGrupKodu,CariKodu,CariAdi,Tarih,BelgeNo
Order by SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1 and CariGrupKodu = @Parametre1
Group by CariGrupKodu,CariKodu,CariAdi
Order by SUM(Tutar) desc

END
ELSE 
BEGIN

Select
CariGrupKodu as Marka,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'EUR' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Bölge Bekleyen' as ParametreBaslik,
@Parametre_id as Parametre_id,
CariGrupKodu as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Bekleyenler
Where 1=1
Group by CariGrupKodu
Order by SUM(Tutar) desc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_AylikSiparisler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_AylikSiparisler](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
StokKodu as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Ay = @Parametre1 and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by Ay,FaturaPlasiyer,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Ay = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by Ay,FaturaPlasiyer,CariKodu,CariAdi
Order by CAST(SUM(Tutar) as decimal(18,2)) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1 and Ay = @Parametre1
Group by Ay,FaturaPlasiyer
Order by CAST(SUM(Tutar) as decimal(18,2)) desc

END
ELSE 
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Siparişler' as ParametreBaslik,
@Parametre_id as Parametre_id,
Ay as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Siparisler
Where 1=1
Group by Ay,Ay2
Order by Ay asc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_AylikSatislar]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_AylikSatislar](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
StokAdi,
Birim,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
StokKodu as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 and Tarih = @Parametre1  and CariKodu = @Parametre2
Group by Tarih,CariKodu,CariAdi,StokKodu,StokAdi,Birim
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
CariAdi,
Tarih,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
CariKodu as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From IDW_MR_Satislar
Where 1=1 and Ay = @Parametre1
Group by CariKodu,CariAdi,Tarih
Order by Tarih desc

END
ELSE 
BEGIN

Select
Ay2 as Ay,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'' as ParametreBaslik,
@Parametre_id as Parametre_id,
Ay as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From IDW_MR_Satislar
Where 1=1
Group by Ay,Ay2
Order by LEN(Ay) asc,CAST(Ay as INT) asc

END

END
GO
/****** Object:  StoredProcedure [dbo].[IDP_AylikIrsaliyeler]    Script Date: 03/23/2023 11:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[IDP_AylikIrsaliyeler](
@Parametre_id nvarchar(max)='',
@Parametre1 nvarchar(max)='',
@Parametre2 nvarchar(max)='',
@Parametre3 nvarchar(max)='',
@Parametre4 nvarchar(max)='',
@Parametre5 nvarchar(max)='',
@Parametre6 nvarchar(max)='',
@Parametre7 nvarchar(max)=''
)
as
BEGIN
IF @Parametre7 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre6 <> ''
BEGIN

Select 0
END 
ELSE IF @Parametre5 <> ''
BEGIN

Select 0
END 
ELSE
IF @Parametre4 <> ''
BEGIN

Select 0

END 
ELSE IF @Parametre3 <> ''
BEGIN

Select
StokAdi,
SUM(Miktar) as Miktar,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
StokKodu as Parametre3,
@PArametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
1 ParametreDur
From [IDW_MR_SevkIrsaliyeleri]
Where 1=1 and Ay = @Parametre1 and FaturaPlasiyer = @Parametre2 and CariKodu = @Parametre3
Group by Ay,FaturaPlasiyer,CariKodu,CariAdi,StokKodu,StokAdi
Order by  SUM(Tutar) desc

END 
ELSE IF @Parametre2 <> ''
BEGIN

Select
CariAdi,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
@Parametre2 as Parametre2,
CariKodu as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From [IDW_MR_SevkIrsaliyeleri]
Where 1=1 and Ay = @Parametre1 and FaturaPlasiyer = @Parametre2
Group by Ay,FaturaPlasiyer,CariKodu,CariAdi
Order by CAST(SUM(Tutar) as decimal(18,2)) desc

END 
ELSE IF @Parametre1 <> ''
BEGIN

Select
FaturaPlasiyer as Plasiyer,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
@Parametre1 as Parametre1,
FaturaPlasiyer as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From [IDW_MR_SevkIrsaliyeleri]
Where 1=1 and Ay = @Parametre1
Group by Ay,FaturaPlasiyer
Order by CAST(SUM(Tutar) as decimal(18,2)) desc

END
ELSE 
BEGIN

Select
Ay2 as İsim,
CAST(SUM(CASE WHEN DovizBirimi = 'TL' THEN Tutar ELSE 0 END) as decimal(18,2)) as TL,
CAST(SUM(CASE WHEN DovizBirimi = 'USD' THEN Tutar ELSE 0 END) as decimal(18,2)) as USD,
CAST(SUM(CASE WHEN DovizBirimi = 'Euro' THEN Tutar ELSE 0 END) as decimal(18,2)) as EUR,
'Aylık Bekleyen Sevk İrsaliyeleri' as ParametreBaslik,
@Parametre_id as Parametre_id,
Ay as Parametre1,
@Parametre2 as Parametre2,
@Parametre3 as Parametre3,
@Parametre4 as Parametre4,
@Parametre5 as Parametre5,
@Parametre6 as Parametre6,
@Parametre7 as Parametre7,
0 ParametreDur
From [IDW_MR_SevkIrsaliyeleri]
Where 1=1
Group by Ay,Ay2
Order by Ay asc

END

END
GO
