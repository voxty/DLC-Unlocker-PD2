if RequiredScript ~= "lib/network/base/networkpeer" then return end

local VANILLA_OUTFIT = table.concat({
    "dallas",
    "plastic",
    "no_color_no_material",
    "nothing-nothing-strip_paint",
    "level_1-level_1-level_1-none-none-default-default",
    "cop",
    "wpn_fps_ass_amcar",
    "wpn_fps_m4_uupg_b_medium_vanilla_wpn_fps_m4_lower_reciever_wpn_fps_amcar_uupg_body_upperreciever_wpn_fps_amcar_uupg_fg_amcar_wpn_fps_upg_m4_m_straight_vanilla_wpn_fps_upg_m4_s_standard_vanilla_wpn_fps_upg_m4_g_standard_vanilla_wpn_fps_amcar_bolt_standard",
    "wpn_fps_pis_g17",
    "wpn_fps_pis_g17_body_standard_wpn_fps_pis_g17_b_standard_wpn_fps_pis_g17_m_standard",
    "nil", "0",
    "nil", "0",
    "0",
    "weapon",
    "concussion",
    "0",
    "nil-nil-nil",
    "nil-nil-nil",
}, " ")

local function is_player_outfit_string(s)
    if type(s) ~= "string" then return false end
    local count = 0
    for _ in s:gmatch(" ") do
        count = count + 1
        if count >= 15 then return true end
    end
    return false
end

local function spoof_args(msg_type, ...)
    local args = { ... }
    if msg_type == "sync_outfit" then
        args[1] = VANILLA_OUTFIT
        return msg_type, unpack(args)
    elseif msg_type == "set_unit" then
        if is_player_outfit_string(args[3]) then
            args[3] = VANILLA_OUTFIT
        end
        return msg_type, unpack(args)
    end
    return msg_type, ...
end

local o_send_queued_sync = NetworkPeer.send_queued_sync
function NetworkPeer:send_queued_sync(msg_type, ...)
    return o_send_queued_sync(self, spoof_args(msg_type, ...))
end

local o_send_after_load = NetworkPeer.send_after_load
function NetworkPeer:send_after_load(msg_type, ...)
    return o_send_after_load(self, spoof_args(msg_type, ...))
end

NetworkPeer._verify_content = function(self, item_type, item_id)
    return true
end

-- Steam ownership check per item
NetworkPeer._verify_item_data = function(self, item_data)
    return true
end

-- Full outfit walk — no-op so loop never runs
NetworkPeer._verify_outfit_data = function(self)
    return nil
end

-- Entry points
NetworkPeer.verify_outfit = function(self) return end
NetworkPeer.verify_job    = function(self, job) return end
NetworkPeer.verify_character = function(self) return end
NetworkPeer.tradable_verify_outfit = function(self, signature) return end

local ITEM_REASONS = { [7]=true, [8]=true, [9]=true, [10]=true, [14]=true }

local _orig_mark_cheater = NetworkPeer.mark_cheater
NetworkPeer.mark_cheater = function(self, reason, auto_kick)
    if ITEM_REASONS[reason] then return end
    return _orig_mark_cheater(self, reason, auto_kick)
end
