local skynet =  require "skynet"

function CInertTableUpdateSaveMgr(datactrl,tbl,keyid)
    local self = CDataUpdateSaveMgr(datactrl,LoadSqlStr,SaveSqlStr)
    self.m_Table = tbl
    if not keyid then keyid = "rl_uID" end
    self.m_KeyID = keyid
    function self.init(keys)
        self.m_bLoding = 0
        self.m_bUpdate = false
        self.m_LoadSqlStr = "SELECT rl_sData FROM " .. self.m_Table .. " WHERE " .. self.m_KeyID .. " = \'%s\';"
        self.m_SaveSqlStr = "UPDATE " .. self.m_Table .. "  SET "..self._GetSaveField().."rl_sData = %s WHERE  " .. self.m_KeyID .. "  = \'%s\';"
        self.m_InsertSqlStr = "INSERT INTO " .. self.m_Table .. "  (`" .. self.m_KeyID .. "`,`rl_sData`) VALUES (\'%s\',\'%s\');"
    end
    function self._ResetSaveSql()
        self.m_SaveSqlStr = "UPDATE " .. self.m_Table .. "  SET "..self._GetSaveField().."rl_sData = %s WHERE  " .. self.m_KeyID .. "  = \'%s\';"
    end
    function self._GetSaveField()
        return ""
    end
    function self._GetSaveAddValue()
        return ""
    end
    function self._GetSaveSql(sdata)
        if self._GetSaveField() == "" then 
            return string.format(self.m_SaveSqlStr , sdata,self.m_DataCtrl.m_ID)
        else 
            local s = string.format(self.m_SaveSqlStr ,self._GetSaveAddValue(), sdata,self.m_DataCtrl.m_ID)
            log("_getsavqsql1212",s);
            return s
        end
    end
    function self.Insert()
        --sql = self.m_InsertSqlStr % (self.m_Keys ,"")
        local sql = string.format(self.m_InsertSqlStr ,self.m_DataCtrl.m_ID,"")
        skynet.call(".sql", "lua", "query",sql)
        --log("dbmgr insert",self.m_DataCtrl.m_ID)
        --self.NewCreate()
    end
    function self.NewCreate()
    end
    
    self.init();
    return self;
end

