local skynet = require "skynet"
require "skynet.manager"  -- import skynet.register
local mysql = require "skynet.db.mysql"
package.path = SERVICE_PATH.."?.lua;" .. package.path
require "misc.misc"


local db
local CMD = {}

function Sql_Start(str,func)
    CMD.start(str,func)
end
function  CMD.start(str,func)
        log("------mysql--CMD.start:",str,func);
        skynet.fork(function ()
            local    res = db:query("select * from cats order by id asc")
            print ( "test3 loop times=" ,1,"\n","query result=",dump( res ) )
            res = db:query("select * from cats order by id asc")
            print ( "test3 loop times=" ,2,"\n","query result=",dump( res ) )
            --func(res);
        end)
        return "start return"
end
--sqlres1  {errno=1064,sqlstate="42000",err="You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '{[\\\"1601307937324765076\\\"]={[1]=\\\"1\\\",[2]=\\\"1\\\",[3]=\\\"360\\\",},}'' WHERE rl_uID=1' at line 1",badresult=true,}  
function CMD.query(sqlst)
      --print("----------cmd.query:",sqlst);
        local res = db:query(sqlst);
        if res.errno then --
            if misc.IsTest() then local msg = debug.traceback(res.err, 2) log(string.sub(sqlst,1,50)) log(msg) end
            misc.SaveLog("sqlerror",string.sub(sqlst,1,50).." -|- "..res.err);
        end
end
function CMD.querycb(sqlst)
    --print("++++++++++++++cmd.querycb:",sqlst);
    local res = db:query(sqlst)
    if res.errno then --
        if misc.IsTest() then local msg = debug.traceback(res.err, 2) log(string.sub(sqlst,1,50)) log(msg) end
        misc.SaveLog("sqlerror",string.sub(sqlst,1,50).." -|- "..res.err);
    end
    return res;
end


skynet.start(function()
    --local sqlname = skynet.getenv "sqlname"
    --if not sqlname then sqlname = 'skynetheros' end;
   local function on_connect(db)
      db:query("set charset utf8");
    end
  db=mysql.connect({
        host="127.0.0.1",
        port=3306,
        database="dbgame",
        user="iphone",
        password="iphoneGame",
        max_packet_size = 1024 * 1024,
        on_connect = on_connect
    })
	if not db then
		  print("failed to connect mysql")
	end
	db:query("set names utf8")
    --
    skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		local f = assert(CMD[cmd])
        if session == 0 then 
            f(subcmd, ...)
        else 
		    skynet.ret(skynet.pack(f(subcmd, ...)))
        end
	 end)
    skynet.register ".sql"
end)

