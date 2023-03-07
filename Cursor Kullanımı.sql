DECLARE @Adi NVARCHAR(MAX), @Soyadi NVARCHAR(MAX), @Unvan NVARCHAR(MAX)
DECLARE PersonelCursor CURSOR
FOR             
SELECT Adi, Soyadi, Unvan FROM Personeller
OPEN PersonelCursor
FETCH NEXT FROM PersonelCursor INTO @Adi, @Soyadi, @Unvan
WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT @Adi + ' ' + @Soyadi + ' ' + @Unvan
    


    FETCH NEXT FROM PersonelCursor INTO @Adi, @Soyadi, @Unvan
  END
CLOSE PersonelCursor
DEALLOCATE PersonelCursor
