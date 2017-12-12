
CNpcProp = BaseClass(DictKeysCtrl)
function CNpcProp:GetName()
    return self.m_Name;
end
function CNpcProp:GetID()
    return self.m_ID
end
function CNpcProp:SetID(id)
    self.m_ID = id;
end
function CNpcProp:GetSID()
    return self.m_SID
end
function CNpcProp:GetHP()
    return self.m_HP;
end
function CNpcProp:GetMaxHP() --
    return self.m_HP
end

function CNpcProp:GetSpeed() --
    return self.m_Speed
end
function CNpcProp:GetAtK() --
    return self.m_Atk
end
function CNpcProp:GetMatk() --
    return self.m_Matk
end
function CNpcProp:GetDef() --
    return self.m_Def
end
function CNpcProp:GetMdef() --
    return self.m_Mdef
end
function CNpcProp:GetSkillIds()-- {位置:{技能ID,技能等级}}
    return {[1]={self.m_Skill1,1},[2]={self.m_Skill2,1},[3]={self.m_Skill3,1},[4]={self.m_Skill4,1},[5]={self.m_Skill5,1}} 
end
function CNpcProp:GetDefProp()
    return self.m_PetNatureType
end
function CNpcProp:GetBaoJi()
    return self.m_Crt
end
CNpc = BaseClass(CNpcProp)
function CNpc:__init()  -- 定义 test 的构造函数
end
function CNpc:init(nid)
    self.m_ID = nid
    self.m_Data = {}
    self.m_bUpdate = false
    self.m_Name = self.m_PetName
    self.m_HP = self.m_HpNature; 
    self.m_Speed = self.m_SpdNature
    self.m_Atk = self.m_AtkNature
    self.m_Matk = self.m_SpAtkNature
    self.m_Def = self.m_DefNature
    self.m_Mdef = self.m_SpDefNature
end
function CNpc:CalProp() --计算NPC属性
end
function CNpc:Create()
    self:SetUpdate();
    --self.CalProp();
end
