package.path = SERVICE_PATH.."?.lua;" .. package.path
local skynet = require "skynet"
require "skynet.manager"  -- import skynet.register
require "misc.misc"
local self = {}
--local self = {}

function self.init()
    self.m_nCanLogin = false;
    self.m_nMaxRoleID = 10000;
    log('----maxaccount',self.i);
    local sql = "SELECT MAX(rl_sRoleID) FROM tbl_account;"
    local rz = skynet.call(".sql", "lua", "querycb",sql);
    log("maxaccount rz",rz,#rz[1],rz[1]);
    if rz[1] ~= nil and rz[1]["MAX(rl_sRoleID)"]~=nil then
        self.m_nMaxRoleID = rz[1]["MAX(rl_sRoleID)"];
    end
    local sql = "SELECT MAX(rl_uID) FROM tbl_player;"
    local rz_player = skynet.call(".sql", "lua", "querycb",sql);
    log("++++maxaccount rz",#rz_player[1],rz_player[1]);
    if rz_player[1] ~= nil and  rz_player[1]["MAX(rl_uID)"]~=nil and self.m_nMaxRoleID < rz_player[1]["MAX(rl_uID)"] then
        self.m_nMaxRoleID = rz_player[1]["MAX(rl_uID)"];
    end
    self.m_nCanLogin  = true; 
    log("----------self.m_nMaxRoleID",self.m_nMaxRoleID);

end

function self.IsCanLogin()
    log("---iscanlogin",self.m_nCanLogin);
    return self.m_nCanLogin;
end
function self.GetMaxRoleID()
    self.m_nMaxRoleID  = self.m_nMaxRoleID + 1;
    log("GetMaxRoleID()",self.m_nMaxRoleID);
    return self.m_nMaxRoleID;
end
function self.OnlyGetMaxRoleID()
    return self.m_nMaxRoleID;
end


skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = self[command]
		skynet.ret(skynet.pack(f(...)))
	end)
    self.init();--init cmd
    skynet.register ".maxaccount"
end)
