local skynet = require "skynet"

function createpropdata(pid)
    local self = CDictKeysCtrl()
    function self.init(pid)
        self.m_ID = pid
        self.m_Data = {};  
        self.m_bUpdate = false;
    end
    function self.Load(data)
        log("createpropdata load data",data);
        if not data then return end;
        self.m_Data = data
    end

    function self.Save()
        return self.m_Data
    end
    self.init(pid);
    return self
end


function create_savepropdata(id)
    local self = {}
    function self.init(id)
        self.m_ID = id
    end
    function self.Load()
    end
    function self.Save()
        local who = g_player;
        local temdata = {}
        temdata['name'] =who.Name();
        temdata['sex'] = who.GetSex()
        temdata['sid'] = who.GetShape()
        temdata['lv'] = who.GetGrade()
        return temdata;
    end 
    self.init(id);
    return self
end
