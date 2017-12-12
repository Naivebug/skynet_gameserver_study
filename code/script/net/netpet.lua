require "gamelogin"
local protobuf = require "protobuf"
local protocol = require "protocol"
-------------c2s------------
local netpet = {}

function netpet.C2SChangePetName(who,buff)
  log("-----netpet.C2SChangePetName-----")
end


------------handle--------------
local handle = {
  [1]=netpet.C2SChangePetName,
  
}
function netpet.handle(sid,buff)
    local fun = handle[sid];
    if fun ~= nil then 
        fun(GetPlayer(),buff)
    else
        warn("---netpet don't handle--",sid)
    end
end
------------s2c--------------
----//s2c子协议号1--发送一个宠物
function netpet.LoginSendAll(who)
  log("-------netpet.LoginSendAll-----------")
  -- local objs = who.GetHeroDB().GetData()
  -- for id,pobj in pairs(objs) do 
  --     netpet.S2COnePet(who,pobj)
  -- end
end
function netpet.PushPet(who,pobj)
  local skills = {}
  --local skill = {{number = 1,lv=2},{number = 2,lv=1}}
  local skilltype_list = {"Small1","Big","Small2","Small3","Passive"}     --按照技能解锁的顺序排列
  for i=1,5 do
    local skilllv = pobj:GetSkillLv(skilltype_list[i])
    if skilllv > 0 then
      table.insert(skills,{number = skilltype_list[i], lv = skilllv})
    end
  end
  local tbl = {
        id = pobj:GetID(),
        sid = pobj:GetSID(),
        name = pobj:GetName(),
        exp = pobj:GetExp(),
        hp = pobj:GetHP(),
        lv = pobj:GetLV(),
        atk = pobj:GetAtK(),
        matk = pobj:GetMatk(),
    }
    return tbl
end
--s2c子协议号1--发送一个宠物
function netpet.S2COnePet(who,pobj)
    --log("netpet.S2COnePet",pobj:GetID())
    local stringbuffer = protobuf.encode("Protocol.S2COnePet",netpet.PushPet(who,pobj))
    sendPackage(protocol.S2C_Pet,1,stringbuffer)
end
--S2C子协议号2,添加一个宠物
function netpet.S2CNewPet(who,pobj)
    --log("netpet.S2CNewPet",pobj:GetID())
    local stringbuffer = protobuf.encode("Protocol.S2CAddPet",{addpet = netpet.PushPet(who,pobj)})
    sendPackage(protocol.S2C_Pet,2,stringbuffer)
end
------------------------------
return netpet
