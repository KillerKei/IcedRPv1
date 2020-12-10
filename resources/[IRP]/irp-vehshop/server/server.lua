irpCore              	= nil
Jobs 			= {}	-- jobs table
vehicles 		= {}	-- all vehicles
display 		= {}	-- display vehicles
categories 	= {}	-- all categories
PlyPlayTime 	= {}	-- table storing player game time

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

-- Fetch Jobs
MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

-- Get Online Car Dealers:
irpCore.RegisterServerCallback('irp-vehshop:GetDealerCount', function(source, cb, option)
	local Players = irpCore.GetPlayers()
	local dealers = 0
	for i = 1, #Players do
		local xPlayer = irpCore.GetPlayerFromId(Players[i])
		if xPlayer["job"]["name"] == Config.CarDealerJobLabel then
			dealers = dealers + 1
		end
	end
	local DealerOnline = false
	if dealers > 0 then
		DealerOnline = true
	end
	cb(DealerOnline)
end)

-- Event to edit commission:
RegisterNetEvent('irp-vehshop:DealerDiscountSV')
AddEventHandler('irp-vehshop:DealerDiscountSV', function(currentModel, percent, currentID)	
	local DisplayVehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicle_display WHERE model=@model",{['@model'] = currentModel})
	MySQL.Sync.execute("UPDATE vehicle_display SET commission=@commission WHERE id=@id",{['@commission'] = (DisplayVehicles[1].commission + percent), ['@id'] = currentID})
	TriggerClientEvent('irp-vehshop:DealerDiscountCL', -1)
end)

-- Event to edit downpayment:
RegisterNetEvent('irp-vehshop:DealerDownpaymentSV')
AddEventHandler('irp-vehshop:DealerDownpaymentSV', function(currentModel, dPayment, currentID)	
	local DisplayVehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicle_display WHERE model=@model",{['@model'] = currentModel})
	MySQL.Sync.execute("UPDATE vehicle_display SET downpayment=@downpayment WHERE id=@id",{['@downpayment'] = (DisplayVehicles[1].downpayment + dPayment), ['@id'] = currentID})
	TriggerClientEvent('irp-vehshop:DealerDownpaymentCL', -1)
end)

-- Event to change display vehicle:
RegisterNetEvent('irp-vehshop:ReplaceVehSV')
AddEventHandler('irp-vehshop:ReplaceVehSV', function(model, name, currentID)
	MySQL.Sync.execute("UPDATE vehicle_display SET model=@model WHERE id=@id",{['@model'] = model, ['@id'] = currentID})
	MySQL.Sync.execute("UPDATE vehicle_display SET name=@name WHERE id=@id",{['@name'] = name, ['@id'] = currentID})
	MySQL.Sync.execute("UPDATE vehicle_display SET commission=@commission WHERE id=@id",{['@commission'] = '10', ['@id'] = currentID})
	TriggerClientEvent('irp-vehshop:ReplaceVehCL', -1, model, currentID)
end)

-- Event to check finance status on player login:
RegisterNetEvent('irp-vehshop:CheckFinanceStatus')
AddEventHandler('irp-vehshop:CheckFinanceStatus', function()
	local xPlayer = irpCore.GetPlayerFromId(source)

	local foundOwedVeh = false
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(results) 
		-- Looping through results:
		for k,v in pairs(results) do
			if v.repaytime < 1 and v.finance > 1 then
				foundOwedVeh = true
			end	
		end
		
		if foundOwedVeh then
			-- Editing found vehicle:
			local warnTime = Config.WarningTime
			TriggerClientEvent('DoLongHudText', xPlayer.source,_U('veh_repossessed_warning',warnTime))
			Citizen.Wait(warnTime * 60000)
			MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(vehData) 
				-- loop through vehicles again and delete:
				for k,v in pairs(vehData) do
					if v.repaytime < 1 and v.finance > 1 then
						local vehPlate = v.plate
						local vehicle = json.decode(v.vehicle)
						local vehModel = vehicle.model
						MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {['@plate'] = vehPlate})
						TriggerClientEvent("irp-vehshop:UpdateCarDealerStockCL",-1,vehModel,vehPlate)
					end
				end
			end)
		end
	end)
end)

-- ACCOUNT MENU:
irpCore.RegisterServerCallback('irp-vehshop:GetAccountMoney', function(source, cb)
	local xPlayer = irpCore.GetPlayerFromId(source)
	local moneyOnPlayer = xPlayer.getMoney()
	local account = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name=@account_name', {['@account_name'] = 'society_cardealer'})	
	if not account[1] then
		return
	end
	cb(account[1].money,moneyOnPlayer)
end)

-- Callback to Withdraw Money:
irpCore.RegisterServerCallback('irp-vehshop:AccountsWithdraw', function(source, cb, amount)
	local xPlayer = irpCore.GetPlayerFromId(source)
	local account = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name=@account_name', {['@account_name'] = 'society_cardealer'})	
	local approved = false
	if account[1].money >= amount then
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name', {['@money'] = (account[1].money-amount), ['@account_name'] = 'society_cardealer'})
		approved = true
		if Config.UseCashMoney then
			xPlayer.addMoney(amount)
			TriggerClientEvent("banking:addBalance", amount)
		else
			xPlayer.addAccountMoney('bank', amount)
		end
	else
		approved = false
	end
	cb(approved)
end)
-- Callback to Deposit Money:
irpCore.RegisterServerCallback('irp-vehshop:AccountsDeposit', function(source, cb, amount)
	local xPlayer = irpCore.GetPlayerFromId(source)
	local approved = false
	if Config.UseCashMoney then
		if xPlayer.getMoney() >= amount then
			xPlayer.removeMoney(amount)
			TriggerClientEvent("banking:removeBalance", amount)
			approved = true
		else
			approved = false
		end
	else
		if xPlayer.getAccount('bank').money >= amount then 
			xPlayer.removeAccountMoney('bank', amount)
			approved = true
		else
			approved = false
		end
	end
	if approved then
		local account = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name=@account_name',{['@account_name'] = 'society_cardealer'})	
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name', {['@money'] = (account[1].money+amount), ['@account_name'] = 'society_cardealer'})
	end	
	cb(approved)
end)

-- EMPLOYEE MENU:
irpCore.RegisterServerCallback('irp-vehshop:getEmployees', function(source, cb, society)		
	-- Fetch employees:
	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}

		for i=1, #results, 1 do
			table.insert(employees, {
				name       = results[i].firstname .. ' ' .. results[i].lastname,
				identifier = results[i].identifier,
				job = {
					name        = results[i].job,
					label       = Jobs[results[i].job].label,
					grade       = results[i].job_grade,
					grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
					grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)
-- Set Job:
irpCore.RegisterServerCallback('irp-vehshop:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = irpCore.GetPlayerFromId(source)
	if xPlayer.job.grade_name == 'boss' then
		local xTarget = irpCore.GetPlayerFromIdentifier(identifier)
		if xTarget then
			xTarget.setJob(job, grade)
			if type == 'hire' then
				TriggerClientEvent('DoLongHudText', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('DoLongHudText', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('DoLongHudText', xTarget.source, _U('you_have_been_fired', xTarget.getJob().label))
			end
			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		cb()
	end
end)
-- Callback to Get online players:
irpCore.RegisterServerCallback('irp-vehshop:getOnlinePlayers', function(source, cb)
	local xPlayers = irpCore.GetPlayers()
	local players  = {}
	for i=1, #xPlayers, 1 do
		local xPlayer = irpCore.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end
	cb(players)
end)
-- Callback to get player job:
irpCore.RegisterServerCallback('irp-vehshop:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}
	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end
	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)
	job.grades = grades
	cb(job)
end)

-- Callback to get downpayment when financing:
irpCore.RegisterServerCallback('irp-vehshop:GetFinancingMoney', function(source, cb, dPayment, model, stock)	
	local xPlayer = irpCore.GetPlayerFromId(source)
	
	local carPrice = 0
	local commission = 0
	-- Check Bought Car with display table:
	for k,v in pairs(display) do
		if model == v.model then
			carPrice = v.price
			if v.commission then
				commission = v.commission
			end
		end
	end
	
	-- Calculate Car Price plus Commission:
	if commission ~= 0 and carPrice ~= 0 then
		commission = carPrice*(commission/100)
	end
		
	-- Check Player Money & commission:
	local hasUpfront = false
	local payment = 0
	if Config.PayWithCash then
		local money = xPlayer.getMoney()
		payment = money
	else
		local bank = xPlayer.getAccount("bank").money
		payment = bank
	end
	local downPayment = 0
	if carPrice ~= 0 then
		if commission > 0 or commission < 0 then 
			if payment >= ((carPrice + commission) * (dPayment/100)) then 
				hasUpfront = true
				carPrice = (carPrice + commission)
				downPayment = (carPrice * (dPayment/100))
			end
		else
			if payment >= (carPrice * (dPayment/100)) then 
				hasUpfront = true
				carPrice = carPrice
				downPayment = (carPrice * (dPayment/100))
			end
		end
	end	
	
	-- Stock Feature:
	if hasUpfront then
	-- Get Vehicle Stock:
	local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE model=@model",{['@model'] = model})	
	local StockAmount = GetVehDB[1].stock
		
	-- Remove Stock:
		MySQL.Async.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
		{
			['@stock'] = (StockAmount - 1),
			['@model'] = model
		})
	end
	
	cb(hasUpfront, downPayment, carPrice, commission, payment)
end)

-- Callback to sell owned vehicle and update dealer stock
irpCore.RegisterServerCallback('irp-vehshop:SellOwnedVehicle', function(source, cb, plate, price, model)
	local xPlayer = irpCore.GetPlayerFromId(source)
	local sellPrice = (price * (1-(Config.SellPercent/100)))
	
	-- Add Money to Player:
	if Config.ReceiveBankMoney then
		xPlayer.addAccountMoney("bank", sellPrice)
	else
		xPlayer.addMoney(sellPrice)
		TriggerClientEvent("banking:addBalance", sellPrice)
	end
	
	-- Get Vehicle Stock:
	local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE model=@model",{['@model'] = model})	
	local StockAmount = GetVehDB[1].stock
	
	-- Remove Vehicle:
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {['@plate'] = plate})
		
	-- Add Stock:
	MySQL.Async.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
	{
		['@stock'] = (StockAmount + 1),
		['@model'] = model
	})
		
	cb(true, sellPrice, plate, model)
end)

-- Callback to get player money upon purchasing vehicle from shop menu:
irpCore.RegisterServerCallback('irp-vehshop:ShopGetPlyMoney', function(source, cb, model, price)
	local xPlayer = irpCore.GetPlayerFromId(source)
	
	-- Check Player Money & commission:
	local gotMoney = false
	local payment = 0
	
	if Config.PayWithCash then
		local money = xPlayer.getMoney()
		payment = money
	else
		local bank = xPlayer.getAccount("bank").money
		payment = bank
	end
	
	if payment >= price then 
		gotMoney = true
	end	
	
	if gotMoney then
		-- Get Vehicle Stock:
		local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE model=@model",{['@model'] = model})	
		local StockAmount = GetVehDB[1].stock
		
		-- Remove Stock:
		MySQL.Async.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
		{
			['@stock'] = (StockAmount - 1),
			['@model'] = model
		})
	end
		
	cb(gotMoney, price, payment)
end)

-- Callback to add vehicle to DB purchased through shop menu:
RegisterNetEvent('irp-vehshop:ShopBuyAddCarToDB')
AddEventHandler('irp-vehshop:ShopBuyAddCarToDB', function(vehProps, price, payment, vehModel)
	local xPlayer = irpCore.GetPlayerFromId(source)
		
	-- get player money/bank balance:
	local PaymenType = payment
	
	-- Remove Money:
	if Config.PayWithCash then
		xPlayer.removeMoney(price)
		TriggerClientEvent("banking:removeBalance", price)
	else
		xPlayer.removeAccountMoney('bank', (price))
	end
	
	-- Current Date:
	local date = os.date('%Y-%m-%d')
	
	-- Add veh to database:
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, model) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @model)',
	{
		['@owner']   	= xPlayer.identifier,
		['@plate']   	= vehProps.plate,
		['@vehicle'] 	= json.encode(vehProps),
        ['@date']       = date,
		['@paidprice']  = price,
		['@model'] 		= vehModel
	})
end)

irpCore.RegisterServerCallback('irp-vehshop:GetPlayerMoney', function(source, cb, model, price, stock)
	local xPlayer = irpCore.GetPlayerFromId(source)
	
	local commission = 0
	local carPrice = 0
	-- Check Bought Car with display table:
	for k,v in pairs(display) do
		if model == v.model then
			carPrice = v.price
			if v.commission then
				commission = v.commission
			end
		end
	end
	
	-- Calculate Car Price plus Commission:
	if commission ~= 0 and carPrice ~= 0 then
		commission = carPrice*(commission/100)
	end
		
	-- Check Player Money & commission:
	local hasMoney = false
	local payment = 0
	if Config.PayWithCash then
		local money = xPlayer.getMoney()
		payment = money
	else
		local bank = xPlayer.getAccount("bank").money
		payment = bank
	end
	if carPrice ~= 0 then
		if commission > 0 or commission < 0 then 
			if payment >= (carPrice + commission) then 
				carPrice = (carPrice + commission) 
				hasMoney = true
			end
		else
			if payment >= carPrice then 
				carPrice = carPrice
				hasMoney = true
			end
		end
	end	
	
	-- Stock Feature:
	if hasMoney then
	-- Get Vehicle Stock:
	local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE model=@model",{['@model'] = model})	
	local StockAmount = GetVehDB[1].stock
		
	-- Remove Stock:
		MySQL.Async.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
		{
			['@stock'] = (StockAmount - 1),
			['@model'] = model
		})
	end
	
	cb(hasMoney, carPrice, commission, price, payment)
end)

RegisterNetEvent('irp-vehshop:AddFinancedVehToDB')
AddEventHandler('irp-vehshop:AddFinancedVehToDB', function(vehProps, downPayment, carPrice, commission, payment, currentModel)
	local xPlayer = irpCore.GetPlayerFromId(source)
	
	-- Get Current Car Dealer Account Money:
	local accMoney = MySQL.Sync.fetchAll("SELECT * FROM addon_account_data WHERE account_name=@account_name",{['@account_name'] = 'society_cardealer'})	
	local accBal = accMoney[1].money
	
	-- get player money/bank balance:
	local PaymenType = payment
	
	-- Remove Money:
	if commission > 0 or commission < 0 then 
		if Config.PayWithCash then
			xPlayer.removeMoney(downPayment)
			TriggerClientEvent("banking:removeBalance", downPayment)
		else
			xPlayer.removeAccountMoney('bank', (downPayment))
		end
		local accountInsert = 0
		if Config.DownPaymentToDealerShip then
			accountInsert = accBal + commission + downPayment
		else
			accountInsert = accBal + commission
		end
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = accountInsert,['@account_name'] = 'society_cardealer'})
	else
		if Config.PayWithCash then
			xPlayer.removeMoney(downPayment)
			TriggerClientEvent("banking:removeBalance", downPayment)
		else
			xPlayer.removeAccountMoney('bank', downPayment)
		end
		local accountInsert = 0
		if Config.DownPaymentToDealerShip then
			accountInsert = accBal + downPayment
		else
			accountInsert = accBal
		end
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = accountInsert,['@account_name'] = 'society_cardealer'})
	end
	
	-- Finace timer:
	local FinaceTime = (Config.MaxTimePerRepay * 60)
	
	-- Current Date:
	local date = os.date('%Y-%m-%d')
	
	-- Add veh to database:
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, finance, repaytime, model) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @finance, @repaytime, @model)',
	{
		['@owner']   	= xPlayer.identifier,
		['@plate']   	= vehProps.plate,
		['@vehicle'] 	= json.encode(vehProps),
        ['@date']       = date,
		['@paidprice']  = (carPrice - downPayment),
		['@finance']   	= math.floor((carPrice*((Config.InterestRate/100)+1)) - downPayment),
		['@repaytime'] 	= FinaceTime,
		['@model'] 		= currentModel
	})
end)

RegisterNetEvent('irp-vehshop:AddVehToDatabase')
AddEventHandler('irp-vehshop:AddVehToDatabase', function(vehProps, carPrice, commission, price, payment, currentModel)
	local xPlayer = irpCore.GetPlayerFromId(source)
	-- Get Current Car Dealer Account Money:
	local accMoney = MySQL.Sync.fetchAll("SELECT * FROM addon_account_data WHERE account_name=@account_name",{['@account_name'] = 'society_cardealer'})	
	local accBal = accMoney[1].money
	
	-- get player money/bank balance:
	local PaymenType = payment
	
	-- Remove Money:
	if commission > 0 or commission < 0 then 
		if Config.PayWithCash then
			xPlayer.removeMoney(carPrice)
			TriggerClientEvent("banking:removeBalance", carPrice)
		else
			xPlayer.removeAccountMoney('bank', (carPrice))
		end
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = accBal + commission,['@account_name'] = 'society_cardealer'})
	else
		if Config.PayWithCash then
			xPlayer.removeMoney(carPrice)
			TriggerClientEvent("banking:removeBalance", carPrice)
		else
			xPlayer.removeAccountMoney('bank', carPrice)
		end
	end
	
	-- Current Date:
	local date = os.date('%Y-%m-%d')
	
	-- Add veh to database:
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, model) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @model)',
	{
		['@owner']   	= xPlayer.identifier,
		['@plate']   	= vehProps.plate,
		['@vehicle'] 	= json.encode(vehProps),
        ['@date']       = date,
		['@paidprice']  = carPrice,
		['@model'] 		= currentModel
	})
end)

irpCore.RegisterServerCallback('irp-vehshop:GetOwnedVehByPlate',function(source, cb, plate)	
	local xPlayer = irpCore.GetPlayerFromId(source)
	local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = nil, 0, nil, 0, 0
	
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(vehData) 
		local vehFound = false
		for k,v in pairs(vehData) do
			if plate == v.plate then
				local vehicle = json.decode(v.vehicle)
				vehHash 		= vehicle.model
				vehPrice 		= v.paidprice
				vehPlate 		= v.plate
				vehFinance 		= v.finance
				vehRepaytime 	= v.repaytime
				vehFound 		= true
			end
		end
		
		if not vehFound then
			TriggerClientEvent('DoLongHudText', xPlayer.source, _U('not_own_that_plate'),2)
		end
		
		if vehFound then
			cb(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
		end
	end)
	
end)

irpCore.RegisterServerCallback('irp-vehshop:RepayAmount', function(source, cb, plate, amount)
	local xPlayer = irpCore.GetPlayerFromId(source)

	local paid
	if Config.PayWithBankMoney then
		if xPlayer.getAccount('bank').money >= amount then 
			xPlayer.removeAccountMoney('bank',amount)
			paid = true
		else
			paid = false
		end
	else	
		if xPlayer.getMoney() >= amount then
			xPlayer.removeMoney(amount)
			TriggerClientEvent("banking:removeBalance", amount)
			paid = true
		else
			paid = false
		end
	end
	local setTime
	if paid then 
		local curVeh = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate=@plate", {['@plate'] = plate})
		local financeAmount = curVeh[1].finance
		if financeAmount - amount <= 0 then
			setTime = 0
		else
			setTime = (Config.MaxTimePerRepay * 60)
		end
		MySQL.Sync.execute('UPDATE owned_vehicles SET finance=@finance WHERE plate=@plate',{['@finance'] = (financeAmount - amount), ['@plate'] = plate})
		MySQL.Sync.execute('UPDATE owned_vehicles SET repaytime=@repaytime WHERE plate=@plate',{['@repaytime'] = setTime, ['@plate'] = plate})
	end
	cb(paid)
end)

-- Give Registration Paper
RegisterServerEvent('irp-vehshop:GiveRegistrationPaper')
AddEventHandler('irp-vehshop:GiveRegistrationPaper', function(player, target, plate)
	local xPlayer = irpCore.GetPlayerFromId(player)
	local tPlayer = irpCore.GetPlayerFromId(target)
	local vehFound   = false
	
	local regOwner
	local regPlate = nil
	local date = os.date('%Y-%m-%d')
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@identifier',{['@identifier'] = xPlayer.identifier}, function(vehData) 
		for k,v in pairs(vehData) do
			if plate == v.plate then
				regOwner = v.owner
				regPlate = v.plate
				regVehicle = v.vehicle
				regPrice = v.paidprice
				regFinance = v.finance
				regRepaytime = v.repaytime
				regModel = v.model
				vehFound = true
			end
		end
		if vehFound then
			-- Delete Veh from xplayer identifier:
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {['@plate'] = plate})
		
			-- Add veh to database target identifier:
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, finance, repaytime, model) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @finance, @repaytime, @model)',
			{
				['@owner']   	= tPlayer.identifier,
				['@plate']   	= regPlate,
				['@vehicle'] 	= regVehicle,
				['@date']       = date,
				['@paidprice']  = regPrice,
				['@finance']   	= regFinance,
				['@repaytime'] 	= regRepaytime,
				['@model'] 		= regModel
			})
			TriggerClientEvent('DoLongHudText', xPlayer.source, _U('veh_owner_change'))
			TriggerClientEvent('DoLongHudText', tPlayer.source, _U('veh_owner_change2'))
		else
			TriggerClientEvent('DoLongHudText', xPlayer.source, _U('plate_not_exists'),2)
		end
	end)
end)


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- Fetch Car Dealer Core Data:
irpCore.RegisterServerCallback("irp-vehshop:FetchData", function(source, cb)
	vehicles = {}
	display = {}
	categories = {}
	-- Fetch Data:
	local data1 = MySQL.Sync.fetchAll('SELECT * FROM vehicles')
	local data2 = MySQL.Sync.fetchAll('SELECT * FROM vehicle_display')
	local data3 = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	-- vehicles:
	for k,v in pairs(data1) do
		table.insert(vehicles,{name = v.name, model = v.model, price = v.price, category = v.category, stock = v.stock})
	end
	-- display:
	for k,v in pairs(data2) do
		local price, category, gotPrice = 0, nil, false
		for _,y in pairs(vehicles) do
			if v.model == y.model then
				price = y.price
				category = y.category
				stock = y.stock
				gotPrice = true
			end
		end
		if gotPrice then
			table.insert(display,{id = v.id, model = v.model, name = v.name, price = price, category = category, stock = stock, commission = v.commission, downpayment = v.downpayment})
		end
	end
	-- categories:
	for k,v in pairs(data3) do
		table.insert(categories,{name = v.name, label = v.label})
	end
	
	cb(vehicles, display, categories)
end)

-- Callback to get all owned vehicles, with options:
irpCore.RegisterServerCallback('irp-vehshop:GetAllOwnedVehicles', function(source, cb, option)
    local xPlayer = irpCore.GetPlayerFromId(source)
    local plyVehicles = {}

    local foundVehicles = false
    MySQL.Async.fetchAll('SELECT * FROM '..Config.OwnedVehTable..' WHERE owner=@identifier',{['@identifier'] = xPlayer.identifier}, function(results)

            -- financing billing option:
            if option == "financing" then
                for k,v in pairs(results) do
                    if v.finance > 1 then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(plyVehicles,{plate = v.plate, vehicle = vehicle, date = v.date, price = v.paidprice, finance = v.finance, repaytime = v.repaytime, model = v.model})
                    end
                end
                cb(plyVehicles)

                -- sell vehicle option
            elseif option == "sellveh" then
                for k,v in pairs(results) do
                    if v.finance < 1 then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(plyVehicles,{plate = v.plate, vehicle = vehicle, date = v.date, price = v.paidprice, finance = v.finance, repaytime = v.repaytime, model = v.model})
                    end
                end
                cb(plyVehicles)
            end

    end)
end)


-- Callback to update vehicle stock upon repossession:
irpCore.RegisterServerCallback('irp-vehshop:UpdateDealerStock', function(source, cb, VehModel)
    local xPlayer = irpCore.GetPlayerFromId(source)
    -- Get Stock_
    local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE model=@model",{['@model'] = VehModel})
    local StockAmount = GetVehDB[1].stock

    -- Add Stock:
    MySQL.Async.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
        {
            ['@stock'] = (StockAmount + 1),
            ['@model'] = VehModel
        })
    cb(true)
end)


-- Callback to get new generated plate:
irpCore.RegisterServerCallback('irp-vehshop:PlateInUse', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM '..Config.OwnedVehTable..' WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)


-- Open Registration Paper
RegisterServerEvent('irp-vehshop:openRegSV')
AddEventHandler('irp-vehshop:openRegSV', function(player, target, plate)
    local xPlayer = irpCore.GetPlayerFromId(player)
    local tPlayer    = irpCore.GetPlayerFromId(target).source
    local vehFound   = false

    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function (user)
        local regPlate = nil
        local regDate
        local regFinance = 0
        local regModel = 0
        if (user[1] ~= nil) then
            MySQL.Async.fetchAll('SELECT * FROM '..Config.OwnedVehTable..' WHERE owner=@identifier',{['@identifier'] = xPlayer.identifier}, function(vehData)
                for k,v in pairs(vehData) do
                    if plate == v.plate then
                        regPlate = v.plate
                        regDate = v.date
                        regFinance = v.finance
                        regModel = v.model
                        vehFound = true
                    end
                end
                if vehFound then
                    local label
                    if regFinance > 0 then
                        label = _U('reg_payment_label1')
                    else
                        label = _U('reg_payment_label2')
                    end
                    local info = {
                        user = user,
                        regPlate = regPlate,
                        regDate = regDate,
                        regPayment = label,
                        regModel = regModel,
                    }
                    TriggerClientEvent('irp-vehshop:openRegCL', tPlayer, info, regPlate)
                else
                    TriggerClientEvent('DoLongHudText', xPlayer.source, _U('plate_not_exists'),2)
                end
            end)
        end
    end)
end)

-- Store in game time on player login:
AddEventHandler("playerConnecting", function()
    local identifiers = GetPlayerIdentifiers(source)
    local steamHEX
    for k,v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamHEX = v
            break
        end
    end
    local GameTimer = GetGameTimer()
    table.insert(PlyPlayTime, {identifier = steamHEX, time = GameTimer})
end)

-- Update game time to DB:
AddEventHandler('playerDropped', function()
    local identifiers = GetPlayerIdentifiers(source)
    local steamHEX
    for k,v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamHEX = v
            break
        end
    end

    local onlineTime = 0
    local curPlayer
    for k,v in pairs(PlyPlayTime) do
        if v.identifier == steamHEX then
            onlineTime = v.time
            curPlayer = k
        end
    end

    local playerID = steamHEX
    local results = MySQL.Sync.fetchAll('SELECT * FROM '..Config.OwnedVehTable..' WHERE owner=@identifier',{['@identifier'] = playerID})

    for k,v in pairs(results) do
        if v.finance >= 1 then
            MySQL.Sync.execute('UPDATE '..Config.OwnedVehTable..' SET repaytime=@repaytime WHERE plate=@plate', {['@repaytime'] = math.floor(v.repaytime - (((GetGameTimer() - onlineTime) / 1000) / 60)), ['@plate'] = v.plate} )
        end
    end
    table.remove(PlyPlayTime, curPlayer)
end)
