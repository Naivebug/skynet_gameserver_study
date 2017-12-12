

function npccreate_create(sid,newid)
    if not newid then newid = 0 end;
    if g_npcmodule[sid] then
        local obj = require (g_npcmodule[sid]).create()
        obj:init(newid);
        obj:Create();
        return obj
    end
end
function npccreate_load(data,newid)
    local sid = data['sid']
    if g_npcmodule[sid] then
        local obj = require (g_npcmodule[sid]).create()
        obj:init(newid);
        obj:Load(data);
        return obj;
    end
end