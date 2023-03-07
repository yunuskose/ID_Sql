
ALTER FUNCTION [dbo].[Split](@String varchar(8000), @Delimiter char(1))
returns @Results TABLE (Sno int,Items varchar(20))
as
   begin
   declare @index int
   declare @slice varchar(20)
   declare @sno int

   select @index = 1
   if @String is null return
   
   set @sno = 0

   while @index != 0
       begin
        select @index = charindex(@Delimiter,@String)
          if @index !=0
           select @slice = left(@String,@index - 1)
          else
             select @slice = @String
            
            set @sno = @sno + 1
          insert into @Results(sno,Items) values(@sno,@slice)
          select @String = right(@String,len(@String) - @index)
          if len(@String) = 0 break
       end    return
end
