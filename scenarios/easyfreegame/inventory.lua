global.injectPoints = {}

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)

  player.force.chart(player.surface, {
    {player.position.x - 200, player.position.y - 200},
    {player.position.x + 200, player.position.y + 200}
  })

  injectFullWeapons(player)
  injectFullArmor(player)
  resetInjectPointToPlayer(player)
  insertStartMaterial(buildEntityByPlayer(player, "steel-chest"))
end)

local apis = {}
local groups = {}
local items = {}

script.on_init(function()
  for _, item in pairs(game.item_prototypes) do
    local group = item.group.name
    local subGroup = item.subgroup.name

    if groups[group] == nil then
      groups[group] = {}
    end
    if groups[group][subGroup] == nil then
      groups[group][subGroup] = {}
    end

    table.insert(groups[group][subGroup], item.name)
    table.insert(items, item.name)
  end
end)

function registerPlayerApi(name, api)
  apis[name] = function(...)
     api(game.local_player, ...)
  end
end

function registerGiveApi(name, api)
  apis[name] = function(...)
     api(global.injectPoints[game.local_player.index], ...)
  end
end

function buildEntityByPlayer(player, type)
  local position = player.surface.find_non_colliding_position(type, player.position, 0, 0.1)

  local entity = player.surface.create_entity{
    name=type,
    position=position,
    force = game.forces.player
  }

  return entity
end

function getSelectedChest(player)
  if (player.selected == nil) then
    player.print("You must select Chest-like entity first, Logicstic Active Provider Chest is recommended")
    return nil
  end

  if (player.selected.get_inventory(defines.inventory.chest) == nil) then
    player.print("You selected Entity isn't a chest")
    return nil
  end

  return player.selected
end

function setInjectPointToChest(player, chest)
  if (chest == nil) then
    return
  end

  global.injectPoints[player.index] = player.selected
end

function resetInjectPointToPlayer(player)
  global.injectPoints[player.index] = player
end

registerPlayerApi("giveToMe", resetInjectPointToPlayer)
registerPlayerApi("giveToChest", function(player)
  setInjectPointToChest(player, getSelectedChest(player))
end)
registerPlayerApi("giveToNewChest", function(player)
  setInjectPointToChest(player, buildEntityByPlayer(player, "logistic-chest-active-provider"))
end)
registerPlayerApi("showApis", function(player)
  player.print("Apis:")
  for apiName, _ in pairs(apis) do
    player.print(apiName)
  end
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

  for _, item in ipairs(groups[group][subgroup]) do
    player.print(item)
  end
end

registerPlayerApi("showItems", function(player, group, subgroup)
  if group == nil then
    showGroups(player)
  elseif subgroup == nil then
    showSubGroup(player, group)
  else
    showItems(player, group, subgroup)
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
function insertItem(target, name, count)
  target.insert{name=name, count=toString(count)}
end
registerPlayerApi("giveMeItem", function(player, name, count)
  insertItem(player, name, count)
end)
registerGiveApi("giveItem", insertItem)
registerPlayerApi("researchAll", function(player)
  player.force.research_all_technologies()
end)

function insertAmmo(target, count)
  target.insert{name="explosive-bullet-magazine", count=tostring(100 * count)}
  target.insert{name="piercing-shotgun-shell", count=tostring(100 * count)}
  target.insert{name="explosive-rocket", count=tostring(100 * count)}
  target.insert{name="flame-thrower-ammo", count=tostring(50 * count)}
end
registerGiveApi("giveAmmo", insertAmmo)

function injectFullWeapons(target)
  target.insert{name="gatling-gun", count="1"}
  target.insert{name="combat-shotgun", count="1"}
  target.insert{name="rocket-launcher", count="1"}
  target.insert{name="flame-thrower", count="1"}

  insertAmmo(target, 1)
end

function injectFullArmor(target)
  target.insert{name="power-armor-mk2", count="1"}
  target.insert{name="personal-roboport-equipment", count="1"}
  target.insert{name="night-vision-equipment", count="1"}
  target.insert{name="basic-exoskeleton-equipment", count="1"}
  target.insert{name="battery-mk2-equipment", count="2"}
  target.insert{name="energy-shield-mk2-equipment", count="2"}
  target.insert{name="fusion-reactor-equipment", count="2"}
  target.insert{name="basic-laser-defense-equipment", count="1"}
  target.insert{name="basic-electric-discharge-defense-equipment", count="1"}
end

function insertStartMaterial(target)
  target.insert{name="wood", count="50"}
  target.insert{name="coal", count="200"}
  target.insert{name="stone", count="100"}
  target.insert{name="iron-plate", count="500"}
  target.insert{name="copper-plate", count="500"}
  target.insert{name="steel-plate", count="200"}
  target.insert{name="iron-gear-wheel", count="500"}
  target.insert{name="electronic-circuit", count="400"}
  target.insert{name="advanced-circuit", count="400"}
  target.insert{name="offshore-pump", count="5"}
  target.insert{name="pipe", count="50"}
  target.insert{name="boiler", count="20"}
  target.insert{name="basic-mining-drill", count="20"}
  target.insert{name="steam-engine", count="10"}
  target.insert{name="stone-furnace", count="50"}
  target.insert{name="basic-transport-belt", count="100"}
  target.insert{name="fast-transport-belt", count="50"}
  target.insert{name="basic-inserter", count="50"}
  target.insert{name="fast-inserter", count="50"}
  target.insert{name="long-handed-inserter", count="50"}
  target.insert{name="smart-inserter", count="50"}
  target.insert{name="medium-electric-pole", count="50"}
  target.insert{name="assembling-machine-1", count="50"}
  target.insert{name="assembling-machine-2", count="50"}
end

function insertMaterial(target)
  target.insert{name="iron-plate", count="500"}
  target.insert{name="copper-plate", count="500"}
  target.insert{name="steel-plate", count="200"}
  target.insert{name="iron-gear-wheel", count="500"}
  target.insert{name="iron-stick", count="100"}
  target.insert{name="copper-cable", count="600"}
  target.insert{name="electronic-circuit", count="400"}
  target.insert{name="advanced-circuit", count="400"}
  target.insert{name="processing-unit", count="100"}
  target.insert{name="plastic-bar", count="200"}
  target.insert{name="battery", count="200"}
end
registerGiveApi("giveMaterial", insertMaterial)

function insertInserter(target)
  target.insert{name="long-handed-inserter", count="50"}
  target.insert{name="fast-inserter", count="50"}
  target.insert{name="smart-inserter", count="50"}
end
registerGiveApi("giveInserter", insertInserter)

function insertTrain(target, count)
  target.insert{name="diesel-locomotive", count=tostring(count)}
  target.insert{name="cargo-wagon", count=tostring(count * 2)}
end
registerGiveApi("giveTrain", insertTrain)

function insertRail(target, count)
  target.insert{name="straight-rail", count=tostring(count * 50 * 4)}
  target.insert{name="curved-rail", count=tostring(count * 50)}
end
registerGiveApi("giveRail", insertRail)

function insertTrainSignal(target)
  target.insert{name="train-stop", count="2"}
  target.insert{name="rail-signal", count="50"}
  target.insert{name="rail-chain-signal", count="50"}
end
registerGiveApi("giveTrainSignal", insertTrainSignal)

function insertTrainStart(target)
  target.insert{name="straight-rail", count="150"}
  target.insert{name="curved-rail", count="50"}
  target.insert{name="train-stop", count="10"}
  target.insert{name="rail-signal", count="50"}
  target.insert{name="diesel-locomotive", count="5"}
  target.insert{name="cargo-wagon", count="5"}
end
registerGiveApi("giveTrainStart", insertTrainStart)

function insertLogisticStart(target)
  target.insert{name="logistic-chest-active-provider", count="5"}
  target.insert{name="logistic-chest-passive-provider", count="30"}
  target.insert{name="logistic-chest-requester", count="30"}
  target.insert{name="logistic-chest-storage", count="5"}
  target.insert{name="roboport", count="6"}
  target.insert{name="logistic-robot", count="50"}
  target.insert{name="construction-robot", count="20"}
end
registerGiveApi("giveLogisticStart", insertLogisticStart)

function insertLogisticChest(target)
  target.insert{name="logistic-chest-active-provider", count="5"}
  target.insert{name="logistic-chest-passive-provider", count="30"}
  target.insert{name="logistic-chest-requester", count="30"}
  target.insert{name="logistic-chest-storage", count="5"}
end
registerGiveApi("giveLogisticChest", insertLogisticChest)

function insertLogisticRobots(target)
  target.insert{name="logistic-robot", count="50"}
  target.insert{name="construction-robot", count="50"}
end
registerGiveApi("giveLogisticRobot", insertLogisticRobots)

remote.add_interface("easy", apis)
