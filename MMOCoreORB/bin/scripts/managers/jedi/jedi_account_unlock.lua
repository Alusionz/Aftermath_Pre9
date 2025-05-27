local JediAccountUnlock = {}

local db = require("utils.database")

-- Check the Jedi unlock status for an account
-- 0 = locked, 1 = unlocked, 2 = used
function JediAccountUnlock:getStatus(accountId)
    local res = db:select("SELECT status FROM jedi_unlocks WHERE account_id = %d", accountId)
    if res and #res > 0 then
        local status = res[1].status
        if status == "unlocked" then
            return 1
        elseif status == "used" then
            return 2
        end
    end
    return 0
end

-- Unlock the Jedi slot for the account (sets status to 'unlocked')
function JediAccountUnlock:unlockJediSlot(accountId)
    local current = self:getStatus(accountId)
    if current == 0 then
        db:execute("INSERT INTO jedi_unlocks (account_id, status) VALUES (%d, 'unlocked')", accountId)
    end
end

-- Mark that the Jedi slot has been used (sets status to 'used')
function JediAccountUnlock:markJediSlotUsed(accountId)
    local current = self:getStatus(accountId)
    if current == 1 then
        db:execute("UPDATE jedi_unlocks SET status = 'used' WHERE account_id = %d", accountId)
    end
end

-- Check if a Jedi character can be created
function JediAccountUnlock:isJediSlotAvailable(accountId)
    return self:getStatus(accountId) == 1
end

return JediAccountUnlock
