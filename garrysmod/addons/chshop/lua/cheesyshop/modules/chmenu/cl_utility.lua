CreateConVar( "cl_ui_color", "0.16 0.81 0.90", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
-- Globals
backgroundColor = Color( 30, 30, 30, 255 )
borderColor = Color(42, 207, 232, 255)
borderColorMouseover = Color(255, 255, 255, 255)
grayColor = Color(75, 75, 75, 255)

GridSlotMouseover = Color(75, 75, 75, 25) -- Color to show up when you mouseover a grid button
GridSlowSelect = Color(75, 75, 75, 50) -- Color to show up when you select a grid button

currencyIco = 'https://i.imgur.com/cGuOQAF.png'
currencyIcoLocal = Material("voltmenu/currency_small.png")
couponIco = 'https://i.imgur.com/lL2JNJN.png'
couponIcoLocal = Material("voltmenu/coupon.png")

function MakeDarkerColor(color)
	local darker = Color(255, 255, 255, 255)
	darker.r = color.r * .75
	darker.g = color.g * .75
	darker.b = color.b * .75
	
	return darker
end
borderColorMouseover = MakeDarkerColor(borderColor)

function GetTransparent(color, alpha)
	local tr = Color(255, 255, 255, 255)
	tr.r = color.r
	tr.g = color.g
	tr.b = color.b
	tr.a = alpha
	
	return tr
end

function ButtonToggleSelected(obj, toggle) -- For toggle buttons.
	if(toggle)then
		obj.selected = true
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, borderColor )
		end
		obj:SetColor( Color( 30, 30, 30, 255 ) )
	else
		obj.selected = false
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, borderColor )
			draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
		end
		obj:SetColor(borderColor)
	end
end

function PaintButton(obj)
	if(!IsValid(obj)) then return end
	
	obj.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, borderColor )
		draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
	end
	obj:SetColor(borderColor)
	obj.OnCursorEntered = function()
		if(obj.selected) then return end -- In case it is a TOGGLED toggle button.
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, borderColorMouseover )
		end
		obj:SetColor(backgroundColor)
	end
	obj.OnCursorExited = function()
		if(obj.selected) then return end
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, borderColor )
			draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
		end
		obj:SetColor(borderColor)
	end
	obj.DoClickInternal = function()
		if(obj.selected) then return end
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, borderColor )
		end
		obj:SetColor(backgroundColor)
	end
end

function PaintButtonSpecific(obj, color)
	if(!IsValid(obj)) then return end
	local darkerColor = MakeDarkerColor(color)
	
	obj.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, color )
		draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
	end
	obj:SetColor(color)
	obj.OnCursorEntered = function()
		if(obj.selected) then return end -- In case it is a TOGGLED toggle button.
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, darkerColor )
		end
		obj:SetColor(backgroundColor)
	end
	obj.OnCursorExited = function()
		if(obj.selected) then return end
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, color )
			draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
		end
		obj:SetColor(color)
	end
	obj.DoClickInternal = function()
		if(obj.selected) then return end
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, color )
		end
		obj:SetColor(backgroundColor)
	end
end

function PaintFrame(obj)
	if(!IsValid(obj)) then return end
	
	obj.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, borderColor )
		draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
	end
end

function PaintFrameBlur(obj)
	if(!IsValid(obj)) then return end
	
	obj.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, borderColor )
		draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
		Derma_DrawBackgroundBlur(self, SysTime())
	end
end

function PaintFrameSpecific(obj, color)
	if(!IsValid(obj)) then return end
	
	obj.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color)
		draw.RoundedBox(0, 2, 2, w-4, h-4, backgroundColor)
	end
end

function PaintImageButton(obj)
	if(!IsValid(obj)) then return end
	
	obj.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	obj.OnCursorEntered = function()
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, GridSlotMouseover )
		end
	end
	obj.OnCursorExited = function()
		-- In case it got stats window on it.
		if(obj.stats == true) then
			obj:HideStatsWindow()
		end
		
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
		end
	end
	obj.DoClickInternal = function()
		obj.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, GridSlowSelect )
		end
	end
end

function ChangeInterfaceColors(newColor)
	borderColor = newColor
	borderColorMouseover = MakeDarkerColor(borderColor)
	newVector = Vector(newColor.r/255, newColor.g/255, newColor.b/255)
	RunConsoleCommand("cl_ui_color", tostring(newVector))
end
local function LoadUIColor()
	local col = Vector(GetConVarString( "cl_ui_color" )):ToColor()
	ChangeInterfaceColors(col)
end
hook.Add("InitPostEntity", "chsh_setuicolor", function(ply)
	LoadUIColor()
end)

-- Receives a vgui dhtml panel and a url and inserts the image from the url into the panel.
function CreateWebTexturePanel(htmlpanel, url)
	local js = "document.getElementById('myico').src = \'".. url .."\';"
	htmlpanel:SetHTML([[
		<html>
		<head>
			<style>
				* {
					margin: 0;
					padding: 0;
				}
				.imgbox {
					display: grid;
					height: 100%;
				}
				.center-fit {
					max-width: 100%;
					max-height: 100vh;
					margin: auto;
				}
			</style>
		</head>
		<body>
		<div class="imgbox">
			<img id = 'myico' class="center-fit" src=''>
		</div>
		</body>
		</html>
	]])
	htmlpanel:QueueJavascript(js)
end

function CreateRepeatingWebTexture(htmlpanel, url)
	local js = "document.body.style.backgroundImage = \'".."url("..  url ..")".."\';"
	htmlpanel:SetHTML([[
		<html>
		<head>
			<style>
				body {
					background-image: url('');
					background-repeat: repeat;
					background-size: 30%;
					background-color: rgba(0, 0, 0, 0.3);
				}
			</style>
		</head>
		<body>
		</body>
		</html>
	]])
	htmlpanel:QueueJavascript(js)
end

function CreateRepeatingWebTextureWithSnowflakes(htmlpanel, url)
	local js = "document.body.style.backgroundImage = \'".."url("..  url ..")".."\';"
	htmlpanel:SetHTML([[
		<html>
		<head>
			<style>
			body {
				background-image: url('');
				background-repeat: repeat;
				background-size: 30%;
				background-color: rgba(0, 0, 0, 0.3);
			}
			  /* customizable snowflake styling */
			  .snowflake {
				color: #fff;
				font-size: 1em;
				font-family: Arial;
				text-shadow: 0 0 1px #000;
			  }
			  
			  @-webkit-keyframes snowflakes-fall{0%{top:-10%}100%{top:100%}}@-webkit-keyframes snowflakes-shake{0%{-webkit-transform:translateX(0px);transform:translateX(0px)}50%{-webkit-transform:translateX(80px);transform:translateX(80px)}100%{-webkit-transform:translateX(0px);transform:translateX(0px)}}@keyframes snowflakes-fall{0%{top:-10%}100%{top:100%}}@keyframes snowflakes-shake{0%{transform:translateX(0px)}50%{transform:translateX(80px)}100%{transform:translateX(0px)}}.snowflake{position:fixed;top:-10%;z-index:9999;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;cursor:default;-webkit-animation-name:snowflakes-fall,snowflakes-shake;-webkit-animation-duration:10s,3s;-webkit-animation-timing-function:linear,ease-in-out;-webkit-animation-iteration-count:infinite,infinite;-webkit-animation-play-state:running,running;animation-name:snowflakes-fall,snowflakes-shake;animation-duration:10s,3s;animation-timing-function:linear,ease-in-out;animation-iteration-count:infinite,infinite;animation-play-state:running,running}.snowflake:nth-of-type(0){left:1%;-webkit-animation-delay:0s,0s;animation-delay:0s,0s}.snowflake:nth-of-type(1){left:10%;-webkit-animation-delay:1s,1s;animation-delay:1s,1s}.snowflake:nth-of-type(2){left:20%;-webkit-animation-delay:6s,.5s;animation-delay:6s,.5s}.snowflake:nth-of-type(3){left:30%;-webkit-animation-delay:4s,2s;animation-delay:4s,2s}.snowflake:nth-of-type(4){left:40%;-webkit-animation-delay:2s,2s;animation-delay:2s,2s}.snowflake:nth-of-type(5){left:50%;-webkit-animation-delay:8s,3s;animation-delay:8s,3s}.snowflake:nth-of-type(6){left:60%;-webkit-animation-delay:6s,2s;animation-delay:6s,2s}.snowflake:nth-of-type(7){left:70%;-webkit-animation-delay:2.5s,1s;animation-delay:2.5s,1s}.snowflake:nth-of-type(8){left:80%;-webkit-animation-delay:1s,0s;animation-delay:1s,0s}.snowflake:nth-of-type(9){left:90%;-webkit-animation-delay:3s,1.5s;animation-delay:3s,1.5s}
			</style>
		</head>
		<body>
		<div class="snowflakes" aria-hidden="true">
  <div class="snowflake">
  ✮
  </div>
  <div class="snowflake">
  ✮
  </div>
  <div class="snowflake">
  ☆
  </div>
  <div class="snowflake">
  ✮
  </div>
  <div class="snowflake">
  ✮
  </div>
  <div class="snowflake">
  ☆
  </div>
  <div class="snowflake">
  ✮
  </div>
  <div class="snowflake">
  ✮
  </div>
  <div class="snowflake">
  ☆
  </div>
  <div class="snowflake">
  ☆
  </div>
  <div class="snowflake">
  ✮</div>
  <div class="snowflake">
  ✮
</div>
		</body>
		</html>
	]])
	htmlpanel:QueueJavascript(js)
end
