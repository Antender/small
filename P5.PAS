program p5;
uses crt;
type
var punkt:integer;
    fl:boolean;

procedure otris(var punkt:integer);
var c:char;
begin
     fl:=false;
     punkt:=1;
     Gotoxy(21,5);
     write('<');
     Gotoxy(5,5);
     writeln    ('浜様様様様様様様融');
     writeln('    �Dobavit dannye  �');
     writeln('    把陳陳陳陳陳陳陳超');
     writeln('    �Udalit  dannye  �');
     writeln('    把陳陳陳陳陳陳陳超');
     writeln('    �Vyvod   dannyh  �');
     writeln('    把陳陳陳陳陳陳陳超');
     writeln('    �Vyhod           �');
     writeln('    藩様様様様様様様夕');
     while fl=false do
     begin
          c:=Readkey;
          If (ord(c)=24) and (punkt<>1) then
          begin
               Gotoxy(21,punkt*2+4);
               Write(' ');
               punkt:=punkt-1;
               Gotoxy(21,punkt*2+4);
               write('<');
          end
          else if (ord(c)=25) and (punkt<>24) then
          begin
               Gotoxy(21,punkt*2+4);
               Write(' ');
               punkt:=punkt+1;
               Gotoxy(21,punkt*2+4);
               write('<');
          end
          else if (ord(c)=13) then fl:=true;
     end;
end;
begin
     fl:=false;
     punkt:=1;
     while fl=false do
     begin
          Clrscr;
          otris(punkt);
          case punkt of
          1:
          2:
          3:
          4:
          end;
     end;
end.