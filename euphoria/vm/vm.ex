include std/io.e
include std/map.e
include std/sequence.e
include not_found.e

global map dictionary=map:new()
global sequence tokens={}
global integer tokens_length=0
global integer tokens_pos=0

/* Разбиваем-собираем строку на/из инструкций*/
function tokenize(sequence input)
	return split_any(input," \t\n\r",0,1)
end function

function detokenize(sequence input)
	return join(input, " ")
end function
/*-------------------*/

/*Загрузить словарь из файла*/
function routine_id_each(object value,object data)
	return routine_id(value)
end function

function update_dictionary(object key,object value,object data,object code)
	sequence new_value=apply(value,routine_id("routine_id_each"),{})
	map:put(dictionary,key,new_value)
	return 0
end function

procedure load_dict(sequence file_name)
	map input=map:load_map(file_name)
	map:for_each(input, routine_id("update_dictionary"))
end procedure
/*----------------------------*/

/*Очищаем команды для  выполнения*/
procedure flush_tokens()
	sequence tokens={}
	integer tokens_length=0
	integer tokens_pos=0
end procedure
/*-----------------------------------*/

/* Выполняем комманду*/
procedure eval(sequence token)
	object instructions=map:get(dictionary,token,-1)
	if equal(instructions,-1) then
		not_found(token)
	else 
		for pos=1 to length(instructions) do
			call_proc(instructions[pos],{})
		end for
	end if
end procedure
/*---------------------*/

/*Ввод исходника программы*/
procedure repl()
	puts(1,"euforth>")
	sequence line=gets(0)
	puts(1,"\n")
	while not equal(line,"BYE\n") do
		tokens=tokenize(line)
		tokens_length=length(tokens)
		for tokens_pos=1 to tokens_length do
			eval(tokens[tokens_pos])
		end for
		puts(1,"euforth>")
		line=gets(0)
		puts(1,"\n")
	end while
end procedure

procedure interpret_file(sequence file_name)
	object fd=open(file_name,"r")
	if fd=-1 then
		puts(1,"\n Can't load file to interpret: " & file_name & "\n")
	else
		while not fd=EOF do
			tokens=tokens & tokenize(gets(fd))
		end while
		tokens_length=length(tokens)
		for tokens_pos=1 to tokens_length do
			eval(tokens[tokens_pos])
		end for
	end if
end procedure
/*-------------------------------------*/

load_dict("main.dict")
repl()