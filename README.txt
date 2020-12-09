README
---------------------
SCRIPT MADE BY DAMAG
---------------------

1.Put this script into your servers file
2.Start it before any of the script that will use futures of it "start secure" / "ensure secure"
3.Import sql file to your database
First part is ready :)
Now open the script that u want to connect with it
-----------------------------------------------------------------
In Config.lua
-------------Only for this who dont have config------------------
If u dont have one then creat lua file with name Config.lua and paste this
```
Config = {}

```
and add in resource__ in client scripts this
```
"config.lua",
```
so it will looks like this
```
client_scripts {
	'client/main.lua',
	"config.lua"
}
```
----------If you have config done or u did it before -------------
Now add this into the config
```
Config.jobname = ""  --- example police
```
In brackets you must put the job name of the job u want to connect with like ambulance or police
NEXT
-----------------------------------------------------------------
In Client side [client.lua]
Put this code
```
local checkdone = false


Citizen.CreateThread(function() 
  while true do
  Citizen.Wait(1)
  if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobname then
	  if checkdone == false then
	  TriggerServerEvent('refresh_szafkadatamain',Config.jobname)
	  checkdone = true
	  end
  end
end
end)

```
-----------------------------------------------------------------
Great official part is done and now how to use it ? :)
To open boss menu with abillity to change the permission put
```
TriggerEvent('damag:secure_menu',Config.jobname)
```
To check if player have permission put
```
ESX.TriggerServerCallback('secure:checkstatus', function(status)
    for i=1, #status, 1 do
    if status[i].szafka == "Nadane" then
      YOUR FUNCTION HERE --- here u can put your function
  else
    notify("Nie masz dostępu do szafki")
    end
  end
end,Config.jobname)

function notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true,false)
end

```
I hope you enjoy it :) if you want to contact me you can use
discord -  damag#4013
email -  damag.dev@gmail.com
github -  damag.dev
