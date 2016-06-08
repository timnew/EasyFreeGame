normal_attack_sent_event = script.generate_event_name()
landing_attack_sent_event = script.generate_event_name()

remote.add_interface("freeplay",
{
  set_attack_data = function(data)
    global.attack_data = data
  end,

  get_attack_data = function()
    return global.attack_data
  end,

  get_normal_attack_sent_event = function()
    return normal_attack_sent_event
  end,
})

init_attack_data = function()
  global.attack_data = {
    -- whether all attacks are enabled
    enabled = true,
    -- this script is allowed to change the attack values attack_count and until_next_attack
    change_values = true,
    -- what distracts the creepers during the attack
    distraction = defines.distraction.byenemy,
    -- number of units in the next attack
    attack_count = 5,
    -- time to the next attack
    until_next_attack = 60 * 60 * 60,
  }
end

script.on_init(function()
  init_attack_data()
end)
