local skynet = require "skynet"
local snax = require "skynet.snax"
local protobuf = require "protobuf"
skynet.start(function()
    local files = {
      --"./script/protos/Person.pb", --test
      "./script/protos/Base.pb",
      "./script/protos/Pet.pb",
      "./script/protos/Chat.pb",
      "./script/protos/Player.pb",
      "./script/protos/login.pb",
    }
    for _,file in ipairs(files) do 
        --skynet.error("注册协议文件："..file)
        protobuf.register_file(file)
    end
end)
