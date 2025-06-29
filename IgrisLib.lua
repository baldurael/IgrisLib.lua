getgenv().IgrisLib = {}

function IgrisLib.Notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "IgrisLib",
        Text = text,
        Duration = 5
    })
end
