define = {
    g_nMinAccount = 10000,--
    g_nStartDayTime = 1375632000,  --凌晨0点为一天
    g_nStartDayTime5H = 1375650000, --凌晨5点为一天
    g_OneHourTime = 60 * 60,  --# 
    g_OneDayTime = 24 *  60 * 60,  --# 
    g_OneWeedTime = 7 * 24 *  60 * 60, --
    --
    g_nMaxValue = 1000000000,--#最大值,以免超过这个值(10亿);
    --
    hearttime = 5*60, --心跳包时间为5分钟,跳过这段时间没有收到客户端心跳包就删除了
    --
    sharedata = nil,--导表共享数据指针,在Agent设置,使用sharedata.deepcopy( "mkdata_hero",101101276)或sharedata.query( "mkdata_hero",101101276)
    --物品ID
    g_nItemStartID = 200,--物品起始ID
    e_login={off=0,ok=1}, --登录状态
    --
    maxlv = 100,--最大等级
    --
    buzhen = {a=1,b=2,c=3,d=4,pve=1,pvp=2,}, --布阵ID

    max_item_overlay_num = 1000000000, --背包中可叠加无上限物品的最大值
    interval_time_update_vit = 600, --间隔多久刷新一点体力值 单位是秒
    

    ---------------
}
return define

