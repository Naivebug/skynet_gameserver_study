package.path = SERVICE_PATH.."?.lua;" .. package.path
require "base.eval"
function log(...) --ͬ
    if not misc.IsTest() then return end;
	--do return end;
	local arg = {...}
	local tem = "-:"; 
  local j = 1;
  for i,v in pairs(arg) do
    if j <i then --判定中间是否有空值
        for k=j+1,i do tem = tem.."nil  "; end
        j=i;
    end
    if type(v) == 'table' then
      tem = tem..g_pickle.serializeTable(v).."  ";--table2str(v);--serializeTable(v)--
    else
      if v == "" then 
          tem = tem.."\"\"  ";
      else
          tem = tem..tostring(v).."  ";
      end
    end
      j = j+1;
  end
	print(tem);
	if tem then writefile(tem); end
	--skynet.error(tem);
	
end
function warn(...) log("****Warn***:",...) end;
function writefile(msg,mod)
    if not mod then mod = "a+" end;
    local file = io.open("log/Log.txt", mod);
    file:write(msg.."\n");
    file:close();
end

function table2str(...)--
	local arg = {...}
	local tem = "";
	for i,v in ipairs(arg) do
		if type(v) == 'table' then
			local bok = false
			tem = tem.."{"
			for i,value in pairs(v) do
				bok = true
		     	
		     	if type(value) == 'table' then
		     		tem =tem..tostring(i).."="..table2str(value);
		     	else
		     		tem =tem..tostring(i).."="..tostring(value)--..",\t";
		     	end
			end
			tem = tem.."} "
		else
		   if v == nil then
		   		tem = tem.."nil"--.."\t"
		   end
	       tem = tem..tostring(v)--.."\t";
	    end
	 end
	return tem
end
