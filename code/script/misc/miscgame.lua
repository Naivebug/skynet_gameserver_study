local skynet = require "skynet"
function misc._game()
    misc._Test = true
    do return end;
    local serverid = skynet.call(".watchdog", "lua", "serverid");
    misc._serverid = 0
    if serverid then misc._serverid  = serverid; end
    misc._Test = false;
    if serverid and serverid < 1000 then misc._Test = true end;
    log("misc._game",misc._Test,misc._serverid)
end
function misc.IsOnline(pid)--playid and return player agent service id
    return skynet.call(".watchdog","lua","playeragent",pid);
end
function misc.IsOnLineFD(pid) --playid and return socket fd
    return skynet.call(".watchdog","lua","playerfd",pid);
end
function misc.getSceneService(id) --playid and return socket fd
    return skynet.call(".watchdog","lua","getSceneService",id);
end
function misc.IsEquip(sid)
    return false
end 
function misc.IsItem(sid)
    return true;
end
function misc.IsHero(sid)
    return (sid >= 10000 and sid < 19999)
end
function misc.IsSoul(sid) --灵魂石
   return (sid >= 20000 and sid < 29999)
end
function misc.IsScrap(sid)
    return (sid >= 30000 and sid < 39999)
end
function misc.IsNpc(id)
    return not id or  id < define.g_nMinAccount
end
function misc.IsTest()
    if  misc._Test == nil then misc._game() end;
    return misc._Test;
end
function misc.HeroID2ScrapID(heroid)
    return heroid*10 + 20000
end
function misc.HeroID2SoulID(heroid)
    return heroid*10 + 10000
end
------
function misc.OnlineExcute(pid,info,bonlyonline)
    local agentfd = misc.IsOnline(pid)
    if agentfd then 
        skynet.call(agentfd,"lua","handle","onlineexcute",info)
    else
        if bonlyonline then return end;--bonlyonline设置为只在在线时执行
        skynet.send(".privy", "lua", "addonlineexcute",pid,info);
    end
end
function misc.OnlineCall(pid,keys,...)
    local agentfd = misc.IsOnline(pid)
    if agentfd then 
        return skynet.call(agentfd,"lua","global",keys,...)
    end
end
function misc.JudgePlatform(account)--苹台判定
    log("account",account)
    if string.sub(account,1,4) == "360|" then 
        return "360"
    elseif string.sub(account,1,3) == "uc|" then 
        return "uc"
    elseif string.sub(account,1,4) == "ios|" then 
        return "ios"
    else
        return "pc"
    end
end
