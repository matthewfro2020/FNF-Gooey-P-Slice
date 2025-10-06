----------------------------------------------------------------
-- ON CREATE POST: Adjust lighting layers after props load
----------------------------------------------------------------
function onCreatePost()
	-- Make sure all sprite props are loaded before editing them

	local function safeSetBlend(name, blend, alpha)
		if luaSpriteExists(name) then
			setBlendMode(name, blend)
			if alpha ~= nil then setProperty(name .. '.alpha', alpha) end
		end
	end

	-- Lighting setup
	safeSetBlend('lighting', 'normal', nil)
	safeSetBlend('lighting2', 'add', nil)
	safeSetBlend('stageLighting', 'add', nil)

	safeSetBlend('spotlight1', 'add', 1)
	safeSetBlend('spotlight2', 'normal', 0.05)
	safeSetBlend('spotlight3', 'normal', 0.5)
	safeSetBlend('extraSpotlight', 'add', 0)
	safeSetBlend('extraSpotlight2', 'add', 0)

	-- Light sources
	safeSetBlend('topLantern1Light', 'normal', nil)
	safeSetBlend('topLantern2Light', 'normal', nil)
	safeSetBlend('candleFrontLight', 'normal', nil)
	safeSetBlend('candleBackLight', 'normal', nil)
	safeSetBlend('bottomLantern1Light', 'normal', nil)
	safeSetBlend('bottomLantern2Light', 'normal', nil)
end