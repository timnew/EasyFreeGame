
function registerPlayerApi(name, api)
  apis[name] = function(...)
     api(game.player, ...)
  end
end
apis.registerPlayerApi = registerPlayerApi

function registerGiveApi(name, api)
  apis[name] = function(...)
     api(injectPoints[game.player.index], ...)
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

function initItemsData()
  for _, item in pairs(game.item_prototypes) do
    local group = item.group.name
    local subgroup = item.subgroup.name

    local groupTable = ensureChildTable(groups, group)
    local subgroupTable = ensureChildTable(groupTable, subgroup)

    subgroupTable[item.name] = item.stack_size
    items[item.name] = item.stack_size
  end
end
apis.initItemsData = initItemsData
