script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)

  player.force.chart(player.surface, {
    {player.position.x - 200, player.position.y - 200},
    {player.position.x + 200, player.position.y + 200}
  })

  injectFullWeapons(player)
  injectFullArmor(player)
  resetInjectPointToPlayer(player)
end)

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

    groups[group][subGroup][item.name] = item.stack_size
    items[item.name] = item.stack_size
  end
end)

remote.add_interface("easy", apis)
