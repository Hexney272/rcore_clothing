CreateThread(function()
    if Config.Framework == 3 then
        ShowNotification = function(text)
            print(text)
        end

        GetPlayersJobName = function()
            return nil, false
        end

        GetPlayersJobGrade = function()
            return 0
        end
    end
end)
