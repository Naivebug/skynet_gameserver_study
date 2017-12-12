--[[#create by NaiveBug^梁疯]]
package.path = "./script/?.lua;" .. package.path
local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socket = require "skynet.socket"
require "protobufinit"
require "base/baseheader"
require "misc/misc"
local define = require "define.define"
local sharedata = require "skynet.sharedata" --这个需要延迟一点调用,因为他还需要初始化,并不能马上用
local netcommon = require "net/netcommon"
local WATCHDOG
local host
local send_request

local CMD = {}
local client_fd
local player 


function CMD.Init()
    log("agetn inti 11",skynet.self())
    local _memery1=collectgarbage("count")
    --[[
    ]]
    player = require "player.player"
    --
end


function getFD() 
  return client_fd
end
function GetPlayer()
  return player
end
local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
  unpack = function(msg, sz) 
     return msg, sz
  end,
	dispatch = function (_, _, msg, sz)
	   local result = skynet.tostring(msg,sz)
	   --send_package(result)
	   netcommon.netPackCommon(result);
	end
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	client_fd = fd
	GetPlayer().SetFD(fd)
	define.sharedata = sharedata;
	netcommon.reset()
	skynet.fork(function()
      skynet.sleep(5)
      netcommon.initBase()
      --local hero = sharedata.deepcopy( "mkdata_hero",101101276)
  end)
	skynet.call(gate, "lua", "forward", fd)
	
end

function CMD.disconnect()
	-- todo: do something before exit
	GetPlayer().SocketClose()
	skynet.exit()
end

function CMD.Change2Net(...)
    netcommon.netAgentChange(...)
end


skynet.start(function()
  CMD.Init();
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
