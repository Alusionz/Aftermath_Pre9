-- File: MMOCoreORB/bin/scripts/managers/jedi/jedi_account_unlock.lua

JediAccountUnlock = {}

-- Get the Jedi unlock status for the given account
-- Returns:
-- 0 = not unlocked
-- 1 = unlocked, slot not yet used
-- 2 = slot used
function JediAccountUnlock:getStatus(accountId)
    if accountId == nil then
        return 0
    end

    local query = string.format("SELECT unlock_status FROM account_jedi_unlock WHERE account_id = %d", accountId)
    local result = SceneObjectDatabase:selectQuery(query)

    if result:size() == 0 then
        return 0
    end

    return tonumber(result:getObject(0):getIntColumn("unlock_status"))
end

-- Set the Jedi unlock status for the given account
function JediAccountUnlock:setStatus(accountId, status)
    if accountId == nil or status == nil then
        return
    end

    local query = string.format(
        "REPLACE INTO account_jedi_unlock (account_id, unlock_status) VALUES (%d, %d)",
        accountId,
        status
    )
    SceneObjectDatabase:executeStatement(query)
end

-- Helper: Mark Jedi as unlocked (status = 1)
function JediAccountUnlock:unlockJediSlot(accountId)
    self:setStatus(accountId, 1)
end

-- Helper: Mark Jedi slot as used (status = 2)
function JediAccountUnlock:markJediSlotUsed(accountId)
    self:setStatus(accountId, 2)
end

-- Helper: Check if the Jedi slot is unlocked and available (status = 1)
function JediAccountUnlock:isJediSlotAvailable(accountId)
    return self:getStatus(accountId) == 1
end

-- Helper: Check if Jedi has already been used (status = 2)
function JediAccountUnlock:hasUsedJediSlot(accountId)
    return self:getStatus(accountId) == 2
end

return JediAccountUnlock
