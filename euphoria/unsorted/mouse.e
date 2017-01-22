--Frame enum
enum MACRO,PARAM,LOOP,POS,OFF
--Sequence of chars
sequence PROG
--Sequence of integer
sequence DEFINITIONS
--Call stack, integers
sequence CALSTACK
--Stack of frames
sequence STACK -- Consists of frames
--Sequence of integers
sequence DATA 
atom CAL, CHPOS, LEVEL, OFFSET, PARNUM, PARBAL, TEMP,CH

procedure GETCHAR
      CHPOS+=1
      CH=PROG[CHPOS]
end procedure

procedure PUSHCAL (integer DATUM)
      CAL+=1
      CALSTACK[CAL]=DATUM
end procedure

function POPCAL
      return CALSTACK[CAL] 
      CAL-=1
end function

procedure PUSH (sequence TAGVAL) -- first 3 from frame
      LEVEL+=1
      STACK[LEVEL][MACRO..LOOP]=TAGVAL
      STACK[LEVEL][POS]=CHPOS
      STACK[LEVEL][OFF]=OFFSET
end procedure

procedure POP
      CHPOS=STACK[LEVEL][POS]
      OFFSET=STACK[LEVEL][OFF]
      LEVEL-=1
end procedure

procedure SKIP (integer LCH, integer RCH)
integer CNT=1
	repeat
         GETCHAR
         if CH = LCH
            then CNT+=1
         else if CH = RCH
            then CNT-=1
      until CNT = 0
end procedure

procedure LOAD
integer THIS, LAST, CHARNUM
      for CHARNUM := 1 to 26 do DEFINITIONS[CHARNUM] := 0;
      CHARNUM := 0; THIS := ' ';
      repeat
         LAST := THIS; read(THIS);
         CHARNUM := CHARNUM + 1; PROG[CHARNUM] := THIS;
         if (THIS in ['A' .. 'Z']) and (LAST = '$')
            then DEFINITIONS[NUM(THIS)] := CHARNUM
      until (THIS = '$') and (LAST = '$')
   end;

begin
   LOAD;
   CHPOS := 0; LEVEL := 0; OFFSET := 0; CAL := 0;
   repeat
      GETCHAR;
      case CH of

         ' ', ']', '$' : ;

         '0','1','2','3','4','5','6','7','8','9' :
                begin
                   TEMP := 0;
                   while CH in [ '0' .. '9' ] do
                      begin
                         TEMP := 10 * TEMP + VAL(CH); GETCHAR
                      end;
                   PUSHCAL(TEMP); CHPOS := CHPOS - 1
                end;

         'A','B','C','D','E','F','G','H','I','J','K','L','M',
         'N','O','P','Q','R','S','T','U','V','W','X','Y','Z' :
                PUSHCAL(NUM(CH) + OFFSET);

         '?'  : begin
                   read(TEMP); PUSHCAL(TEMP)
                end;

         '!'  : write(POPCAL : 1);

         '+'  : PUSHCAL(POPCAL + POPCAL);

         '-'  : begin
                   TEMP := POPCAL;
                   PUSHCAL(POPCAL - TEMP);
                end;

         '*'  : PUSHCAL(POPCAL * POPCAL);

         '/'  : begin
                   TEMP := POPCAL;
                   PUSHCAL(POPCAL div TEMP)
                end;

         '.'  : PUSHCAL(DATA[POPCAL]);

         '='  : begin
                   TEMP := POPCAL;
                   DATA[POPCAL] := TEMP
                end;

         '"'  : repeat
                   GETCHAR;
                   if CH = '!'
                      then writeln
                   else if CH <> '"'
                      then write(CH)
                until CH = '"';

         '['  : if POPCAL <= 0 then SKIP('[',']');

         '('  : PUSH(LOOP);

         '^'  : if POPCAL <= 0
                   then
                      begin
                         POP; SKIP('(',')')
                      end;

         ')'  : CHPOS := STACK[LEVEL].POS;

         '#'  : begin
                   GETCHAR;
                   if DEFINITIONS[NUM(CH)] > 0
                      then
                         begin
                            PUSH(MACRO);
                            CHPOS := DEFINITIONS[NUM(CH)];
                            OFFSET := OFFSET + 26
                         end
                      else SKIP('#',';')
                end;

         '@'  : begin
                   POP; SKIP('#',';')
                end;

         '%'  : begin
                   GETCHAR; PARNUM := NUM(CH); PUSH(PARAM);
                   PARBAL := 1; TEMP := LEVEL;
                   repeat
                      TEMP := TEMP - 1;
                      case STACK[TEMP].TAG of
                         MACRO : PARBAL := PARBAL - 1;
                         PARAM : PARBAL := PARBAL + 1;
                         LOOP :
                      end
                   until PARBAL = 0;
                   CHPOS := STACK[TEMP].POS;
                   OFFSET := STACK[TEMP].OFF;
                   repeat
                      GETCHAR;
                      if CH = '#'
                         then
                            begin
                               SKIP('#',';'); GETCHAR
                            end;
                      if CH = ',' then PARNUM := PARNUM - 1
                   until (PARNUM = 0) or (CH = ';');
                   if CH = ';' then POP
                end;

         ',',';'  : POP

      end
   until CH = '$'
end.
