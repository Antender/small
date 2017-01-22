include std/io.e
include std/map.e
include std/sequence.e
include std/stack.e
include forth.e

global map dictionary=map:new()
global map variables=map:new()
global sequence tokens={}
global integer tokens_length=0
global integer tokens_pos=0

/* Разбиваем-собираем строку на/из инструкций*/
global function tokenize(sequence input)
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

/* Выполняем комманду*/
procedure eval(sequence tokens)
	tokens_length=length(tokens)
	tokens_pos=1
	while tokens_pos<=tokens_length do
		object token=tokens[tokens_pos]
		object instructions=map:get(dictionary,token,-1)
		if equal(instructions,-1) then
			stack:push(main_stack,token)
		else 
			for pos=1 to length(instructions) do
				call_proc(instructions[pos],{})
			end for
		end if
		tokens_pos+=1
	end while
end procedure
/*---------------------*/

/*Ввод исходника программы*/
procedure repl()
	sequence line={}
	while not equal(line,"bye\n") do
		eval(tokenize(line))
		puts(1,"euforth>")
		line=gets(0)
		puts(1,"\n")
	end while
end procedure

global procedure source(sequence file_name)
	object fd=open(file_name,"r")
	if fd=-1 then
		puts(1,"Can't load file " & file_name & " !\n")
	else
		tokens=tokens & tokenize(flatten(read_lines(fd)))
		close(fd)
	end if
end procedure
/*-------------------------------------*/


sequence args=command_line()
if length(args)<=3 then
	puts(1,"euforth main.dict main.vars [input1.file ... inputN.file]\n")
else
	load_dict(args[3])
	load_var(args[4])
	if length(args)>4 then
		for i=5 to length(args) do
			source(args[i])
		end for
		eval(tokens)
	else
		repl()
	end if
end if