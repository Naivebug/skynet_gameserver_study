



function petdb_createdata(pid)
    local self = CDictKeysCtrl()
    function self.init(pid)
        self.m_ID = pid;
        self.m_Data = {}
        self.m_HeroData = {};
    end
    function self.Load(data)
        log("petdb_createdata load data",data);
        if not data then return end;
        self.m_Data = misc.get(data,'d',{});
        --self.m_HeroData = misc.get(data,"p",{});
    end
    function self.Save()
        log("petdb_createdata save data",data);
        local data ={}
        data['d'] = self.m_Data
        --data['p'] = self.m_HeroData;
        return data
    end
    self.init(pid);
    return self
end
