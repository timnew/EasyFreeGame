function ensureChildTable(parent, name)
  local table = parent[name]

  if table == nil then
    table = {}
    parent[name] = table
  end

  return table
end

function parseItem(item)
  if type(item) == 'string' then
    local stackSize = items[item]

    if stackSize then
      return item, stackSize
    else
      game.local_player.print("Unkown Item:")
      game.local_player.print(item)
      return nil
    end

  elseif type(item) == 'table' then
    local stackSize = items[item.name]

    if stackSize == nil then
      game.local_player.print("Unkown Item:")
      game.local_player.print(item)
    end

    if item.count then
      return item.name, item.count
    elseif item.stackCount then
      return item.name, item.stackCount * stackSize
    else
      return item.name, stackSize
    end
  end
end

function isChest(entity)
  return entity.get_inventory(defines.inventory.chest) ~= nil
end

function getSelectedChest(player)
  if player.selected == nil then
    player.print("You must select Chest-like entity first, Logicstic Active Provider Chest is recommended")
    return nil
  end

  if not isChest(player.selected) then
    player.print("You selected Entity isn't a chest")
    return nil
  end

  return player.selected
end
