local cutils = require ("common-utils")
local log = Log.open_topic ("s-exclude-monitor")

-- monitor names (as reported by the ELD) that must never become the default sink
local EXCLUDE = {
  ["MAG274UPF"] = true,
}

-- the node's own props are a snapshot from node creation; the route info
-- is refreshed by PipeWire on every ELD change
local function live_monitor_name (node_props, devices_om)
  local card_dev = tonumber (node_props["card.profile.device"])
  local dev_id = node_props["device.id"]
  if not card_dev or not dev_id then return nil end

  local dev = devices_om:lookup {
    Constraint { "bound-id", "=", dev_id, type = "gobject" } }
  if not dev then return nil end

  for p in dev:iterate_params ("Route") do
    local r = cutils.parseParam (p, "Route")
    if r and r.device == card_dev and type (r.info) == "table" then
      -- info is a Struct: [1] = count, then alternating key, value
      for i = 1, #r.info - 1 do
        if r.info[i] == "device.product.name" then
          return r.info[i + 1]
        end
      end
    end
  end
  return nil
end

SimpleEventHook {
  name = "custom/exclude-monitor-sink",
  before = { "default-nodes/find-selected-default-node",
             "default-nodes/find-stored-default-node",
             "default-nodes/find-best-default-node" },
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "select-default-node" },
      Constraint { "default-node.type", "=", "audio.sink" },
    },
  },
  execute = function (event)
    local nodes = event:get_data ("available-nodes")
    nodes = nodes and nodes:parse ()
    if not nodes then return end

    local devices_om =
        event:get_source ():call ("get-object-manager", "device")

    local keep, dropped = {}, false
    for _, n in ipairs (nodes) do
      local mon = live_monitor_name (n, devices_om)
      log:debug ("sink " .. tostring (n["node.name"]) ..
                 " live monitor: " .. tostring (mon))
      if mon and EXCLUDE[mon] then
        dropped = true
        log:info ("excluding " .. n["node.name"] .. " (" .. mon .. ")")
      else
        table.insert (keep, Json.Object (n))
      end
    end

    if dropped then
      event:set_data ("available-nodes", Json.Array (keep))
    end
  end
}:register ()
