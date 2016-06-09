
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
    local name, normalizeItem = normalizeItem(item)

    if name then
      batch[name] = normalizeItem
    end
  end
end
apis.registerBatch = registerBatch

function duplicateBatch(originalBatch, newBatch)
  registerBatch(newBatch, ensureChildTable(batches, originalBatch))
end
apis.duplicateBatch = duplicateBatch
