include std/stack.e

function Priority(integer Symbol)
	switch Symbol do
    	case '*', '/' then
        	return 3
    	case '-','+' then
        	return 2
    	case ')' then
        	return 1
        case '(' then
        	return 0
	end switch
end function

/* Описание и ввод начальных данных */
puts(1,"Enter infix string:") 
stack Operations = stack:new(FILO)                     
sequence IString=gets(0)
sequence OString={}
puts(1,"\n")

for i = 1 to length(IString) do
      if IString[i]=')' then            
      	while top(Operations)!='(' do        
        	OString=append(OString,pop(Operations))  
		end while
        pop(Operations)
      elsif ((IString[i]>='A') and (IString[i]<='z')) or ((IString[i]>='0') and (IString[i]<='9')) then       
          OString=append(OString,IString[i])        
      elsif IString[i]='(' then                        
          push(Operations, '(')           
      elsif (IString[i]='+') or (IString[i]='-') or (IString[i]='/') or (IString[i]='*') then                            
        if is_empty(Operations)=1 then                    
            push(Operations, IString[i])        
        elsif Priority(top(Operations))<Priority(IString[i]) then                  
            push(Operations, IString[i])      
        else                              
        	while (is_empty(Operations)=0) and (Priority(top(Operations))>=Priority(IString[i])) do
              	OString=append(OString,pop(Operations))          
        	end while
        	push(Operations, IString[i])
      	end if
	   end if
end for
for i=1 to size(Operations) do
OString=append(OString,pop(Operations))                          
end for
puts(1,OString) 
gets(0)