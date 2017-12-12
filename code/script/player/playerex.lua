local skynet = require "skynet"
package.path = SERVICE_PATH.."?.lua;" .. package.path
--require "privy.onlineexcuteobj"

function CreatePlayerSelf()
  local self = {}
  function self._CreateEx()
  end
  function self.OffLineEx()
        --save offline log
  end
  function self.GetBuZhenObjs(buzhentype)
      if not buzhentype then buzhentype = define.buzhen.a end;
      local buzhenpetids = {1,2,3} --宠物ID
      local hdb = self.GetHeroDB();
      local pets = {}
      for k,petid in pairs(buzhenpetids) do 
          local obj = hdb.GetHeroObj(petid);
          if obj then 
              table.insert(pets,obj);
          end
      end
      --log("GetBuZhenObjs",pets)
      return pets
  end
  ----
  return self;
end