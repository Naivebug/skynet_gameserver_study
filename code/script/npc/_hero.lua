------------skill------
local define = require "define.define"
local netpet = require "net.netpet"
----------------------------
Chero = BaseClass(CNpc)
function Chero:__init()  
end

function Chero:Create()
    --self._class_type.super:Create()
end

function Chero:Load(data)
    --log("Chero load data",data);
    if not data then return end;
    self.m_Data = misc.get(data,'d',{});
end

function Chero:Save()
    local data ={}
    data['sid'] = self:GetSID();
    data['d'] = self.m_Data
    return data
end

local _CheckUpdate = CNpc.CheckUpdate;
function Chero:CheckUpdate()
    local bUpdate = _CheckUpdate(self);
    return bUpdate;
end
--------------------------------
function Chero:SetSID(sid)  --设置SID
    if self:GetSID() ~= sid then
        self:Set("sid",sid)
    end
end
function Chero:GetSID()  --获得SID
    local sid = self:Query("sid",0)
    if 0 == sid then
        sid = self.m_SID
        self:Set("sid",sid)
    end
    return sid
end
function Chero:SetName(name)  --设置名字
    self:Set("name",name)
end
function Chero:GetName()  --获得名字
    local name = self:Query("name","")
    if "" == name then
        name = self.m_Name
    end
    return name
end
function Chero:GetEquipId()  --获得装备id
    local equipid = self:Query("equipid",0)
    return equipid
end

function Chero:SetSkillLv(skilltype,skilllv)  --设置技能等级
    if self:GetSkillLv(skilltype) ~= skilllv then
        self:Set(skilltype,skilllv)
    end
end




    ------------------
