remote.add_interface("easy", apis)

script.on_init(function()
  for _, item in pairs(game.item_prototypes) do
    local group = item.group.name
    local subgroup = item.subgroup.name

    local groupTable = ensureChildTable(groups, group)
    local subgroupTable = ensureChildTable(groupTable, subgroup)

    subgroupTable[item.name] = item.stack_size
    items[item.name] = item.stack_size
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)

  player.force.chart(player.surface, {
    {player.position.x - 200, player.position.y - 200},
    {player.position.x + 200, player.position.y + 200}
  })

  insertBatch(player, "fullArmor")
  insertBatch(player, "weapon")
  insertBatch(player, "ammo")
  resetInjectPointToPlayer(player)
end)
