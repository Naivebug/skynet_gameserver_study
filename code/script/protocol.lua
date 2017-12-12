protocol = {
--system 
S2C_Base = 1,--0x1,  -- hello pack
S2C_Heart = 2,--0x2,    --
S2C_ErrorCode = 3,--0x3,    --
S2C_Replace = 4,--0x4,    --
S2C_Close = 5,--0x5,  --

C2S_Base = 1,--0x1, --login
C2S_Heart = 2,--0x2,

-----------------------------
--s2c 
S2C_Notify = 255,--0xff,--    #
S2C_Confirm = 254,--0xfe,--   
S2C_AllServerNotify = 252,--0xfc  ,--;    #全服最顶处通告消息

S2C_Player = 32,--0x20,  
S2C_War  = 33,--0x21,
S2C_Pet = 34,--0x22,
S2C_Chat = 35,
S2C_Item = 36,
S2C_Move = 10,
S2C_Actor = 11,
--c2s
C2S_GM = 255,--0xff,    --#
C2S_Confirm = 254,--0xfe,   --
C2S_Move = 10,
C2S_Player = 32,--0x20, --
C2S_War  = 33,--0x21,
C2S_Pet = 34,--0x22,
C2S_Chat = 35,
C2S_Item = 36,
C2S_Move = 10,
C2S_Actor = 11,
}

return protocol