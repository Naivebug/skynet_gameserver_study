local skynet = require "skynet"
require "game"


local self = {}

function self.isCanLogin()
    return true;
end

function self.checkAccount(who,info)
    local account = info['accountname']
    local sql = string.format("SELECT rl_sRoleID FROM tbl_account WHERE rl_sAccount = \'%s\';" , account)
    local rz = skynet.call(".sql", "lua", "querycb",sql);
    if misc.isEmpty(rz) then
        self.insertAccount(who,info);
    else
        info.id = rz[1]["rl_sRoleID"]
    end
    self.PreapreLoadData(who,info);    
end 
function self.insertAccount(who,info)
    local maxid = skynet.call(".maxaccount", "lua", "GetMaxRoleID");
    local account = info['accountname']
    log("self.insertAccount",maxid,account);
    --local sql = string.format("SELECT rl_sRoleID FROM tbl_account WHERE rl_sAccount = \'%s\';" , account)
    --local rz = skynet.call(".sql", "lua", "querycb",sql);
    local function insert2account()
        local sql = string.format("INSERT INTO `tbl_account` (`rl_sAccount`,    `rl_sRoleID`)  VALUES (\'%s\',    %d)" ,account, maxid);
        log("sql insertaccount",sql);
        skynet.call(".sql", "lua", "query",sql);
    end
    insert2account();
    local function createrole()
        local CreatePlayerSql = string.format("INSERT INTO `tbl_player` (`rl_uID`,    `rl_sName`,    `rl_uSex`,    `rl_uShape`) VALUES (%d,    \'%s\',    %d,    %d)",maxid,maxid,1,0);
        skynet.call(".sql", "lua", "query",CreatePlayerSql);
        local CreateRoleSql = string.format("INSERT INTO `tbl_role` (`rl_uID`,    `rl_sData`) VALUES (%d,    '' )",maxid);
        skynet.call(".sql", "lua", "query",CreateRoleSql);
        who.SetCreate();
    end
    info.id = maxid
    createrole()
    
end
function self.PreapreLoadData(who,info)
    --log("who,info",who)
    log("infoid",info.id);
    who.Init(info.id)
    local rz = self.IsReplace(who,info);
    if rz >0 then --被顶号了
        return 
    end
    self.LoadPlayerData(who,info)
end
function self.IsReplace(who,info)
    do return 0 end -- leo need code
    local id = info.id
    log("isrepace id",id);
    local rz = skynet.call(".watchdog", "lua", "checkreplace",id,who.GetFD());
    if rz >0 then
        --关闭这个FD
        skynet.call(".watchdog", "lua", "socket","close",rz);
    end
    return rz
end
function self.LoadPlayerData(who,info)
    --加载privy
    who.PrivyPrepare()
    --
    for k,sobj in pairs(who.m_DBList) do
        log("self.LoadPlayerData m_DBList",k);
        sobj.Prepare()
    end 
    for k,sobj in pairs(who.m_WhenUpdateSaveList) do
        log("self.m_WhenUpdateSaveList",k);
        sobj.Prepare()
    end
    log("---game will enter")
    self.EnterGame(who);
end
function self.EnterGame(who)
    game_gameenter(who);
end


return self
