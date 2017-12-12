package.path = SERVICE_PATH.."?.lua;" .. package.path
require "npc.npcheader"
local netpet = require "net.netpet"

function herodb_createdata(pid)
    local self = CDictKeysCtrl()
    function self.init(pid)
        self.m_ID = pid;
        self.m_Data = {}
        self.m_herodata = {};
        self.m_bUpdate = false;
        self.m_nNewID = 0;
    end
    function self.Load(data)
        --log("npcdb_createdata load data",data);
        if not data then return end;
        self.m_Data = misc.get(data,"d",{});
        self.m_nNewID = misc.get(data,"mid",1);
        local temdata= misc.get(data,'herodata',{});
        self.m_herodata = {}
        for key,value in pairs(temdata) do
            local obj =npccreate_load(value,key)
            if obj then
                self.m_herodata[key] = obj;
            end
        end
        --log("npcdb_createdata load data11",misc.len(self.m_herodata));
    end
    function self.Save()
        local data ={}
        data['d' ] = self.m_Data
        data['mid'] = self.m_nNewID
        local temdata = {}
        for key,obj in pairs(self.m_herodata) do
            temdata[key] = obj:Save()
        end
        data['herodata'] = temdata
        --log("npcdb_createdata save data",temdata)
        return data
    end
    local _CheckUpdate = self.CheckUpdate;
    function self.CheckUpdate()
        local bUpdate = _CheckUpdate();
        for k,obj in  pairs(self.m_herodata) do
            if obj:CheckUpdate() then
                bUpdate=true;
            end
        end
        return bUpdate;
    end
    function self.GetData()
        return self.GetHeroData()
    end
    function self.GetNewID()
        --assert(self.m_nNewID >0)
        self.m_nNewID = self.m_nNewID + 1
        if self.GetData()[self.m_nNewID ] ~= nil then
            while self.GetData()[self.m_nNewID ] ~= nil do 
              self.m_nNewID = self.m_nNewID  + 1;
            end
        end    
        return self.m_nNewID
    end
    function self.AddNewHero(who,sid,reason)
        local newid =  self.GetNewID()
        local heroobj = npccreate_create(sid, newid)
        --log("addnew hero newid",newid)
        self.AddHero(newid,heroobj)
        if who then 
            --print("netpet type",type(netpet),netpet)
            netpet.S2CNewPet(who,heroobj)
            --S2C_Hero_UpdateHero(self.m_ID,heroobj) 
            --who.GetTaskDB().SetTaskTypeNum(who,g_TaskDef.stype.herorecruit,misc.Len(self.GetHeroData()));
        end
        return heroobj;
    end
    function self.GetHeroData()
        return self.m_herodata
    end
    function self.AddHero(heroid,heroobj)
        if heroobj then
            local temdata = self.GetHeroData()
            temdata[heroid] = heroobj
            --heroobj.CalProp()
            self.SetUpdate()
            --S2C_Hero_AddNewHero(self.m_ID,heroobj,1);
            --net.nethero.S2CAddNewHero(self.m_ID, heroobj,bpop)
            --net.nethero.S2CHeroDetail(self.m_ID, heroobj)
            --net.netequip.S2CHeroAllEquip(self.m_ID,heroobj)
            return heroobj
        end
    end
    function  self.GetHeroObj( heroid)
        return self.GetData()[heroid]
    end
    function self.DelHero(who,heroid)
        local obj = self.GetHeroObj(heroid)
        if obj then
            obj:DeletePetProc(who)     --宠物删除之前做的处理
            self.m_herodata[heroid] = nil
            self.SetUpdate()
            --nethero.S2CDelHero(self.m_ID, heroid)
        end
    end
    function self.GMClear()--GM使用
        self.init(self.m_ID)
        self.SetUpdate();
    end
    self.init(pid);
    return self
end