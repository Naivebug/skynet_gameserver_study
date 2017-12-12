local skynet = require "skynet"
local socket = require "skynet.socket"
local string = require "string"
local websocket = require "websocket"
local httpd = require "http.httpd"
local urllib = require "http.url"
package.path = SERVICE_PATH.."?.lua;" .. package.path
local sockethelper = require "http.sockethelper"
require "misc.misc"
local protobuf = require "protobuf"


local handler = {}
function handler.on_open(ws)
    print(string.format("%d::open", ws.id))
    protobuf.register_file("./script/protos/login.pb")
end

function handler.on_message(ws, message)
    print(string.format("%d receive:%s", ws.id, message))
    --ws:send_text(message )
    local data = protobuf.decode("login.Login",message)
    log("data",data)
    ws:send_binary(message )
    
    --ws:close()
end

function handler.on_close(ws, code, reason)
    print(string.format("%d close:%s  %s", ws.id, code, reason))
end

local function handle_socket(id)
    -- limit request body size to 8192 (you can pass nil to unlimit)
    local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(id), 8192)
    if code then
        print("---handle_socket-"..id.." ".. " "..url)
        if url == "/ws" then
            local ws = websocket.new(id, header, handler)
            ws:start()
        end
    end


end

skynet.start(function()
    local address = "0.0.0.0:8001"
    skynet.error("Listening "..address)
    local id = assert(socket.listen(address))
    socket.start(id , function(id, addr)
       socket.start(id)
       pcall(handle_socket, id)
    end)
end)
