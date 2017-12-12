package.path = SERVICE_PATH.."?.lua;" .. package.path
misc = {}
require "misc.misclog"
require "misc.miscgame"


function misc.Int(value)
    return math.floor(value)
end
function misc.Ceil(value) --向上取值,和Int是相反的
    return math.ceil(value)
end
function misc.int(value)
    return math.floor(value)
end
function misc.len(tbl) --
    if not tbl then return 0 end
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end
function misc.Len(tbl) return misc.len(tbl) end
function misc.isEmpty(t) -- tabl is empty
    if next(t) == nil then return true end
	return false
end
function misc.IsEmpty(t) return misc.isEmpty(t) end
function misc.IsNull(m) --judge string is "",number is 0,table is {} 
    if not m then return true end
  local s = type(m) if s == "string" then if m == '' then return true end end 
  if s == "number" then if m == 0 then return true  end end
  if s == "table" then if next(m) == nil then return true end end
end
function misc.Query(data,keys,default) --调用misc.Query(data,{a,"b",c},default)
  for k,key in ipairs(keys) do if data == nil then return default end;data = data[key] end
  if not data then return default end; return data
end
function misc.Set(data,keys,value) --keys = {a,'b',c}
    local len = #keys for k,key in ipairs(keys) do  if len == k then data[key] = value else if not data[key] then data[key] = {} end data = data[key] end end
end
function misc.Get(data,key,default)
    if data[key]  then return data[key] end
    return default;
end
function misc.get(data,key,default) return misc.Get(data,key,default) end
function misc.Default(value,default) --1层的用这个
    if value then return value else return default end;
end
function misc.RandomSeed(n)
  if not n then n = os.time() end math.randomseed(n);
end
function misc.Rand() --[0,1)
  return math.random()
end
function misc.RandI(a)
  return misc.RandInt(0,a);
end
function misc.RandInt(a,b) --必须确定要a<b a<=v<=b
  if not b then b = a; a = 0;  end
  return a+ math.floor(misc.Rand()*(b-a+1))
end
function misc.IsHit(v)
  if v >=100 then return true end;
  local n = misc.RandI(100);
  if n<v then return true end;
end
function misc.In(tbl,obj)
    if not tbl or not obj then return false end;
    for i,temobj in pairs(tbl) do
        if temobj == obj then return i end;
    end
end
function misc.Remove(tbl,obj)
  if not tbl or not obj then return false end;
    for i,temobj in pairs(tbl) do
        if temobj == obj then table.remove(tbl,i) return i end;
    end
end
function misc.Now() --客户端本地时间,和服务器时间不一定相同,所以要注意使用(如服务器时间或本地时间跑不准,跨区等)
    return os.time();
end
function misc.Date() return os.date("*t",os.time()) end --example return {year=1970, month=1, day=1, hour=0,min=0,sec=0,yday=0,month=4,wday=2,isdst=false} --wday是星期几,从星期天算1,星期一算2
function misc.Copy(st,bcen) --bcen不设置代表只复制所有,注意{id=obj},obj也是Table来的,所以Obj就不应该复制,只复制一层的应该用misc.CopyOne
    local tab = {}
    for k, v in pairs(st) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            if not bcen then
                tab[k] = misc.Copy(v)
            else
                tab[k] = v
            end
        end
    end
    return tab
end
function misc.CopyOne(st,tab)
    if not tab then tab = {} end for k, v in pairs(st) do tab[k] = v end return tab;
end
function misc.l2t(st,default) --list to table
  local tab = {}
  for i,v in ipairs(st) do if not default then tab[v] = i else tab[v] = default end end
  return tab
end
function misc.B2I(b) if b == 1 then return 1 end if b==true then return 1 else return 0 end end --Bool转成Int
function misc.Functor(func,tbl)--# 绑定函数,这个适合
    local self = {}  self.m_tbl = tbl;
    function self.call(...) func(self.m_tbl,...) end --这个是直接调用,如CreatePanle等事件回调时,和普通函数没区别,用于C#回调
    setmetatable(self, self)
    function self.__call(self,...) func(self.m_tbl,...) end --这个是()这样调用,不能用于C#回调,如果是C#回调用.call传过去
    return self
end
function misc.SaveLog(filename,msg,mod)
    if not mod then mod = "a+" end;
    msg = string.format("%s:%s\n",os.date(),msg)
    local file = io.open("log/"..filename, mod);
    file:write(msg);
    file:close();
end