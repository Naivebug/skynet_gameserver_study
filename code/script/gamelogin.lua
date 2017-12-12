package.path = SERVICE_PATH.."?.lua;" .. package.path

require "errorcode"
local define= require "define.define"
local skynet = require "skynet"
local accont = require "account.account"
local protocol = require "protocol"
--require "mysql.sql"

--local publogin = require "publogin"
function creategamelogin()--create game login
    local self = {}--publogin.createlogin();--base public gamelogin
    function self.init()
        self.m_version = {1,0,1}
    end
    function self.CheckLoginEnter(who,info)
        log("self.CheckLoginEnter11");
        if self.CampareVersion(info) then 
            return
        end
        if who.m_nLogin==define.e_login.ok then--
            return;
        end
        log("self.CheckLoginEnter22");
        if self.CheckGMLogin(info) then 
            return;
        end
        if not self.IsCanLogin() then
            return;
        end
        log("self.CheckLoginEnter33");
        --leo test
--        local sql = "select * from cats order by id asc"
--        local rz = skynet.call(".sql", "lua", "querycb",sql);
--        log("self.CheckLoginEnter44",rz);
        ---end

        accont.checkAccount(who,info);

    end
    function self.CheckGMLogin(info)
        local account = info['accountname']
        local bcreate = false;
        log("CheckGMLogin00");
        if string.sub(account,1,1) == "@" then
            bcreate = true;
            account = string.sub(account,2);
            log("CheckGMLogin11");
        end
        if string.sub(account,1,1) == '#' then 
            log("CheckGMLogin22");
            account = string.sub(account,2);
            self.CreateRole(account,info);
            return true;
        end
        return false;
    end
    function self.CampareVersion(info)
        local fd = info.fd;
        local clienversion = info['version']
        if clienversion[1]<self.m_version[1] or  clienversion[2]<self.m_version[2] then 
            self.SendErrorCode(fd, 3)
            return true
        end
        if clienversion[3]<self.m_version[3] then 
            self.SendErrorCode(fd, 2)
            return true
        end
        return false
    end
    function self.SendErrorCode(fd,errid)
        log("----SendErrorCode:",errid)
--        C_net.PackPrepare(protocol.S2C_ErrorCode);
--        C_net.AddPackI(errid,4);
--        C_net.SendPack(fd);
    end
    function self.IsCanLogin()
        local rz=skynet.call(".maxaccount", "lua", "IsCanLogin");
        log("self.isCanLogin++",rz);
        return  rz
    end
    function self.CreateRole(account,info)
        log("self.CreateRole00",account,info);
        
    end
    function self.WriteRole2DB(self,uid)
    end

    self.init();
    return self
end

g_gameLogin = creategamelogin()

