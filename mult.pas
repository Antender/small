uses crt;
var a,b:integer;
begin
read(a);
b:=2;
while a>1 do
begin
if (a mod b = 0) then
begin
writeln(b);
a:=a div b;
end
else
b:=b+1;
end;
end.

 
d:=2;
while d<=(X div 2) do
begin
if X mod d =0 then begin
writeln(d); 
x:=x div d;
end else d:=d+1;
end;