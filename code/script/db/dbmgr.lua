package.path = SERVICE_PATH.."?.lua;" .. package.path


local skynet =  require "skynet"
local mysql = require "skynet.db.mysql"
--require "pickle"
require "db.insertable"


function createdbmgr(datactrl,LoadSqlStr,SaveSqlStr)
    local self = {}
    function self.init()
         self.m_DataCtrl = datactrl
         self.m_SaveSqlStr = SaveSqlStr;
         self.m_LoadSqlStr = LoadSqlStr
         self.m_bLoding = true
         self.m_TempExcute = {} --
         self.m_WakeCO = {}
    end
    function self.Insert()
    end
    function self.Prepare() --
        if not self.m_DataCtrl or not self.m_LoadSqlStr then return end;
        self.m_bLoding = true
        --log("-----self.m_LoadSqlStr",self.m_LoadSqlStr);
        local sql = string.format(self.m_LoadSqlStr , self.m_DataCtrl.m_ID);
        local rz = skynet.call(".sql", "lua", "querycb",sql);
        --log("------dbmgr.load",rz);
        self._Load(rz)
    end
    function self.PrepareSync()--
        if not self.m_DataCtrl or not self.m_LoadSqlStr then return end;
        self.m_bLoding = true
        local sql = string.format(self.m_LoadSqlStr , self.m_DataCtrl.m_ID);
        skynet.fork(function ()  local rz = skynet.call(".sql", "lua", "querycb",sql); --
            self._Load(rz)
        end);
    end
    function self._Load(rz)
        local str=nil
        if misc.isEmpty(rz) then
            self.Insert();--
        else
            _,str = next(rz[1]);
        end
        local data 
        if not str or str == ""or str == " " or ( string.len(str) ==1 and str:byte(1) == 6) then
            data = {}
        else
            local function func(args)
                data = g_pickle.eval(str);
            end
            local ok, err = xpcall(func, debug.traceback)
	        if not ok then
                log("err",err);
                data = {};
            end
        end
        self.m_bLoding = false;
        self.Load(data);
        self.LoadFinish()
    end
    function self.Save()
        local tdata = self.m_DataCtrl.Save();
        local sdata = g_pickle.serializeTable(tdata);
        sdata = mysql.quote_sql_str(sdata) --
        local sql = self._GetSaveSql(sdata)
        skynet.fork(function () skynet.call(".sql", "lua", "query",sql) end);
    end
    function self._GetSaveSql(sdata)
        return string.format(self.m_SaveSqlStr , sdata,self.m_DataCtrl.m_ID)
    end
    function self.Load(data)
        self.m_DataCtrl.Load(data);
    end
    function self.IsLoading()
        return self.m_bLoding
    end
    function self.LoadFinish()
        --co
        for i,co in ipairs(self.m_WakeCO) do
            skynet.wakeup(co) --
        end
        self.m_WakeCO = {}
        --cb
        for k,cb in pairs(self.m_TempExcute) do
            if cb then cb(self); end
        end
        self.m_TempExcute = {}
    end
    function self.AppendAwakeCO(co)
        if self.IsLoading() then
            table.insert(self.m_WakeCO,co);
        else
            skynet.wakeup(co)
        end
    end
    function self.Excute(cb) --
        if self.IsLoading() then
            table.insert(self.m_TempExcute,cb);
        else
            if cb then  cb(self);  end
        end
    end
    self.init();
    return self
end
function CPlayInfoDataBaseMgr(datactrl,LoadSqlStr,SaveSqlStr)
    local self = createdbmgr(datactrl,LoadSqlStr,SaveSqlStr)
    function self.Save()
        local sdata = self.m_DataCtrl.Save();
        local sql = string.format(self.m_SaveSqlStr ,sdata['name'],sdata['sex'],sdata['sid'],sdata['lv'],self.m_DataCtrl.m_ID)
        skynet.fork(function () skynet.call(".sql", "lua", "query",sql) end);
        --log("CPlayInfoDataBaseMgr",sdata);
    end
    function self.Load(data)
    end
    return self;
end

function CDataUpdateSaveMgr(datactrl,LoadSqlStr,SaveSqlStr)
    local self = createdbmgr(datactrl,LoadSqlStr,SaveSqlStr)
    function self.UpdateSave() 
        if self.m_DataCtrl.CheckUpdate()==true then
            self.Save();
            --log("---------CDataUpdateSaveMgr");
        end
    end
    return self
end

