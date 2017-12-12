package.path = "./script/?.lua;" .."./script/data/?.lua;" .. package.path
require "misc/misc"
local skynet = require "skynet"
local sharedata = require "skynet.sharedata"


skynet.start(function()
  local ls = { --配置你的数据表的名字
    "mkdata_hero",
    "mkdata_npc",
    
  }
  for i,v in ipairs(ls) do 
      local temdata = require (v)
      sharedata.new(v,temdata)
  end
	skynet.exit()
end)
