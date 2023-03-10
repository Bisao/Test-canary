local unban = TalkAction("/unban")

function unban.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local resultId = db.storeQuery("SELECT `account_id`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		return false
	end

	db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. Result.getNumber(resultId, "account_id"))
	db.asyncQuery("DELETE FROM `ip_bans` WHERE `ip` = " .. Result.getNumber(resultId, "lastip"))
	Result.free(resultId)
	player:sendTextMessage(MESSAGE_LOOK, param .. " has been unbanned.")
	return false
end

unban:separator(" ")
unban:register()
