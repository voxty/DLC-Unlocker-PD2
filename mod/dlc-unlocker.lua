local function always_true() return true end

local classes = { "DLCManager", "WINDLCManager", "WinSteamDLCManager" }

for _, name in ipairs(classes) do
    local cls = rawget(_G, name)
    if cls then
        if cls._check_dlc_data then
            cls._check_dlc_data = always_true
        end
        if cls._verify_dlcs then
            cls._verify_dlcs = function(self) end
        end
    end
end
