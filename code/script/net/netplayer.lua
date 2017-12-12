require "gamelogin"
local protobuf = require "protobuf"
local protocol = require "protocol"
-------------c2s------------
local netplayer = {}

--//c2s子协议号:5~请求修改玩家名字
function netplayer.C2SPlayerChangeName(who,buff)
    local data = protobuf.decode("Protocol.C2SPlayerChangeName",buff)
    who.ChangeName(data.name) 
end


------------handle--------------
local handle = {
    [1]=netplayer.C2SPlayerChangeName,
}

function netplayer.handle(sid,buff)
    local fun = handle[sid];
    if fun ~= nil then 
        fun(GetPlayer(),buff)
    else
        warn("---netplayer don't handle--",sid)
    end
end

------------s2c--------------
----//s2c子协议号1,更新玩家的经验值
function netplayer.S2CPlayerExp(exp,lv)
    local stringbuffer = protobuf.encode("Protocol.S2CPlayerExp",{exp = exp, lv = lv})
    sendPackage(protocol.S2C_Player,1,stringbuffer)
end

----//s2c子协议号2,更新玩家的金币
function netplayer.S2CPlayerGold(gold)
    local stringbuffer = protobuf.encode("Protocol.S2CPlayerGold",{gold = gold})
    sendPackage(protocol.S2C_Player,2,stringbuffer)
end

----//s2c子协议号3,更新玩家的钻石
function netplayer.S2CPlayerDiamond(gem)
    local stringbuffer = protobuf.encode("Protocol.S2CPlayerDiamond",{gem = gem})
    sendPackage(protocol.S2C_Player,3,stringbuffer)
end

----//s2c子协议号5,返回玩家名字
function netplayer.S2CPlayerChangeName(name)
    local stringbuffer = protobuf.encode("Protocol.S2CPlayerChangeName",{name = name})
    sendPackage(protocol.S2C_Player,5,stringbuffer)
end


------------------------------
return netplayer
