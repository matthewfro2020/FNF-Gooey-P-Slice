--------------------------------------------------------------
-- Philly City (Psych Engine Lua v1.0.4+)
-- Complete with cars, lighting, Pico walk event, and props
--------------------------------------------------------------

local backCarCanDrive = true
local frontCarCanDrive = true
local allowCarInGeneral = true

--------------------------------------------------------------
-- Stage Creation
--------------------------------------------------------------
function onCreate()
    setProperty('defaultCamZoom', 0.65)

    -- === BACKGROUND LAYERS ===
    makeLuaSprite('Sky', 'gooeyMix/extra/phillyCity/Sky', -1000, -570)
    setScrollFactor('Sky', 0.2, 0.2)
    setObjectOrder('Sky', 10)
    addLuaSprite('Sky', false)

    makeLuaSprite('FarCity', 'gooeyMix/extra/phillyCity/farCity', -700, -300)
    setScrollFactor('FarCity', 0.4, 0.6)
    setObjectOrder('FarCity', 20)
    addLuaSprite('FarCity', false)

    makeLuaSprite('City', 'gooeyMix/extra/phillyCity/City', -400, -100)
    setScrollFactor('City', 0.6, 0.9)
    setObjectOrder('City', 30)
    addLuaSprite('City', false)

    makeLuaSprite('911', 'gooeyMix/extra/phillyCity/911', -100, 0)
    setScrollFactor('911', 0.85, 1)
    setObjectOrder('911', 40)
    addLuaSprite('911', false)

    -- === PICO WALKER ===
    makeAnimatedLuaSprite('picoWalk', 'gooeyMix/extra/phillyCity/picowalk', 1000, 690)
    addAnimationByPrefix('picoWalk', 'walk', 'Symbol 51', 24, false)
    setProperty('picoWalk.scale.x', 0.3)
    setProperty('picoWalk.scale.y', 0.3)
    setScrollFactor('picoWalk', 0.85, 1)
    setObjectOrder('picoWalk', 42)
    addLuaSprite('picoWalk', false)

    -- === BACK CAR ===
    makeLuaSprite('backCar', 'gooeyMix/extra/phillyCity/MixCar', 100, 710)
    setProperty('backCar.scale.x', 0.45)
    setProperty('backCar.scale.y', 0.45)
    setScrollFactor('backCar', 0.85, 1)
    setObjectOrder('backCar', 45)
    addLuaSprite('backCar', false)

    -- === MAIN CITY + LIGHTING ===
    makeLuaSprite('MainCity', 'gooeyMix/extra/phillyCity/MainBG', 0, 0)
    setScrollFactor('MainCity', 1, 1)
    setObjectOrder('MainCity', 50)
    addLuaSprite('MainCity', false)

    makeLuaSprite('lighting', 'gooeyMix/extra/phillyCity/MixLighting', 0, 0)
    setScrollFactor('lighting', 1, 1)
    setBlendMode('lighting', 'normal')
    setObjectOrder('lighting', 110)
    addLuaSprite('lighting', true)

    -- === FRONT CAR ===
    makeLuaSprite('frontCar', 'gooeyMix/extra/phillyCity/MixCar', -3000, 1400)
    setProperty('frontCar.scale.x', 1.5)
    setProperty('frontCar.scale.y', 1.5)
    setScrollFactor('frontCar', 1, 1)
    setObjectOrder('frontCar', 85)
    addLuaSprite('frontCar', true)

    -- === FOREGROUND OBJECTS ===
    makeLuaSprite('plant', 'gooeyMix/extra/phillyCity/plant', 500, 300)
    setScrollFactor('plant', 1.5, 1.5)
    setObjectOrder('plant', 90)
    addLuaSprite('plant', true)

    makeLuaSprite('sotp', 'gooeyMix/extra/phillyCity/sotp sign', 3500, 1800)
    setProperty('sotp.scale.x', 0.5)
    setProperty('sotp.scale.y', 0.5)
    setScrollFactor('sotp', 1.5, 1.5)
    setObjectOrder('sotp', 100)
    addLuaSprite('sotp', true)
end

--------------------------------------------------------------
-- Stage Logic
--------------------------------------------------------------
function onCreatePost()
    allowCarInGeneral = true
end

--------------------------------------------------------------
-- Beat Logic (Cars + Pico Event)
--------------------------------------------------------------
function onBeatHit()
    if curBeat == 332 then
        if luaSpriteExists('picoWalk') then
            objectPlayAnimation('picoWalk', 'walk', true)
            setProperty('picoWalk.velocity.x', 90)
            runTimer('stopPicoWalk', 10.5)
        end
    end

    if curBeat == 400 then
        allowCarInGeneral = false
    end

    if allowCarInGeneral then
        if getRandomBool(10) and backCarCanDrive then
            backCarDrive()
        end
        if getRandomBool(10) and frontCarCanDrive then
            frontCarDrive()
        end
    end
end

--------------------------------------------------------------
-- Timers
--------------------------------------------------------------
function onTimerCompleted(tag)
    if tag == 'stopPicoWalk' then
        setProperty('picoWalk.velocity.x', 0)
    elseif tag == 'resetBackCar' then
        resetBackCar()
    elseif tag == 'resetFrontCar' then
        resetFrontCar()
    end
end

--------------------------------------------------------------
-- Car Behavior
--------------------------------------------------------------
function resetBackCar()
    if not luaSpriteExists('backCar') then return end
    setProperty('backCar.flipX', false)
    setProperty('backCar.x', 100)
    backCarCanDrive = true
end

function resetFrontCar()
    if not luaSpriteExists('frontCar') then return end
    setProperty('frontCar.flipX', false)
    setProperty('frontCar.x', -3000)
    frontCarCanDrive = true
end

function backCarDrive()
    local chance = math.random(1, 2)
    playSound('extra/carPassMix', 0.4)

    if chance == 1 then
        doTweenX('backCarOut', 'backCar', 3000, 0.5, 'linear')
    else
        setProperty('backCar.x', 3000)
        setProperty('backCar.flipX', true)
        doTweenX('backCarIn', 'backCar', 0, 0.5, 'linear')
    end

    backCarCanDrive = false
    runTimer('resetBackCar', 5)
end

function frontCarDrive()
    local chance = math.random(1, 2)
    playSound('extra/carPassMix', 0.5)

    if chance == 1 then
        doTweenX('frontCarOut', 'frontCar', 4000, 0.5, 'linear')
    else
        setProperty('frontCar.x', 4000)
        setProperty('frontCar.flipX', true)
        doTweenX('frontCarIn', 'frontCar', -3000, 0.5, 'linear')
    end

    frontCarCanDrive = false
    runTimer('resetFrontCar', 7)
end

--------------------------------------------------------------
-- Song Retry / Countdown Reset
--------------------------------------------------------------
function onSongRetry()
    resetBackCar()
    resetFrontCar()
    if luaSpriteExists('picoWalk') then
        setProperty('picoWalk.velocity.x', 0)
        setProperty('picoWalk.x', 1000)
    end
    allowCarInGeneral = true
end

function onCountdownStart()
    resetBackCar()
    resetFrontCar()
    if luaSpriteExists('picoWalk') then
        setProperty('picoWalk.velocity.x', 0)
        setProperty('picoWalk.x', 1000)
    end
    runHaxeCode([[ PlayState.instance.comboPopUps.offsets = [-450, 350]; ]])
end
