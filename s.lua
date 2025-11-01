local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- === 🔑 Настройки ключа ===
local correctKey = loadstring(game:HttpGet("https://indiwidee.github.io/99api/"))()
local accessGranted = false

-- === 🌈 UI ===
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "UltimatePanel"

-- === 🧱 Окно ввода ключа ===
local keyFrame = Instance.new("Frame", screenGui)
keyFrame.Size = UDim2.new(0, 300, 0, 180)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.BorderSizePixel = 0
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 15)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1, 0, 0, 40)
keyTitle.Text = "🔒 type key for access"
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 20
keyTitle.BackgroundTransparency = 1
keyTitle.TextColor3 = Color3.new(1, 1, 1)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
keyBox.PlaceholderText = "Take key in tg@forestcheat_bot"
keyBox.Font = Enum.Font.GothamBold
keyBox.TextSize = 18
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 10)

local confirmButton = Instance.new("TextButton", keyFrame)
confirmButton.Size = UDim2.new(0.8, 0, 0, 40)
confirmButton.Position = UDim2.new(0.1, 0, 0.7, 0)
confirmButton.Text = "✅"
confirmButton.Font = Enum.Font.GothamBold
confirmButton.TextSize = 18
confirmButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
confirmButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", confirmButton).CornerRadius = UDim.new(0, 10)

local infoLabel = Instance.new("TextLabel", keyFrame)
infoLabel.Size = UDim2.new(1, 0, 0, 30)
infoLabel.Position = UDim2.new(0, 0, 0.85, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
infoLabel.Text = ""

-- === 📜 Главная панель (скрыта пока не введён ключ) ===
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 330, 0, 320)
mainFrame.Position = UDim2.new(0.5, -165, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
  ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 0)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0))
}
gradient.Rotation = 45

-- === 🔑 Проверка ключа ===
confirmButton.MouseButton1Click:Connect(function()
  if keyBox.Text == correctKey then
    infoLabel.Text = "✅ Доступ разрешён!"
    infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

    -- Плавно скрываем окно ввода ключа
    TweenService:Create(keyFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    for _, obj in pairs(keyFrame:GetDescendants()) do
      if obj:IsA("GuiObject") then
        -- Исправлена ошибка: TextTransparency только для TextLabel/TextBox/TextButton
        if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") then
          TweenService:Create(obj, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        end
        -- Также скроем фоны
        if obj.BackgroundTransparency == 0 then
          TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        end
      end
    end

    task.wait(0.6)
    keyFrame:Destroy()

-- 🎉 Показываем панель
    mainFrame.Visible = true
    accessGranted = true
    -- Инициализируем язык после того, как панель станет видимой
    updateLang()
  else
    infoLabel.Text = "❌ Неверный ключ!"
    infoLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
  end
end)

-- *** Функционал перетаскивания (Drag) ***
local dragging = false
local dragStart, startPos

local function updateDrag(input)
  local delta = input.Position - dragStart
  mainFrame.Position = UDim2.new(
    startPos.X.Scale, startPos.X.Offset + delta.X,
    startPos.Y.Scale, startPos.Y.Offset + delta.Y
  )
end

mainFrame.InputBegan:Connect(function(input)
  -- Проверяем, что клик был по самому фрейму, а не по его дочерним элементам
  if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Target == mainFrame then
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
  end
end)

UserInputService.InputChanged:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseMovement then
    if dragging then
      updateDrag(input)
    end
  end
end)

UserInputService.InputEnded:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 then
    dragging = false
  end
end)
-- *****************************************

-- === 🧾 Элементы интерфейса ===
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚙️99 Night in Forest script by"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local function makeButton(text, y)
  local btn = Instance.new("TextButton", mainFrame)
  btn.Size = UDim2.new(0.8, 0, 0, 40)
  btn.Position = UDim2.new(0.1, 0, y, 0)
  btn.Text = text
  btn.Font = Enum.Font.GothamBold
  btn.TextSize = 20
  btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
  btn.TextColor3 = Color3.new(1, 1, 1)
  Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
  return btn
end

local tpButton = makeButton("Teleport", 0.18)
local equipButton = makeButton("Equip Tool", 0.33)
local espButton = makeButton("ESP: OFF", 0.48)
local noclipButton = makeButton("Noclip: OFF", 0.63)
local langButton = makeButton("🌐 Switch to Russian", 0.78)
langButton.TextSize = 16

-- === 🔤 Языки ===
local lang = "EN"
local espEnabled = false -- Перенесено сюда для доступа в updateLang
local noclipEnabled = false -- Перенесено сюда для доступа в updateLang
local texts = {
  ["EN"] = {
    Title = "99 Forest Script",
    Teleport = "Teleport",
    Equip = "Equip Tool",
    ESPon = "ESP: ON",
    ESPoff = "ESP: OFF",
    NoclipOn = "Noclip: ON",
    NoclipOff = "Noclip: OFF",
    Switch = "🌐 Switch to Russian",
  },
  ["RU"] = {
    Title = "⚙️99 ночей скрипт", -- Добавлен эмодзи для соответствия стилю
    Teleport = "Телепорт",
    Equip = "Взять предмет",
    ESPon = "ESP: ВКЛ",
    ESPoff = "ESP: ВЫКЛ",
    NoclipOn = "Noclip: ВКЛ",
    NoclipOff = "Noclip: ВЫКЛ",
    Switch = "🌐 Переключить на English",
  }
}

local function updateLang()
  local t = texts[lang]
  title.Text = t.Title
  tpButton.Text = t.Teleport
  equipButton.Text = t.Equip
  -- Обновление текста кнопок ESP и Noclip с учетом их текущего состояния
  espButton.Text = espEnabled and t.ESPon or t.ESPoff
  noclipButton.Text = noclipEnabled and t.NoclipOn or t.NoclipOff
  langButton.Text = t.Switch
end

langButton.MouseButton1Click:Connect(function()
  lang = (lang == "EN") and "RU" or "EN"
  updateLang()
end)

-- === 🎯 Телепорт ===
local teleportTargets = {}

-- Улучшенный поиск: Ищет объекты/модели с "kid" в имени во всем Workspace.
for _, obj in pairs(workspace:GetDescendants()) do
  -- Проверяем, является ли объект частью или моделью
  if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("MeshPart") then
    -- Проверяем, есть ли "kid" в имени (без учёта регистра)
    if string.find(string.lower(obj.Name), "kid") then
      table.insert(teleportTargets, obj)
    end
  end
end

print("Найдено объектов для телепорта:", #teleportTargets)

tpButton.MouseButton1Click:Connect(function()
  if not accessGranted then return end -- Защита от использования до ввода ключа
  if #teleportTargets == 0 then
    print("Цели для телепорта не найдены.")
    return
  end

  -- Телепорт к первой найденной цели
  local target = teleportTargets[1]
  local targetPart = target.PrimaryPart or (target:IsA("BasePart") and target) or (target:IsA("Model") and target:FindFirstChildOfClass("BasePart"))

  if targetPart and character and character:FindFirstChild("HumanoidRootPart") then
    -- Используем :SetPrimaryPartCFrame или просто CFrame для модели/персонажа
    character:SetPrimaryPartCFrame(targetPart.CFrame * CFrame.new(0, 5, 0)) -- Телепорт чуть выше цели
    print("Телепортирован к:", target.Name)
  else
    print("Не удалось найти часть для телепортации у цели.")
  end

  -- Удалена задержка (wait(10)), чтобы не блокировать скрипт на 10 секунд
  -- Если вам нужно, чтобы телепорт был один раз, замените цикл на код выше и добавьте 'return'
end)

-- === ⚔️ Взять инструмент ===
equipButton.MouseButton1Click:Connect(function()
  if not accessGranted then return end
  local backpack = player:WaitForChild("Backpack")
  -- Ищем первый попавшийся инструмент в рюкзаке
  local tool = backpack:FindFirstChildOfClass("Tool")
  if tool then
    tool.Parent = character -- Перемещаем инструмент в персонажа
    print("Инструмент экипирован:", tool.Name)
  else
    print("Инструмент не найден в рюкзаке.")
  end
end)

-- === 👁 ESP ===
local espObjects = {}

-- Функция создания подсветки
local function createESP(part, color)
  -- Проверяем, что подсветка для этой части еще не создана
  if espObjects[part] then return end

  local highlight = Instance.new("Highlight")
  highlight.Adornee = part
  highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  highlight.FillColor = color
  highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
  highlight.Parent = part
  espObjects[part] = highlight
end

-- Удаление всех подсветок
local function removeESP()
  for part, h in pairs(espObjects) do
    if h and h.Parent then h:Destroy() end
  end
  espObjects = {}
end

-- Проверка, является ли объект ресурсом
local function isResource(name)
  name = string.lower(name)
  -- Проверяем по имени части/меша
  return string.find(name, "log_cylinder")
    or string.find(name, "grape")
    or string.find(name, "bolt")
    or string.find(name, "carrot")
    -- Добавлены общие слова, которые могут указывать на ресурс
    or string.find(name, "resource")
    or string.find(name, "collect")
end

-- Проверка, является ли объект живым существом (NPC/Player)
local function isEntity(obj)
  if obj:IsA("Model") then
    local humanoid = obj:FindFirstChildOfClass("Humanoid")
    return humanoid ~= nil and humanoid.Health > 0 -- Убедимся, что это не мертвый персонаж
  end
  return false
end

-- Новая функция: Проверка, является ли объект "Body" (телом/частью тела)
local function isBody(obj)
  -- Ищем части тела или части, которые могут быть "телом"
  local name = string.lower(obj.Name)
  return obj:IsA("BasePart") and (
    string.find(name, "body") or
      string.find(name, "torso") or
      string.find(name, "head") or
      string.find(name, "leg") or
      string.find(name, "arm")
  )
end

-- Переключение ESP
local function toggleESP()
  local t = texts[lang]
  espEnabled = not espEnabled
  espButton.Text = espEnabled and t.ESPon or t.ESPoff

  if espEnabled then
    print("ESP включён ✅")
    local itemsFound = 0

    -- Улучшенный поиск: Ищем во всем Workspace, включая вложенные модели.
    for _, obj in pairs(workspace:GetDescendants()) do
      -- Пропускаем UI, скрипты, части игрока и т.д.
      if obj.Parent == player.Character then continue end
      if obj.Parent == player.Backpack then continue end
      if obj.Name == "Terrain" then continue end

if isEntity(obj) then
        createESP(obj, Color3.fromRGB(255, 50, 50)) -- 🔴 Красный для сущностей
        itemsFound = itemsFound + 1
      elseif isBody(obj) then
        -- Добавлено: Подсветка "тела"
        createESP(obj, Color3.fromRGB(255, 150, 0)) -- 🟠 Оранжевый для "тела"
        itemsFound = itemsFound + 1
      elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
        if isResource(obj.Name) then
          createESP(obj, Color3.fromRGB(50, 100, 255)) -- 🔵 Синий для ресурсов
          itemsFound = itemsFound + 1
        end
      end
    end
    print("Найдено объектов для ESP:", itemsFound)
  else
    print("ESP выключен ❌")
    removeESP()
  end
end

-- Обработка клика по кнопке ESP
espButton.MouseButton1Click:Connect(function()
  if not accessGranted then return end
  toggleESP()
end)

-- Обработка нажатия клавиши 'L'
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
  if not gp and input.KeyCode == Enum.KeyCode.L and accessGranted then
    toggleESP()
  end
end)

-- === 🚫 Noclip ===
noclipButton.MouseButton1Click:Connect(function()
  if not accessGranted then return end
  local t = texts[lang]
  noclipEnabled = not noclipEnabled
  noclipButton.Text = noclipEnabled and t.NoclipOn or t.NoclipOff

  -- Сброс CanCollide для игрока, если Noclip выключается
  if not noclipEnabled and character then
    for _, part in pairs(character:GetDescendants()) do
      if part:IsA("BasePart") then
        part.CanCollide = true
      end
    end
  end
end)

RunService.Stepped:Connect(function()
  if noclipEnabled and character then
    for _, part in pairs(character:GetDescendants()) do
      if part:IsA("BasePart") then
        -- Устанавливаем CanCollide в false только если оно не равно false, чтобы не спамить
        if part.CanCollide == true then
          part.CanCollide = false
        end
      end
    end
  end
end)

-- === 🌐 Инициализация ===
-- Перенесена в confirmButton.MouseButton1Click, чтобы избежать ошибки при старте
-- updateLang()
