
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
---local

RegisterNetEvent('damag:secure_menu')
AddEventHandler('damag:secure_menu', function(jobname)
  Citizen.Wait(200)
  szafkazarzadzanie(jobname)
end)
  
  function szafkazarzadzanie(jobname)  --- funkcja od menu dostepu szafki dla bossa
    ESX.TriggerServerCallback('secure:getEmployees', function(employees)
      local elements = {
        head = { ('Dane'),('Uprawnienia'),('Działanie'),('Usuń') },
        rows = {}
      }
  
      for i=1, #employees, 1 do
        table.insert(elements.rows, {
          data = employees[i],
          cols = {
            employees[i].name,
            employees[i].szafka,
            '{{' .. ('Nadaj') .. '|btnadaj}} {{' .. ('Odbierz') .. '|btodbierz}}',
            '{{' .. ('Usuń') .. '|btusun}}'
          },
        })
      end
  
  
      ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_', elements, function(data, menu)
        local employee = data.data
        if data.value == 'btnadaj' then
          TriggerServerEvent('secure_akcja',employee.identifier,"nadaj",jobname)
          menu.close()
          Citizen.Wait(100)
          TriggerEvent('damag:secure_menu',jobname)
        elseif data.value == 'btodbierz' then
          TriggerServerEvent('secure_akcja',employee.identifier,"odbierz",jobname) 
          menu.close()
          Citizen.Wait(100)
          TriggerEvent('damag:secure_menu',jobname)
        elseif data.value == 'btusun' then
          TriggerServerEvent('secure_delatecheck',employee.identifier,jobname) 
          menu.close()
  
        end
      end, function(data, menu)
        menu.close()
      end)
    end,jobname)
  end
  
  function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true,false)
  end

