

function otherdb_createotherdb(pid)
    local self = CDictKeysCtrl()
    function self.init(pid)
        self.m_ID = pid
        self.m_Data = {};  
        self.m_bUpdate = false;
    end
    function self.Load(data)
        log("otherdb_createotherdb data",data);
        if not data then return end;
        self.m_Data = data
    end

    function self.Save()
        local data = self.m_Data
        log("otherdb_createotherdb save",data);
        return data
    end
    self.init(pid);
    return self
end
