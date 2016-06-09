
function registerPlayerApi(name, api)
  apis[name] = function(...)
     api(game.local_player, ...)
  end
end
apis.registerPlayerApi = registerPlayerApi

function registerGiveApi(name, api)
  apis[name] = function(...)
     api(injectPoints[game.local_player.index], ...)
  end
end
apis.registerGiveApi = registerGiveApi

function registerBatch(batchName, data)
  local batch = ensureChildTable(batches, batchName)

  for _, item in ipairs(data) do
    local name, count = parseItem(item)

    if name then
      batch[name] = count
    end
  end
end
apis.registerBatch = registerBatch
