require("server.NoobHub")

hub = noobhub.new({ server = "54.237.82.157"; port = 1337; }); 

hub:subscribe({
  channel = "booska";  
    callback = function(message)
        Base:printTable(message)
    end;
});

hub:publish({
    message = {
        action  =  "Wowza",
        timestamp = system.getTimer()
    }
});

