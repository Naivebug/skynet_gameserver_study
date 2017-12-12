package.path = SERVICE_PATH.."?.lua;" .. package.path

local define=require "define.define"

DictKeysCtrl = BaseClass()
function DictKeysCtrl:__init()  -- 定义 base_type 的构造函数
    self.m_bUpdate = false;
end
function DictKeysCtrl:Set(key,value)
    self.m_Data[key] = value;
    self:SetUpdate();
end
function DictKeysCtrl:Add(onekey,value)
        self:Set(onekey,value + self:Query(onekey,0))
end
function DictKeysCtrl:Query(key,default)
    if self.m_Data[key] then 
        return self.m_Data[key] 
    else
        return default 
    end
end
function DictKeysCtrl:SetKeys(keys,value)
    local data = self.m_Data;
    local nlen = #keys
    for i,key in ipairs(keys) do 
        if i==nlen then 
            data[key] = value
        else 
            if not data[key] then data[key] = {} end
            data = data[key]
        end
    end
    self:SetUpdate();
end
function DictKeysCtrl:QueryKeys(keys,default)
    return misc.Query(self.m_Data,keys,default)
end
function DictKeysCtrl:IsUpdate()
    return self.m_bUpdate
end
function DictKeysCtrl:SetUpdate()
    self.m_bUpdate = true
end
function DictKeysCtrl:ClearUpdate()
    self.m_bUpdate = false
end
function  DictKeysCtrl:CheckUpdate()
    if self.m_bUpdate then
        self:ClearUpdate();
        return true;
    end
    return false;
end
function CDictKeysCtrl()
    local self = {}
    function self.Set(key,value)
        self.m_Data[key] = value;
        self.SetUpdate();
    end
    function self.Add(onekey,value)
        self.Set(onekey,value + self.Query(onekey,0))
    end
    function self.Query(key,default)
        if self.m_Data[key] then 
            return self.m_Data[key] 
        else
            return default 
        end
    end
    function self.SetKeys(keys,value)
        local data = self.m_Data;
        local nlen = #keys
        for i,key in ipairs(keys) do 
            if i==nlen then 
                data[key] = value
            else 
                if not data[key] then data[key] = {} end
                data = data[key]
            end
        end
        self.SetUpdate();
    end
    function self.QueryKeys(keys,default)
        return misc.Query(self.m_Data,keys,default)
    end
    function self.IsUpdate()
        return self.m_bUpdate
    end
    function self.SetUpdate()
        self.m_bUpdate = true;
    end
    function self.ClearUpdate()
        self.m_bUpdate = false
    end
    function  self.CheckUpdate()
        if self.m_bUpdate then
            self.ClearUpdate();
            return true;
        end
        return false;
    end
    return self;
end

function GetSecond()
    return os.time();
end
function GetDayNum() 
    return misc.int((GetSecond() - define.g_nStartDayTime5H) / define.g_OneDayTime)
end
function GetWeekNum()
    return misc.int((C_game.GetSecond() - define.g_nStartDayTime5H) / define.g_OneWeedTime)
end
function only_CToday(pid)
    local self  = CDictKeysCtrl();
    function self.Init()
        self.m_ID = pid
        self.m_Data = {}
        self.m_nToday = 0;
        self.m_bUpdate = false;
    end
    function self.Load(data)
        if not data then return end;
        if data['d'] then self.m_Data = data['d'] end
        if data['t'] then self.m_nToday = data['t'] end
        self.JudgeToday();
    end 
    function self.Save()
        self.JudgeToday();
        local data = {}
        data['t'] = self.m_nToday
        data['d'] = self.m_Data
        return data
    end
    function self.JudgeToday()
        if self.GetToDay() ~= self.m_nToday then  -- 
            self.m_nToday = self.GetToDay()
            self.m_Data = {}
            self.SetUpdate()
            return false
        end
        return true;
    end
    function  self.GetToDay()
        return GetDayNum()
    end
    function self.GetData()
        self.JudgeToday()
        return self.m_Data;
    end
    local _Set = self.Set;
    function self.Set(key,value)
        self.JudgeToday();
        _Set(key,value);
    end
    local _SetKeys = self.SetKeys;
    function self.SetKeys(keys,value)
        self.JudgeToday();
        _SetKeys(keys,value);
    end
    local _Query = self.Query
    function self.Query(key,default)
        self.JudgeToday();
        return _Query(key,default);
    end
    local _QueryKeys = self.QueryKeys
    function self.QueryKeys(keys,default)
        self.JudgeToday();
        return _QueryKeys(keys,default);
    end
    local _Add = self.Add
    function self.Add(onekey,value)
        self.JudgeToday();
        _Add.Add(onekey,value)
    end
    self.Init()
    return self
end

function only_CWeek(pid) --
    local self = only_CToday(pid)
    function GetToDay()  --
        return self.GetWeekNum()
    end
    function GetWeekNum() --
        return GetWeekNum();
    end
    return self
end
