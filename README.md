--create by NaiveBug^梁疯

开始前准备

1:安装Mysql,并且添加用户名:iphone,密码:iphoneGame (或者自己修改mysql/sql下的密码)(ps:注意权限)

2:导入sql下sql.sql到数据库,之后点击start.bat或skynet.exe即可启动游戏服务器

--
说明:

1本代码为Skynet逻辑学习代码,而exe执行文件是在Skynet官网非官方版本Window里有下载可自行编译,如果商业用途自己到Linux去搞,代码跨平台所以一样是可用的.

2代码在code/scrpit下,其它为Skynet原生东东..

--

代码框架:(你先要理解得了Skynet里的例子代码)

1每个玩家一个Agent,客户端发送数据转到Agent里的netcommon.netPackCommon派发网络消息,然后转到net下的netcommon.netPackCommon里对每个网络包做处理,如最简单可看netchat

2who为player,用GetPlayer()获取

3网络协议编码方式用Protobuf,客户端你可以看google的Protobuf,Skyenet里用的是云风大哥的c语言版的protobuf,协议体在protos下,pb文件生成方式自己搜百度~protobufinit初始化和加载protobuf

4用户登录先在netbase.C2SLogin下接着执行进入到account里的LoadPlayerData加载玩家数据,数据加载和操作主要在player的m_DBList和m_WhenUpdateSaveList列表,(m_WhenUpdateSaveList有更新时才会在一定时间存储,否则不存储)-接着加载完成就进入到player的EnterGame函数.就算操作完,发送返回客户端数据

5m_DBList和m_WhenUpdateSaveList是这个框架最重要的东西之一即操作存储数据,代码在db的dbmgr下

6data为导表数据,导表生成的方式可看本人的pyhton_read_excel_to_lua这个git工程,data/share.lua初始化导表数据,这样做是为了节省内存,不必每个虚拟机都加载一份,只要加载他用到的即可..使用skyent的sharedata实现

7npc的这种很多数据的存储方式是在herodb下的load和save,加载时在dbmgr下的load和save调用操作.最终通过g_pickle.serializeTable序列化成字符串存到Mysql,

8数据存储所以基本数据操作是以块的即大字符串的形式存到数据库和加载使用.所以封装好后,即尽管上层写逻辑,而不用关心其它存储问题~因为在player的AutoSave几分钟定时回调Save去操作数据库检测是否有更新,有才存,

9至于是否更新调用的是UpdateSave这个函数~如调用到herodb的CheckUpdate检查每个对象是否有更新,而每个Chero继承base/only下的DictKeysCtrl或CDictKeysCtrl(他们之间区别在于一个用点号,另一个针对另一种写法类用冒号)的IsUpdate函数,所以在写入的时候尽管用Set和Query操作table数据即可,如Chero:SetName和Chero:GetName()这个函数..你只要调用了就会自动存储和自动更换,也就是到了不用关心数据的地步,非常非常的方便和非常的快捷开发...

10:BaseClass(CNpc)这种写类的方式是在base/BaseClass里写的,是云风06年写的Lua类,我只在NPC这种多个对象的实例才用,为了节省丁点内存,其实也可以不用,直接用createdbmgr这种生成方式也可以,方便统一使用self.xx而不是self:xx~~

-------------------------finsh----------------

有何建议可以在里面评论或到Skynet群里@clear,云风大哥能力大做大贡献,我能力弱就做小贡献...
