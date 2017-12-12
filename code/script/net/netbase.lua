require "gamelogin"
local protobuf = require "protobuf"
local protocol = require "protocol"
-------------c2s------------
local netbase = {}

function netbase.C2SLogin(who,buff)
    local data = protobuf.decode("Protocol.C2SLogin",buff)
    log("netbase.C2SLogin data:",data);
    local info = {id = 0,accountname = data.account,pwd = data.pwd,version={1,0,1}}
    g_gameLogin.CheckLoginEnter(who,info)
end

------------handle--------------
local handle = {
  [1]=netbase.C2SLogin,
}
function netbase.handle(sid,buff)
    local fun = handle[sid];
    if fun ~= nil then 
        fun(GetPlayer(),buff)
    else
        warn("---netbase don't handle--",sid)
    end
end
------------s2c--------------
function netbase.S2CHello()
    local tbl = {
        randseed = misc.RandInt(10000,define.g_nMaxValue),
        servertime = misc.Now(),
    }
    local stringbuffer = protobuf.encode("Protocol.S2CHello",tbl)
    sendPackage(protocol.S2C_Base,1,stringbuffer)
end
function netbase.S2CBaseInfo(who)
  local tbl = {
        id = who.m_ID,
        name = who.GetName(),
        servernumber = 0,
        shape = 1001,
        lv = who.GetGrade(),
        exp = who.GetExp(),
        gold = who.GetGold,
        gem = who.GetDiamond,
    }
    local stringbuffer = protobuf.encode("Protocol.S2CLoginSuccess",tbl)
    sendPackage(protocol.S2C_Base,2,stringbuffer)
end
------------------------------
return netbase
