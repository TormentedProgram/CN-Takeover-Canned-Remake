import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Scripts {
	public static var luaScripts:Array<String> = [ //LOAD LUA SCRIPTS HERE - TORMENTED
        "
        function onEvent(name,value1,value2)
            if name == 'Set Cam Zoom' then
                if value2 == '' then
                    setProperty('defaultCamZoom',value1)
                    debugPrint(value2 )
                else
                    doTweenZoom('camz','camGame',tonumber(value1),tonumber(value2),'sineInOut')
                end       
            end
        end
        
        function onTweenCompleted(name)
            if name == 'camz' then
                setProperty('defaultCamZoom',getProperty('camGame.zoom')) 
            end
        end
        ",
        
        "
        --Idea by MoonScarf
        --Created by Kevin Kuntz
        function onCreatePost()
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                sus = getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')
                mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
                if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Shifter' then
                    if not sus then
                        oFX = getPropertyFromGroup('unspawnNotes', i, 'offsetX')
                    else
                        susFX = getPropertyFromGroup('unspawnNotes', i, 'offsetX')
                    end
                    if mustPress then
                        runHaxeCode([[
                            for (note in game.unspawnNotes) note.alpha = 0.3;
                        ]])
                        setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') - 640)
                    else
                        runHaxeCode([[
                            for (note in game.unspawnNotes) note.alpha = 0.3;
                        ]])
                        setPropertyFromGroup('unspawnNotes', i, 'offsetX', getPropertyFromGroup('unspawnNotes', i, 'offsetX') + 640)
                    end
                end
            end
        end

        function onUpdatePost(el)
            songPos = getSongPosition()
            local currentBeat = (getSongPosition() / 1000)*(bpm/60)
            for a = 0, getProperty('notes.length') - 1 do
                strumTime = getPropertyFromGroup('notes', a, 'strumTime')
                sus = getPropertyFromGroup('notes', a, 'isSustainNote')
                if getPropertyFromGroup('notes', a, 'noteType') == 'Shifter' then
                    if sus then
                        setPropertyFromGroup('notes', a, 'offsetX', getPropertyFromGroup('notes', a, 'offsetX') + 3 * math.cos((currentBeat + a * 0.15) * math.pi))
                    end
                    if (strumTime - songPos) < 1100 / scrollSpeed and not sus then
                        if getPropertyFromGroup('notes', a, 'offsetX') ~= oFX then
                            setPropertyFromGroup('notes', a, 'offsetX', lerp(getPropertyFromGroup('notes', a, 'offsetX'), oFX, boundTo(el * 10, 0, 1)))                     
                        elseif getPropertyFromGroup('notes', a, 'offsetX') <= oFX then
                            setPropertyFromGroup('notes', a, 'offsetX', oFX)
                        end
                    elseif (strumTime - songPos) < 1200 / scrollSpeed and sus then
                        if getPropertyFromGroup('notes', a, 'offsetX') ~= susFX then
                            setPropertyFromGroup('notes', a, 'offsetX', lerp(getPropertyFromGroup('notes', a, 'offsetX'), susFX, boundTo(el * 10, 0, 1)))
                        elseif getPropertyFromGroup('notes', a, 'offsetX') <= susFX then
                            setPropertyFromGroup('notes', a, 'offsetX', susFX)
                        end
                    end
                end
            end
        end

        function lerp(a, b, ratio)
        return math.floor(a + ratio * (b - a))
        end

        function boundTo(value, min, max)
            return math.max(min, math.min(max, value))
        end
        ",

        "
        function onEvent(name, value1, value2)
            if name == 'Camera Switch' and value2 == 'on' then
                doTweenAlpha('camHUDon', 'camHUD', 1, value1, 'linear')
                doTweenAlpha('camGameon', 'camGame', 1, value1, 'linear')
            end
        
            if name == 'Camera Switch' and value2 == 'off' then
                doTweenAlpha('camHUDOff', 'camHUD', 0, value1, 'linear')
                doTweenAlpha('camGameOff', 'camGame', 0, value1, 'linear')
            end
        end
        "
	];
}