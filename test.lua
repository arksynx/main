local Lighting = game:GetService("Lighting")

for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then
        v:Destroy()
    end
end

local sky = Instance.new("Sky")
sky.SkyboxBk = "rbxassetid://127331257508011"
sky.SkyboxDn = "rbxassetid://127331257508011"
sky.SkyboxFt = "rbxassetid://127331257508011"
sky.SkyboxLf = "rbxassetid://127331257508011"
sky.SkyboxRt = "rbxassetid://127331257508011"
sky.SkyboxUp = "rbxassetid://127331257508011"
sky.Parent = Lighting
