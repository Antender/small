include std/io.e
include std/convert.e
include std/stack.e
include std/sequence.e
global stack main_stack=stack:new()
global stack control_stack=stack:new()

export procedure dup_()
	stack:dup(main_stack)
end procedure

export procedure drop_()
	if stack:is_empty(main_stack) then
		puts(1,"Stack is empty!\n")
	else
		pop(main_stack)
	end if
end procedure

export procedure dropall()
	stack:clear(main_stack)
end procedure

export procedure dot()
	if stack:is_empty(main_stack) then
		puts(1,"Nothing to print!\n")
	else
		puts(1,pop(main_stack) & "\n")
	end if
end procedure

export procedure forth_include()
	if stack:is_empty(main_stack) then
		puts(1,"No file name on stack!\n")
	else
		source(pop(main_stack))
		tokens_length=length(tokens)
	end if
end procedure

export procedure forth_to_number()
	if stack:is_empty(main_stack) then
		puts(1,"Stack is empty!\n")
	else
		object number=to_number(pop(main_stack),-1)
		if sequence(number) then
			stack:push(main_stack,"not_a_number")
		else 
			stack:push(main_stack,number)
		end if
	end if
end procedure