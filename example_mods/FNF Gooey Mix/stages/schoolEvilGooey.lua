-- Psych Engine Lua version of SchoolEvilGooeyStage
-- Includes wiggle shaders, drop shadows, and prop setup

local wiggleBack
local wiggleSchool
local wiggleGround
local wiggleSpike

function onCreate()
    -- Basic camera zoom
    setProperty('defaultCamZoom', 1)

    -- === PROPS ===
    makeLuaSprite('solid', '', -500, -1000)
    makeGraphic('solid', 2400, 2000, '000000')
    setScrollFactor('solid', 0, 0)
    addLuaSprite('solid', false)

    makeLuaSprite('backspikes', 'weeb/erect/evil/weebBackSpikes', -842, -180)
    setScrollFactor('backspikes', 0.5, 0.5)
    scaleObject('backspikes', 6, 6)
    addLuaSprite('backspikes', false)

    makeLuaSprite('school', 'weeb/erect/evil/weebSchool', -816, -38)
    setScrollFactor('school', 0.75, 0.75)
    scaleObject('school', 6, 6)
    addLuaSprite('school', false)

    makeLuaSprite('backspike', 'weeb/erect/evil/backSpike', 1416, 464)
    setScrollFactor('backspike', 0.85, 0.85)
    scaleObject('backspike', 6, 6)
    addLuaSprite('backspike', false)

    makeLuaSprite('evilstreet', 'weeb/erect/evil/weebStreet', -662, 6)
    setScrollFactor('evilstreet', 1, 1)
    scaleObject('evilstreet', 6, 6)
    addLuaSprite('evilstreet', false)

    -- === SHADERS ===
    if getDataFromSave('Gooey', 'gooeyShaders', true) then
        initLuaShader('WiggleEffectRuntime')

        runHaxeCode([[
            var wiggleBack = new WiggleEffectRuntime(2 * 0.8, 4 * 0.4, 0.011, WiggleEffectType.DREAMY);
            var wiggleSchool = new WiggleEffectRuntime(2, 4, 0.017, WiggleEffectType.DREAMY);
            var wiggleSpike = new WiggleEffectRuntime(2, 4, 0.01, WiggleEffectType.DREAMY);
            var wiggleGround = new WiggleEffectRuntime(2, 4, 0.007, WiggleEffectType.DREAMY);

            game.getLuaObject('school').shader = wiggleSchool;
            game.getLuaObject('evilstreet').shader = wiggleGround;
            game.getLuaObject('backspikes').shader = wiggleBack;
            game.getLuaObject('backspike').shader = wiggleSpike;

            setVar('wiggleBack', wiggleBack);
            setVar('wiggleSchool', wiggleSchool);
            setVar('wiggleGround', wiggleGround);
            setVar('wiggleSpike', wiggleSpike);
        ]])
    end
end


function onUpdatePost(elapsed)
    -- Update wiggle shaders every frame
    if getDataFromSave('Gooey', 'gooeyShaders', true) then
        runHaxeCode([[
            if (getVar('wiggleBack') != null) {
                getVar('wiggleBack').update(]]..elapsed..[[);
                getVar('wiggleSchool').update(]]..elapsed..[[);
                getVar('wiggleGround').update(]]..elapsed..[[);
                getVar('wiggleSpike').update(]]..elapsed..[[);
            }
        ]])
    end
end


-- === CHARACTER SHADERS ===
function onAddCharacter(charType, charName)
    if getDataFromSave('Gooey', 'gooeyShaders', true) then
        runHaxeCode([[
            import funkin.graphics.shaders.DropShadowShader;
            var rim = new DropShadowShader();
            rim.setAdjustColor(-90, 0, 24, 5);
            rim.color = 0xFF690832;
            rim.antialiasAmt = 0;
            rim.distance = 5;

            switch (]]..charType..[[)
            {
                case 0: // BF
                    rim.angle = 180;
                    rim.distance = 3;
                    game.boyfriend.shader = rim;
                    rim.attachedSprite = game.boyfriend;
                    game.boyfriend.animation.callback = function()
                    {
                        if (game.boyfriend != null) rim.updateFrameInfo(game.boyfriend.frame);
                    };
                case 1: // DAD
                    rim.angle = 90;
                    rim.setAdjustColor(-40, -10, 24, 0);
                    game.dad.shader = rim;
                    rim.attachedSprite = game.dad;
                    game.dad.animation.callback = function()
                    {
                        if (game.dad != null) rim.updateFrameInfo(game.dad.frame);
                    };
                case 2: // GF
                    rim.angle = 180;
                    rim.distance = 3;
                    game.gf.shader = rim;
                    rim.attachedSprite = game.gf;
                    game.gf.animation.callback = function()
                    {
                        if (game.gf != null) rim.updateFrameInfo(game.gf.frame);
                    };
            }
        ]])
    end
end


-- === CHARACTER PLACEMENT ===
function onCreatePost()
    setCharacterPosition('dad', 0, 648)
    setCharacterPosition('bf', 1168, 900)
    setCharacterPosition('gf', 724, 773)

    setProperty('boyfriendCameraOffset', {-200, -94})
    setProperty('dadCameraOffset', {440, 270})
    setProperty('gfCameraOffset', {40, 40})
end
