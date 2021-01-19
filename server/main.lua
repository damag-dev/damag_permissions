ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--- uprawnienia do szafki

ESX.RegisterServerCallback('secure:getEmployees', function(source, cb, job)  --- tabela z pracownikami dla dostepu
		MySQL.Async.fetchAll('SELECT * FROM szafka WHERE job = @job', {['@job'] = job}, function (results)
			local employees = {}
            
			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
                    identifier = results[i].identifier,
                    szafka = results[i].szafka,
					job = {
						name = results[i].job,
						
					}
				})
			end
			cb(employees)
		end)
end)

RegisterServerEvent('secure_akcja')  --- czynnoci wykonywane przez menu
AddEventHandler('secure_akcja', function(identifier,type,job)
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == "nadaj" then
        MySQL.Async.execute('UPDATE szafka SET szafka = @szafka WHERE identifier = @identifier AND job = @job', {
			['@szafka'] = "Nadane",
			['@job'] = job,
            ['@identifier'] = identifier
        }, function()
            print("uprawnienia  do szafki dodane dla "..identifier.." "..job)
        end)   
    elseif type == "odbierz" then
        MySQL.Async.execute('UPDATE szafka SET szafka = @szafka WHERE identifier = @identifier  AND job = @job', {
			['@szafka'] = "Brak",
			['@job'] = job,
            ['@identifier'] = identifier
        }, function()
            print("uprawnienia do szafki odebrane dla "..identifier.." "..job)
        end)
    end
end)

RegisterServerEvent('refresh_szafkadatamain') --- sprawdzenie czy gracz jest w bazie
AddEventHandler('refresh_szafkadatamain', function(job)
local xPlayer = ESX.GetPlayerFromId(source)
local identifier = xPlayer.identifier
check(identifier,job)
end)

RegisterServerEvent('secure_delatecheck') --- pozwala na usuniecie z tabeli jesli job z tabeli nie jest taki sam jak job osoby np police - psycho
AddEventHandler('secure_delatecheck', function(identifier,job)
		local _source = source
local wynik = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
    ['@identifier'] = identifier
    })
    local user = wynik[1]
    local checkjob = user['job']
    if checkjob == job then
        print("Osoba nie może być usunięta / aktualna praca to - "..checkjob)
        TriggerClientEvent('esx:showNotification', _source, 'Ta osoba nadal jest zatrudniona nie może być ona usunięta')
    else
        MySQL.Async.execute('DELETE FROM szafka WHERE identifier = @identifier AND job = @job', {['@identifier'] = identifier,['@job'] = job})
        print(identifier.." został usunuięty z tabeli szafka praca - "..job)
        TriggerClientEvent('esx:showNotification', _source, 'Poprawne usunięcie z bazy')
    end
end)

function check(identifier,job) --- dodanie osoby do bazy
    MySQL.Async.fetchAll('SELECT * FROM szafka WHERE identifier = @identifier AND job = @job',
		{
          ['@identifier'] = identifier,  
          ['@job'] = job  
		},
        function(result)
            if result[1] == nil then
                local wynik = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
					['@identifier'] = identifier
                    })
        
               local user      = wynik[1]
               local imie     = user['firstname']
               local nazwisko      = user['lastname']
               local nazwisko      = user['lastname']
                MySQL.Async.execute('INSERT INTO szafka (identifier, job, szafka,firstname,lastname) VALUES (@identifier, @job, @szafka,@firstname,@lastname)',
                    {
                      ['@identifier'] = identifier,
                      ['@job']  = job,
                      ['@szafka']   = "Brak",
                      ['@firstname']   = imie,
                      ['@lastname']   = nazwisko,
                    })
                    print("Nowe dane zapisane dla "..imie.." "..nazwisko.." Praca - "..job)
                else
                    print("Dane znajdują się w bazie")
              
           end
        end)
end

ESX.RegisterServerCallback('secure:checkstatus', function(source, cb, job) --- sprawdzenie i zwrot info czy dostep jest przyznany
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT szafka FROM szafka WHERE identifier = @identifier AND job = @job', {
		['@identifier'] = identifier,
		['@job'] = job,
        ['@szafka'] = szafka
    }, function (result)
       
        cb(result)
    end)
end)

