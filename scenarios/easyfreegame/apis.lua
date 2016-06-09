registerPlayerApi("showApis", function(player)
  player.print("Apis:")
  for apiName, _ in pairs(apis) do
    player.print(apiName)
  end
end)

registerPlayerApi("researchAll", function(player)
  player.force.research_all_technologies()
end)

function buildEntityByPlayer(player, type)
  local position = player.surface.find_non_colliding_position(type, player.position, 0, 0.1)

  local entity = player.surface.create_entity{
    name=type,
    position=position,
    force = game.forces.player
  }

  return entity
end
registerPlayerApi("buildEntity", buildEntityByPlayer)

function setInjectPointToChest(player, chest)
  if chest == nil then
    return
  end

  injectPoints[player.index] = player.selected
end
function resetInjectPointToPlayer(player)
  injectPoints[player.index] = player
end
registerPlayerApi("giveTo", function(player, target)
  if target == nil or target == "me" or target == "player" then
    resetInjectPointToPlayer(player)
    return
  end

  local chest = getSelectedChest(player)
  if chest ~= nil then
    setInjectPointToChest(player, chest)
    return
  end

  if target == "active-chest" then
    setInjectPointToChest(player, buildEntityByPlayer(player, "logistic-chest-active-provider"))
    return
  elseif target == "storage-chest" then
    setInjectPointToChest(player, buildEntityByPlayer(player, "logistic-chest-storage"))
    return
  end

  chest = buildEntityByPlayer(player, target)
  if not isChest(chest) then
    player.print(taget ".. is't a chest")
    return
  end
  setInjectPointToChest(player, chest)
end)

function showGroups(player)
  player.print("Groups:")

  for group, _ in pairs(groups) do
    player.print(group)
  end
end
function showSubGroup(player, group)
  player.print("Sub-Groups in " .. group .. ":")

  for subgroup, _ in pairs(groups[group]) do
    player.print(subgroup)
  end
end
function showItems(player, group, subgroup)
  player.print("Items in " .. group .. "." .. subgroup .. ":")

  for item, _ in pairs(groups[group][subgroup]) do
    player.print(item)
  end
end
registerPlayerApi("showItems", function(player, group, subgroup, name, count)
  if group == nil then
    showGroups(player)
  elseif subgroup == nil then
    showSubGroup(player, group)
  elseif name == nil then
    showItems(player, group, subgroup)
  else
    insertItem(player, name, count)
  end
end)

registerPlayerApi("findItem", function(player, pattern)
  player.print("Find item includes " .. pattern)

  for _, name in ipairs(items) do
    if string.find(name, pattern) then
      player.print(name)
    end
  end
end)

function insertItem(target, item)
  local name, count = parseItem(item)
  if name then
    target.insert{name=name, count=tostring(count)}
  end
end
registerGiveApi("giveItem", insertItem)
registerPlayerApi("giveMeItem", insertItem)

function insertBatch(target, batchName)
  local batch = batches[batchName]

  if batch == nil then
    game.local_player.print("Unknown batch " .. batchName)
    return
  end

  for name, count in pairs(batch) do
    target.insert{name=name, count=tostring(count)}
  end
end
registerGiveApi("giveBatch", insertBatch)
registerPlayerApi("giveMeBatch", insertBatch)
