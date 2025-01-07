

local protocol = {

  execute = function(self, meta)
    -- todo, insert config hash...
    log(1, "Computing config hash...")
    
    -- local hash = require("data.version").digest
    local cAddr = data.version.custom_menu_version_space
    -- TODO: this string contains %d, make it format to we include the .41
    local v = string.format(core.readString(cAddr), data.version.game_version.minor)

    -- This is also an option
    -- modules.chat:fireChatEvent(hash, 1)
    modules.chat:sendChatMessage(v, {1, 2, 3, 4, 5, 6, 7, 8})
  end,

}

local IS_HOST_ADDRESS = core.readInteger(core.AOBScan("83 ? ? ? ? ? ? 74 79 B9 ? ? ? ?") + 2)

local checkIsHost = function() return core.readInteger(IS_HOST_ADDRESS) ~= 0 end

local namespace = {
  enable = function(self, config)
    local protocolNumber = modules.protocol:registerCustomProtocol("config-similarity-protocol", "config-similarity-protocol", "IMMEDIATE", 0, protocol)
    local cb = function(args, command)
      -- If you want to set up your data gathering before sending the command, do it here and now just like the game does

      if not checkIsHost() then
        return false, "This command is only available as a host"
      end

      modules.protocol:invokeProtocol(protocolNumber)

      return false
    end
    modules.chatcommands:registerChatCommand("checkconfigsimilarity", cb)
    modules.chatcommands:registerChatCommand("check", cb)
  end,
  disable = function(self, config)
  end,
}

return namespace