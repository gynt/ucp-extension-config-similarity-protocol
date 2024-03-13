

local protocol

-- This protocol has parameter size 8 (two ints). Parameter size is constant (maybe can be made dynamic, max is 1260)
protocol = {

  -- This is called when a user initiates the protocol (with a queueProtocol(protocolNumber) call)
  -- The protocol designer is responsible for storing the to-be-send data somewhere in memory
  scheduleForSend = function(self, meta)
    
    -- For example, assume you want to implement that sleep can be toggled per building (instead of per building type)
    -- meta.parameters:writeInteger(core.readInteger(PLACE_WHERE_BUILDING_ID_IS_STORED))
    -- meta.parameters:writeInteger(core.readInteger(PLACE_WHERE_BUILDING_SLEEP_STATE_IS_STORED))

  end,

  -- This is called when a command is received in multiplayer.
  -- There is nothing to be done here actually. But hey, the programmers wrote it anyway...
  scheduleAfterReceive = function(self, meta)
    
  end,

  -- This is called when the command should be executed (committed to the game state)
  -- This is an example Delayed protocol, meaning the execute() commits something to game state that should be synchronised across machines (executed simultaenously across machines)
  -- This is synchronised in game match time across machines in case of a Delayed protocol. 
  -- In case of a Direct protocol, which is meant for lobby, chat, and UI operations (meta communication),
  -- execute is executed immediately on each machine
  execute = function(self, meta)
    -- todo, insert config hash...
    log(1, "Computing config hash...")
    local hash = "DEADBEEFDEADBEEFDEADBEEFDEADBEEF"

    modules.chat:sendChatMessage(hash, {1, 2, 3, 4, 5, 6, 7, 8})
  end,

}

local IS_HOST_ADDRESS = core.readInteger(core.AOBScan("83 ? ? ? ? ? ? 74 79 B9 ? ? ? ?") + 2)

local checkIsHost = function() return core.readInteger(IS_HOST_ADDRESS) ~= 0 end

local namespace = {
  enable = function(self, config)
    local protocolNumber = modules.protocol:registerProtocol("config-similarity-protocol", "config-similarity-protocol", "DIRECT", 32, protocol)
    modules.chatcommands:registerChatCommand("checkconfigsimilarity", function(command)
      -- If you want to set up your data gathering before sending the command, do it here and now just like the game does

      if not checkIsHost() then
        return false, "This command is only available as a host"
      end

      modules.protocol:queueProtocol(protocolNumber)

      return false
    end)
  end,
  disable = function(self, config)
  end,
}

return namespace