package.path = SERVICE_PATH.."?.lua;" .. package.path
local skynet = require "skynet"
require "db.dbmgr"
require "playersave.propdata"
require "base.only"
require "playersave.otherdb"
require "player.playerex"
require "playersave.playerbasedbheader"
require "npc.herodb"

local netbase = require "net.netbase"

local skynet = require "skynet"
--
local _playerothersave = require "player.playerothersave"
--
local define = require "define.define"
local sqlstatement = require "misc.sqlstatement"
local netpet = require "net.netpet"
local netplayer = require "net.netplayer"


local self = CreatePlayerSelf()
_playerothersave.CreateOtherSave(self)
function self.Init(pid)
    self.m_ID = pid;
    --self.m_FD = self.m_FD;
    self.m_Info = {}
    self.m_DBList = { --#Save
        --createdbmgr(createpropdata(self.m_ID), g_LoadRoleBaseData, g_SaveRoleBaseData),
        CPlayInfoDataBaseMgr(create_savepropdata(self.m_ID), nil, sqlstatement.g_SaveRolePlayerSqlBaseInfo),
    }

    self.m_BaseData = createpropdata(self.m_ID)--self.BaseData
    self.m_Today = only_CToday(self.m_ID)
    self.m_Week = only_CWeek(self.m_ID)
    self.m_HeroDB = herodb_createdata(self.m_ID)--herodb_createdata(self.m_ID);
    --self.m_EquipDB = equipdb_createdata(self.m_ID)
    --self.m_TaskDB = taskdb_createdata(self.m_ID)
    self.m_OtherDB = otherdb_createotherdb(self.m_ID)
    --self.m_BuildDB = builddb_createdata(self.m_ID);
    self.m_WhenUpdateSaveList = { --
        CDataUpdateSaveMgr(self.m_BaseData, sqlstatement.g_LoadRoleBaseData, sqlstatement.g_SaveRoleBaseData),
        CDataUpdateSaveMgr(self.m_Today, sqlstatement.g_LoadRoleTodayData, sqlstatement.g_SaveRoleTodayData),
        CDataUpdateSaveMgr(self.m_Week, sqlstatement.g_LoadRoleWeekData, sqlstatement.g_SaveRoleWeekData),
        --CDataUpdateSaveMgr(self.m_EquipDB, sqlstatement.g_LoadEquipData, sqlstatement.g_SaveEquipData),
        --CDataUpdateSaveMgr(self.m_TaskDB, sqlstatement.g_LoadTaskData, sqlstatement.g_SaveTaskData),
        CDataUpdateSaveMgr(self.m_OtherDB, sqlstatement.g_LoadOtherData, sqlstatement.g_SaveOtherData),
        CInertTableUpdateSaveMgr(self.m_HeroDB, "tbl_hero"),
    }
     --CDataUpdateSaveMgr(self.m_BuildDB, sqlstatement.g_LoadBuildData, sqlstatement.g_SaveBuildData),
    self.m_nLogin = define.e_login.off;
    self.m_nSaveTime = 0;
    self.m_nGM = 0;
    self.SetHeart()
end
--##########################agent#######################
function self.SetAgent(agent)
    self.m_Agent = agent;
end 
function self.GetID()
    return self.m_ID
end
function self.SocketClose()
    log("SocketClose")
    local _memery4=collectgarbage("count")
    log("---memery4",_memery4);--内存
    
    self.m_Agent =nil
    self.m_FD = 0
    self.Save(true);
    self.m_nLogin = define.e_login.off--
    self.OffLine()
end
function self.SendDisconnect()
    skynet.send(".watchdog","lua","kick",self.m_FD) --
end
function self.GetAgent()
    return self.m_Agent;
end
function self.IsLoadOK()
    return self.m_nLogin  == define.e_login.ok
end
function self.SetFD(fd)
    self.m_FD = fd;
    self.m_nLogin = define.e_login.off;
end
function self.GetFD()
    return self.m_FD
end
function self.GetSocketID()
    return self.GetFD();
end
--##########################save#######################
function self.AutoSave() 
    if self.m_FD==0 or  self.m_nLogin ~= define.e_login.ok  then return end;
    if self.m_nSaveTime  == 0 then self.m_nSaveTime = misc.RandInt(100*120,100*300); end--一分钟到五分钟之间,第一次存的时候,打乱他们的时间
    skynet.timeout(self.m_nSaveTime, function()  --5分钟存一次
        self.Save()
        self.m_nSaveTime = 100*300;--之后就保存5分钟存一次
        --leo test
--        if misc.IsTest() then 
--            self.m_nSaveTime = 100*60 --暂时是15秒保护一次
--        end
        --end;
        self.AutoSave()
    end)
end
function self.Save(boffline) --
    log("-------save game",self.m_ID);
    if self.m_nLogin~=define.e_login.ok then return end;
    if not self.m_BaseData then return end;
    for k,sobj in pairs(self.m_DBList) do
        sobj.Save();
    end
    for k,sobj in pairs(self.m_WhenUpdateSaveList) do
        log("k,sobj",k)
        sobj.UpdateSave();
    end
    skynet.send(".privy","lua","save",self.m_ID) --保存离线数据
    --
    if not boffline and self.m_FD > 0 then 
        local bkick = not self.JudgeHeart() 
        if bkick then 
            self.SendDisconnect()
        end
    end
end
--##########################basedata#######################
function self.Set(key,value)
    self.m_BaseData.Set(key,value);
end
function self.Add(key,value)
    self.m_BaseData.Add(key,value);
end
function self.Query(key,default)
    if not self.m_BaseData then return default end;
    local value = self.m_BaseData.Query(key,default)
    if value then return value else return default end
end
function self.SetAccountInfo(info)
    self.m_AccountInfo = info
end
function self.GetAccountName()
    return self.m_AccountInfo['accountname']
end
function self.Name()
    return self.Query('name',"临时name名字");
end
function self.GetName()     --获得玩家名字
    return self.Name() 
end      
function self.SetName(name)     --设置玩家名字
    self.Set("name",name)
end
function self.GetGrade()        --获得玩家等级
    return self.Query("lv",1);
end
function self.SetGrade(lv)      --设置玩家等级
    if lv ~= self.GetGrade() then
        self.Set("lv",lv)
    end
end
function self.GetExp()          --获得玩家经验值
    return self.Query("exp",0);
end
function self.SetExp(exp)       --设置玩家经验值
    if exp ~= self.GetExp() then
        self.Set("exp",exp)
    end
end
function self.GetSex()          --获得玩家的性别
    return self.Query("sex",1)
end
function self.SetSex(n)         --设置玩家的性别
    self.Set("sex",n)
end
function self.GetShape()        --获得玩家的模型id
    return self.Query("sid",0)
end
function self.SetShape(sid)     --设置玩家的模型id
    self.Set("sid",sid);
end
function self.GetLV()
    return self.GetGrade()
end
function self.GetIcon()
    return 0
end
function self.GetSID()
    return 0
end
function self.GetVipLV()        --获得玩家的VIP等级
    return self.Query("vip",0)
end
function self.SetVipLV(lv)      --设置玩家的VIP等级
    self.Set("vip",lv)
end
function self.GetGold()        --获得玩家的金币数量
    return self.Query("gold",1000)
end
function self.SetGold(gold_num)      --设置玩家的金币数量
    self.Set("gold",gold_num)
end
function self.GetDiamond()        --获得玩家的钻石
    return self.Query("diamond",100)
end
function self.SetDiamond(diamond_num)      --设置玩家的钻石
    self.Set("diamond",diamond_num)
end
--------------修改名字------------------
function self.ChangeName(name)      
    if not name then
        log("self.ChangeName name",name)
        return
    end
    if name ~= self.GetName() then
        self.SetName(name)
        netplayer.S2CPlayerChangeName(name)
    end
end
--##########################enter#######################
function self.SetCreate()
  self.m_bCreate = true
end
function self.Create()
    -------------------
    if self.m_ID then self.SetName("game:"..self.m_ID) end
    self.SetGrade(1);
    --self.SetDiamon(100);
    --self.SetGold(50)
    --additem
--    self.m_ItemDB.AddNewItem(self,1001,1);
--    self.m_ItemDB.AddNewItem(self,1004,1);
--    self.m_ItemDB.AddNewItem(self,1003,1);
    log("++-create end");
    self._CreateEx()
    self.m_bCreate = false;
    --新账号10秒后保存
    local function cb()
        self.Save()
    end
    skynet.timeout(100*10,cb)
    --self.SetCreateTimer()
end
function self.EnterGame(reenter) --reenter代表是否是顶号进入的
    log("-----------gameEnter")
    if self.m_bCreate then
      self.Create();
      self.m_bCreate = false;
    else 
        --self.GetAllOnlineExcute()
    end
    local function test()
    end
    test();
    
    self.m_nLogin = define.e_login.ok
    netbase.S2CBaseInfo(self)
    ----
    local function DelaySendPack()--延迟1
    end
    DelaySendPack();
    --cup
    local function Delay2()--延迟2
    end
    Delay2()
    local function Delay3()
        --netplayer.S2C_NetPlayer_S2CSendAllOK(self)
        --leo test
        --local netwar = require "net.netwar"
        --netwar.TestWarPve(self)
        netpet.LoginSendAll(self)
    end
    skynet.timeout(20,Delay3) --0.2秒时间延迟
    local function judge()
        --#leo test
        --end
    end
    judge()
    local function JudgeMemery()
        local _memery3=collectgarbage("count")
        log("---memery3",_memery3);--内存
    end
    skynet.timeout(200,JudgeMemery);
    self.AutoSave();
    self.SetHeart()
end
function self.PrivyPrepare()--加载Privy数据
    skynet.send(".privy","lua","load",self.m_ID)
end
function self.OffLine() --下线
    log("OffLine---",self.m_ID)
    if not self.m_BaseData then return end;
    local function Delay() --需要离线是因为~Privy那边需要玩家离线,他才删除
        --save privy
        --skynet.call(".privy","lua","offline",self.m_ID) --同时删除离线数据
    end
    skynet.timeout(2,Delay) --延迟0.01秒
    self.OffLineEx();
    self.LeaveScene()
    log("LeaveScene00---",self.m_ID)
end
function self.SaveInfo2Redis() --设置信息,可以让人去抢夺
    RedisCommon.SetInfo(self.m_ID,self.GetSaveRedisInfo())
end
--##################################
function self.SetToday(key, value)
    self.m_Today.Set(key, value)
end
function self.AddToday(key, value)
    self.m_Today.Add(key, value)
end    
function self.GetToday(key, default)
    if not default then default = 0 end
    return self.m_Today.Query(key, default)
end
--#############week#################
function self.SetWeek(key,value)
    self.m_Week.Set(key, value)
end    
function self.AddWeek(key,value)
    self.m_Week.Add(key,value)
end   
function self.GetWeek(key,default)
    if not default then default = 0 end
    return self.m_Week.Query(key, default)
end
--################other###################
function self.SetOther(key,value)
    self.m_OtherDB.Set(key, value)
end 
function self.GetOther(key,default)
    if not default then default = 0 end
    return self.m_OtherDB.Query(key, default)
end
--##########################################
function self.GetHeroDB()
    return self.m_HeroDB;
end
function self.GetEquipDB()
    return self.m_EquipDB;
end
function self.GetTaskDB()
    return self.m_TaskDB;
end
--#########GM--------
function self.GetGM()
    if self.m_nGM >0 then return self.m_nGM; end
    if  misc.Now() < self.Query("gmtm",0) then  --如果还在有效期内
        return 1
    else
        return 0 
    end
end
function self.SetGM(n,ntime)
    self.m_nGM = n;
    if not misc.IsNull(ntime) then 
        self.Set("gmtm",misc.Now() + ntime)
    end
    notify.GS2CMessage(self.GetSocketID(),"权限:"..n)
end
function self.SetHeart()
    self.m_HeartTime = C_game.GetSecond();
end
function self.JudgeHeart()
    local difftime = C_game.GetSecond() - self.m_HeartTime
    if difftime >= define.hearttime  then 
        return false
    end
    return true;
end
function self.GetPos()
    return self.Query("pos",{x=100,y=100})
end
function self.SetPos(pos) --pos = {x=100,y=100}
    self.Set("pos",pos)
end
--------------------------------------------------------------end
PlayerCreateBaseDB(self)
g_player = self;
return self