--[[#create by NaiveBug^梁疯]]
local skynet = require "skynet"
require "skynet.manager"  -- import skynet.register
local CMD = {}
local SOCKET = {}
local gate
local agent = {}
local mysql
local maxaccount
local timectrl
local scenes = {}

function SOCKET.open(fd, addr)
	skynet.error("New client from : " .. addr)
	agent[fd] = skynet.newservice("agent")
	skynet.call(agent[fd], "lua", "start", { gate = gate, client = fd, watchdog = skynet.self() })
end

local function close_agent(fd)
	local a = agent[fd]
	agent[fd] = nil
	if a then
		skynet.call(gate, "lua", "kick", fd)
		-- disconnect never return
		skynet.send(a, "lua", "disconnect")
	end
end

function SOCKET.close(fd)
	print("socket close",fd)
	close_agent(fd)
end

function SOCKET.error(fd, msg)
	print("socket error",fd, msg)
	close_agent(fd)
end

function SOCKET.warning(fd, size)
	-- size K bytes havn't send out in fd
	print("socket warning", fd, size)
end

function SOCKET.data(fd, msg)
end

function CMD.start(conf)
	skynet.call(gate, "lua", "open" , conf)
end

function CMD.close(fd)
	close_agent(fd)
end
----------------------------------
function CMD.getSceneService(id)
    return scenes[id]
end
function CMD.getAgent(id)
    return agent[id]
end
function CMD.kick(fd)
    
end

----------------------------------
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "socket" then
			local f = SOCKET[subcmd]
			f(...)
			-- socket api don't need return
		else
		  print("what dogcmd "..cmd)
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd, ...)))
		end
	end)
	
	local function init()
      os.execute("mkdir log")--
      os.execute("cd log && mkdir pay")--
      --os.execute("cp log/Log.txt log/Log1.txt")
      os.rename ("log/Log.txt", "log/Log1.txt")
--      os.execute("rm log/Log.txt") --linux
--      os.execute("del .\log\Log.txt")--window
      os.remove ("log/Log.txt")
      --
      math.randomseed(os.time());
  end
  init();
  
  --skynet.newservice("mysql/testmysql")
	gate = skynet.newservice("gate")
	
	local function cb()
      --timectrl = skynet.newservice("timectrl")  --uniqueservice
      skynet.newservice("data/share")
      mysql = skynet.newservice("mysql/sql")
      maxaccount = skynet.newservice("account/maxaccount")
      --local websocket = skynet.newservice("websocket/testwebsocket")
  end
  ---------------------------------
  skynet.timeout(1,function() cb() end)
	skynet.register ".watchdog"
end)
