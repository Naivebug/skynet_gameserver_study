local skynet = require "skynet"
local protobuf = require "protobuf"
local protocol = require "protocol"
-------------c2s------------
local netchat = {}

function netchat.C2SChatGM(who,buff)
    local data = protobuf.decode("Protocol.C2SChatGM",buff)
    log("netchat.C2SChatGM data:",data)
    netchat.S2CChatGM(data)
    local nettest = require "net.nettest.netest"
    nettest.GM(who,data.gm)
end

function netchat.Test(who,buff) 
    log("========netchat.Test")
    local netwar = require "net.netwar"
    netwar.TestWarPve(who)
end
------------handle--------------
local handle = {
  [1]=netchat.C2SChatGM,
  
  [255]=netchat.Test,
}
function netchat.handle(sid,buff)
    local fun = handle[sid];
    if fun ~= nil then
        fun(GetPlayer(),buff)
    else
        warn("---netchat don't handle--",sid)
    end
end
---------------------
function netchat.S2CChatGM(info)
    local tbl = {
        gm = info.gm
    }
    local stringbuffer = protobuf.encode("Protocol.S2CChatGM",tbl)
    sendPackage(protocol.S2C_Chat,1,stringbuffer)
end
------------------------------
return netchat
