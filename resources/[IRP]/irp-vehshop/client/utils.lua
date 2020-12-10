-- GENERATE PLATE:
local NumChar = {}
local LetChar = {}

for i = 48,  57 do table.insert(NumChar, string.char(i)) end
for i = 65,  90 do table.insert(LetChar, string.char(i)) end
for i = 97, 122 do table.insert(LetChar, string.char(i)) end

-- Function to generate random number plate:
function ProduceNumberPlate()
	local plateToUse
	local breakFunction = false
	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			plateToUse = string.upper(GetRanPlateNum(Config.PlateNumbers) .. ' ' .. GetRandLetter(Config.PlateLetters) .. ' ' .. GetRanPlateNum(Config.PlateNumlast))
		else
			plateToUse = string.upper(GetRanPlateNum(Config.PlateNumbers) .. GetRandLetter(Config.PlateLetters) .. GetRanPlateNum(Config.PlateNumlast))
		end
		
		-- Checks if plate already exists:
		irpCore.TriggerServerCallback('irp-vehshop:PlateInUse', function (PlateInUse)
			if not PlateInUse then
				breakFunction = true
			end
		end, plateToUse)

		if breakFunction then
			break
		end
	end
	return plateToUse
end

-- Function to generate random numbers:
function GetRanPlateNum(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRanPlateNum(length - 1) .. NumChar[math.random(1, #NumChar)]
	else
		return ''
	end
end

-- Function to generate random letters:
function GetRandLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandLetter(length - 1) .. LetChar[math.random(1, #LetChar)]
	else
		return ''
	end
end

-- Chat suggestions:
TriggerEvent('chat:addSuggestion', '/registration', 'View og Show or Give vehicle registration paper.', {
	{ name="option", help="choose between: view or show" },
	{ name="plate", help="type in the plate nr" }
})

-- Chat suggestions:
TriggerEvent('chat:addSuggestion', '/finance', 'Check or Pay a repayment.', {
	{ name="option", help="Type: repay / check" },
	{ name="plate", help="type in the plate" },
	{ name="amount", help="if command repay, then add repayment amount as 3rd arugment, else leave it" }
})

-- Finance Command:
RegisterCommand('finance', function(source, args)
	local option = args[1]
	local plate = args[2]
	local amount = tonumber(args[3])
	
	if option == "repay" then
		if plate ~= nil or not plate == '' then
			if amount ~= nil or amount >= 1 then
				irpCore.TriggerServerCallback('irp-vehshop:GetOwnedVehByPlate', function(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
					local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = vehPlate, vehPrice, vehHash, vehFinance
					if vehFinance < 1 then
						TriggerEvent('DoLongHudText', "This vehicle is already completely paid")
					else
						local diffFP = (vehFinance / vehPrice)
						local repayMoney = ((vehPrice * diffFP) / Config.AmountOfRepayments)				
						local difference = 0
						if vehFinance > vehPrice then
							difference = (vehFinance - vehPrice) + repayMoney
						else
							difference = repayMoney
						end
						if amount < difference then 
							TriggerEvent('DoLongHudText', "Current repayment is at least: $"..math.floor(difference).."")
							return 
						else
							irpCore.TriggerServerCallback('irp-vehshop:RepayAmount', function(hasPaid) 
								if hasPaid then 
									TriggerEvent('DoLongHudText', "You paid $"..math.floor(amount).." to the financing")
								else 
									TriggerEvent('DoLongHudText', _U('not_enough_money'))
								end
							end, vehPlate, amount)
						end
					end
				end, plate)
				
			else
				TriggerEvent('DoLongHudText', _U('invalid_amount'))
			end
		else
			TriggerEvent('DoLongHudText', _U('plate_nil'))
		end
		
	elseif option == "check" then
		if plate ~= nil or not plate == '' then
			irpCore.TriggerServerCallback('irp-vehshop:GetOwnedVehByPlate', function(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
				local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime
				
				if vehFinance < 1 then
					TriggerEvent('DoLongHudText', "This vehicle is already completely paid")
				else
					TriggerEvent('DoLongHudText', "Amount Owed: $"..vehFinance..". Pay Next Repayment Before: "..math.floor(vehRepaytime/60).." Hours")
				end
				
			end, plate)
		else
			TriggerEvent('DoLongHudText', _U('plate_nil'), 2)
		end
	end	
end, false)

-- Registration Command:
RegisterCommand('registration', function(source, args)
	local option = args[1]
	local plate = args[2]	
	-- View Registration Paper:	
	if option == "view" then
		TriggerServerEvent('irp-vehshop:openRegSV', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), plate)	
	-- Show Registration Paper:
	elseif option == "show" then
		local player, distance = irpCore.Game.GetClosestPlayer()
		if distance ~= -1 and distance <= 2.0 then
			TriggerServerEvent('irp-vehshop:openRegSV', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), plate)
		else
			TriggerEvent('DoLongHudText', _U('nobody_near'),2)
		end	
	-- Give Registration Paper:
	elseif option == "give" then
		local player, distance = irpCore.Game.GetClosestPlayer()
		if distance ~= -1 and distance <= 2.0 then
			TriggerServerEvent('irp-vehshop:GiveRegistrationPaper', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), plate)
		else
			TriggerEvent('DoLongHudText', _U('nobody_near'), 2)
		end	
	end	
end, false)

-- Change text / pos inside the DrawText3Ds functions:
function DrawTextOptions(carPos,currentName,currentDownpayment,currentCommission,swapCar,currentPrice,currentStock)
	if (PlayerData.job ~= nil and PlayerData.job.name == Config.CarDealerJobLabel) then
		-- info
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.6, ""..currentName.." | $"..comma_value(math.floor(currentPrice + (currentPrice * (currentCommission / 100)))).." | "..currentCommission.."% Commission | "..currentStock.." PCS")
		-- buttons:
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.54, "[E] Buy | [H] Test-Drive | "..swapCar)
		-- finance:
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.48, "[L] Finance | "..currentDownpayment.."% Downpayment | $"..comma_value(math.floor((currentPrice + (currentPrice * (currentCommission / 100))) * (currentDownpayment/100))).."")
		-- cost display:
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.42, ""..Config.InterestRate.."% Interest Rate | $"..comma_value(math.floor((currentPrice + (currentPrice * (currentCommission / 100))) * ((Config.InterestRate/100)+1))).." Total Cost ")
	else
		-- info
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.6, ""..currentName.." | $"..comma_value(math.floor(currentPrice + (currentPrice * (currentCommission / 100)))).." | "..currentStock.." PCS")
		-- buttons:
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.54, " [E] Buy | "..currentCommission.."% Commission")
		-- finance:
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.48, "[L] Finance | "..currentDownpayment.."% Downpayment | $"..comma_value(math.floor((currentPrice + (currentPrice * (currentCommission / 100))) * (currentDownpayment/100))).."")
		-- cost display:
		DrawText3Ds(carPos[1],carPos[2],carPos[3] + 0.42, ""..Config.InterestRate.."% Interest Rate | $"..comma_value(math.floor((currentPrice + (currentPrice * (currentCommission / 100))) * ((Config.InterestRate/100)+1))).." Total Cost ")
	end
end

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

	local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
	
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
	
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	end
end

-- Car Dealer Map Blip:
function CreateDealerBlip()
	for k,v in pairs(Config.Blip) do
		if v.Enable then
			local blip = AddBlipForCoord(v.Pos[1], v.Pos[2], v.Pos[3])
			SetBlipSprite (blip, v.Sprite)
			SetBlipDisplay(blip, v.Display)
			SetBlipScale  (blip, v.Scale)
			SetBlipColour (blip, v.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.Name)
			EndTextCommandSetBlipName(blip)
		end
	end	
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end