-- Zubair
-- 2022/12/06
-- Storing a players data globally through different game servers


-- Setting the parent of this script to the ServerScriptService as a precaution
parent = game:GetService('ServerScriptService')

-- Obtaining data stored under the key "Global_Money_Datastore"
local DataStoreService = game:GetService("DataStoreService")
local myDataStore = DataStoreService:GetDataStore("Global_Money_Datastore")


-- When a new player is added to the game
game.Players.PlayerAdded:Connect(function(player)


	-- Data being manipulated, creates values stored under the player for IN-GAME use
	local bankMoney = Instance.new('NumberValue')
	bankMoney.Parent = player
	bankMoney.Name = "Bank"

	local walletMoney = Instance.new('NumberValue')
	walletMoney.Parent = player
	walletMoney.Name = "Wallet"


	-- Identifier used to distinguish and access the player's data
	local playerUserID = "Player_"..player.UserId


	-- Making the variable globally available ONLY throughout this FUNCTION, not the entire SCRIPT
	local data


	-- Similar to try and except in python
	local success, errormessage = pcall(function()

		-- Attempts to connect to the datastore and obtain the players data stored under the '-Bank'
		data = myDataStore:GetAsync(playerUserID.."-Finances")

	end)


	-- If data obtained, print 'success' and update the players data in-game ELSE it will print "failed" and the error reason returned by errormessage
	if success then
		print('success; player bank = '..data[1]..'; player wallet = '..data[2])
		bankMoney.Value = data[1]
		walletMoney.Value = data[2]
	else
		print('Failed: '..errormessage)
	end

end)


-- Saving the players data
game.Players.PlayerRemoving:Connect(function(player)


	-- Locating the stored data under the player
	local bankMoney = player:WaitForChild('Bank')
	local walletMoney = player:WaitForChild('Wallet')


	-- Setting the identifier again
	local PlayerUserID = "Player_"..player.UserId


	-- Combines the collected data into a table
	local data = {bankMoney.Value, walletMoney.Value}


	-- Similar to try, except in python: Attempts to connect to the servers and store the data
	local success, errormessage = pcall(function()

		myDataStore:SetAsync(PlayerUserID.."-Finances", data)

	end)


	-- If data successfully stored, print 'Saved!' else returns errormessage with reason
	if success then
		print("Saved!")
	else
		print("Error: "..errormessage)
	end
end)