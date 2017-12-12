--package.path = SERVICE_PATH.."?.lua;" .. package.path
local skynet = require "skynet"
--require "item.item"

function game_gameenter(who)
    log("--------gameenter",who.m_ID,who.m_FD,who.Name(),who.GetGrade());

--    if who.GetToday("logingift",0)==0 then 
--        who.SetToday("logingift",1)
--        local info = {sid=who.m_ID,msg="每日登录送钻石,请领取",name="系统",title="初入游戏",tm = C_game.GetSecond(),ls={state=1,canremove=1,items={[100]=50}}}
--        skynet.call(".privy", "lua", "sendmail",who.m_ID,info);
--    end
    ----
    who.EnterGame();

end


C_game = {}

function C_game.GetSecond()
    return os.time();
end
