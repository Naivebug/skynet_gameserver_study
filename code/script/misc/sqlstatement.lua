
local self = {}
--#
self.g_LoadRoleBaseData = "SELECT rl_sData FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveRoleBaseData = "UPDATE tbl_role SET rl_sData = %s WHERE rl_uID=%d;"   --

--
self.g_SaveRolePlayerSqlBaseInfo = "UPDATE tbl_player SET  rl_sName=\'%s\',rl_uSex=%d,rl_uShape=%d,rl_uGrade=%d WHERE rl_uID = %d;"
--
self.g_LoadRoleTodayData = "SELECT rl_sToday FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveRoleTodayData = "UPDATE tbl_role SET rl_sToday = %s WHERE rl_uID=%d;"    
--#
self.g_LoadRoleWeekData = "SELECT rl_sWeek FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveRoleWeekData = "UPDATE tbl_role SET rl_sWeek =  %s WHERE rl_uID=%d;"    
--#
self.g_LoadItemData = "SELECT rl_sItem FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveItemData = "UPDATE tbl_role SET rl_sItem =  %s WHERE rl_uID=%d;"    
--task
self.g_LoadTaskData = "SELECT rl_sTask FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveTaskData = "UPDATE tbl_role SET rl_sTask =  %s WHERE rl_uID=%d;"   
--
self.g_LoadEquipData = "SELECT rl_sEquip FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveEquipData = "UPDATE tbl_role SET rl_sEquip =  %s WHERE rl_uID=%d;"    
--
self.g_LoadOtherData = "SELECT rl_sOther FROM tbl_role WHERE rl_uID = %d;"
self.g_SaveOtherData = "UPDATE tbl_role SET rl_sOther =  %s WHERE rl_uID=%d;"   

return self