include std/socket.e
include std/net/common.e

integer fid=open("client.cfg","r")
sequence buffer=gets(fid)
close(fid)

puts(1,"Enter server in IP:Port format(Enter-default):")
sequence addr = gets(0)
puts(1,"\n")

if not(is_inetaddr(addr)) then addr=buffer end if
sockets:socket client = sockets:create(sockets:AF_INET, sockets:SOCK_STREAM, 0)
if sockets:connect(client, addr) != sockets:OK then
	puts(1, "Could not connect to server.\n")
else
	buffer = ""
	while (Command[1]!='q') and (Command[1]!='s') do
		puts(1, ":")
		Command = gets(0)
		puts(1, "\n")
		sockets:send(client, Command, 0)
	end while
	sockets:close(client)
end if
puts(1,"Program stopped\n")
gets(0)

while not(Buffer=27) do
    Buffer=wait_key()
    switch Buffer do
	case 48,49,50,51,52,53,54,55,56,57 then
        if not((length(Attempt)=0)and(Buffer=48)or(find(Buffer,Attempt))) then
           	Attempt=Attempt&Buffer
           	puts(1,Buffer)
           	if length(Attempt)=4 then
           		Bulls=0
           		Cows=0
           		for J=1 to 4 do
                    I=find(Attempt[J],Numbers)
                    if I!=0 then
                        if I=J then
                        Bulls+=1
                        else
                        Cows+=1
                        end if
                    end if
           		end for
           		Attempt={}
                	NumAttempts+=1
           		if Bulls=4 then
           		    clear_screen()
                    puts(1,"WIN!!!!\nYou guessed number ")
		    puts(1,Numbers)
		    puts(1," in ")
                    print(1,NumAttempts)
                    puts(1," attempts.")
                    puts(1,'\n')
                    any_key("Press Any Key to continue...",1)
                    Buffer=27
                else
                    puts(1,{'\t',(Bulls+48),'\t','\t',(Cows+48),'\t','\t'})
                    print(1,NumAttempts)
                    puts(1,'\n')
           		end if
           	end if
        end if
	break
	case 8 then
		if length(Attempt)>0 then
			Attempt=remove(Attempt,length(Attempt),length(Attempt))
            puts(1,'\r')
            puts(1,repeat(32,(length(Attempt)+1)))
            puts(1,'\r')
            puts(1,Attempt)
		end if
	break
	case 115 then
		clear_screen()
		puts(1,"The number was ")
		puts(1,Numbers)
		puts(1,'\n')
		Buffer=27
		any_key("Press Any Key to continue...",1)
	break
    end switch
end while