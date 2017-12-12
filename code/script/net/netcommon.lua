local skynet = require "skynet"
local socket = require "skynet.socket"
local protobuf = require "protobuf"
local protocol = require "protocol"
local nets  = {}
local netcommon = {}
local netbase = require "net.netbase"
local netplayer = require "net.netplayer"
local netpet = require "net.netpet"
local netchat = require "net.netchat"
----
local netmodules = {
    netbase=netbase,
    netplayer = netplayer,
    netpet = netpet,
}
local handle = {
    [protocol.C2S_Base] = netbase.handle,
    [protocol.C2S_Player] = netplayer.handle,
    [protocol.C2S_Pet] = netpet.handle,
    [protocol.C2S_Chat] = netchat.handle,
}
g_bNetEncry = false;--Demo关闭加密
local encrypos1,encrypos2,sendpos1,sendpos2=0,0,0,0 --加密偏移密码标识
-----
function netcommon.netPackCommon(result)
    if g_bNetEncry then 
      encrypos1,encrypos2,result = netencry.recvdecode(encrypos1,encrypos2,result)
    end
    local bigid = string.byte(result,1,1)--math.floor(string.sub(result,1,1))
    local smallid = string.byte(result,2,2)--math.floor(string.sub(result,2,2))
    local msg = string.sub(result,3)
    local fun = handle[bigid]
    log("--netcommon bigid0-",bigid,smallid,encrypos1,encrypos2)
    if fun ~= nil then 
        --log("--netcommon bigid-",bigid,smallid)
        fun(smallid,msg)
    else 
        warn("--warn--netcommon bigid no config: ",bigid,smallid)
    end
end
----
function netcommon.sendPackage(bigid,smallid,pack)
    log("==sendPackage:",getFD(),bigid,smallid)
    local str = string.char(bigid,smallid) .. pack
    --log("str0",string.len(str),str);
    if g_bNetEncry then 
        sendpos1,sendpos2,str = netencry.sendenctry(sendpos1,sendpos2,str)
    end
    --log("==sendPackage1:",sendpos1,sendpos2)
    local package = string.pack(">s2", str)
    socket.write(getFD(), package)
end
sendPackage = netcommon.sendPackage 
function netcommon.reset()
    encrypos1,encrypos2,sendpos1,sendpos2=0,0,0,0 --new connet reset
end
function netcommon.initBase() --新FD连入,new connet
    netbase.S2CHello();
end
function netcommon.netAgentChange(name,funcname,...) 
    log("netAgentChange",name,funcname,...)
    netmodules[name][funcname](...)
end
-----------------------------
return netcommon

