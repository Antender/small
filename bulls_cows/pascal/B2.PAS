program Bulls_and_cowsv02 ;
uses crt ;
type MA= array [1..4,1..2] of byte ;
var chislo:MA ;
    command,temp:string;
    ishch,valerror,i:integer;
    c:char;
    wrong:boolean;
    f:text;
procedure help;
begin
     writeln ;
     writeln ('Commands - n(ew),h(elp),a(bout),r(ules),s(poil),e(xit)');
     writeln ('input 4-digit number to try it');
     writeln ;
end;
procedure about;
begin
	writeln;
	writeln('Program created by Anton Volokitin');
	writeln;
end;
procedure rules;
begin
	writeln;
	writeln('In development');
	writeln;
end;
procedure init(var chislo:MA);
var i,j:byte;
    equiv:boolean;
begin
chislo[1,1]:=random(9)+1;
FOR i:=2 TO 4 do
begin
	equiv:=TRUE;
	WHILE equiv=TRUE do
	begin
		equiv:=FALSE;
		chislo[i,1]:=random(10);
		FOR j:=1 TO i-1 do IF chislo[i,1]=chislo[j,1] then equiv:=TRUE ;
	end;
end;
writeln;
writeln('New number created');
writeln;
end;
procedure engine(var ishch:integer;var chislo:MA;var f:text);
var i,j,bulls,cows:byte;
    a:integer;
    equiv:boolean;
begin
FOR i:=1 to 4 do
begin
	a:=1;
	for j:=1 to 4-i do a:=a*10;
	chislo[i,2]:=ishch div a;
	ishch:=ishch-chislo[i,2]*a;
end;
equiv:=FALSE;
FOR i:=2 TO 4 do
	FOR j:=1 TO i-1 do
	begin
		IF chislo[i,2]=chislo[j,2] then equiv:=true;
	end;
IF equiv=TRUE then
begin
clrscr;
writeln ('Some numbers are equivalent')
end
ELSE
begin
	bulls:=0;
	cows:=0;
	FOR i:=1 TO 4 do
		FOR j:=1 TO 4 do
		begin
			IF 	chislo[i,1]=chislo[j,2] then
				IF i=j then bulls:=bulls+1
				ELSE cows:=cows+1 ;
		end;
	append(f);
	for i:=1 to 4 do
	begin
	write(f,chislo[i,2]);
	end;
	writeln(f,' bulls:',bulls,' cows:',cows);
	close(f);
	clrscr;
	If bulls=4 then 
	begin
	writeln('You win');
	rewrite(f);
	close(f);
	end;
end;
end;

begin
	clrscr;
        randomize;
	Writeln (' Bulls and cows v0.2 ');
	assign(f,'list.txt');
	rewrite(f);
	close(f);
	help;
	init (chislo);
	command:='';
        WHILE command[1]<>'e' do
	begin
		writeln ('Game menu');
		readln(command);
                wrong:=true;
		IF length(command)<>0 then
		begin
			val(command,ishch,valerror);
			If valerror=0 then if length(command)=4 then
                        begin
                        engine(ishch,chislo,f);
		       reset(f);
		       writeln('Previvious results:');
		       while eof(f)=false do
		       begin
			readln(f,temp);
			writeln(temp);
		       end;
		       writeln;
		       close(f);
                        wrong:=false;
                        end;
                        c:=command[1];
                        If c='h' then
                        begin
                        help;
                        wrong:=false;
                        end;
                        If c='a' then
                        begin
                        about;
                        wrong:=false;
                        end;
			If c='r' then
                        begin
                        rules;
                        wrong:=false;
                        end;
			If c='n' then
                        begin
                        init(chislo);
                        wrong:=false;
                        end;
			If c='s' then
		       begin
		       writeln;
		       write('Chislo: ');
		       for i:=1 to 4 do write(chislo[i,1]);
		       writeln;
		       wrong:=false;
		       end;
			if c='e' then wrong:=false;
                end;
                If wrong=true then writeln ('Wrong command');
	end;
	erase(f);
end.
