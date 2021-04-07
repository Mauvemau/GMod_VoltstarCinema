-- Original fix belongs to FarukGamer on github. Credits for fixing the service goes to them. This is a slightly modified version of the fix.

local SERVICE = {}

SERVICE.Name = "Twitch.TV Stream"
SERVICE.IsTimed 	= false

local Ignored = {
	["video"] = true,
	["directory"] = true,
	["downloads"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("twitch.tv")
end

function SERVICE:GetURLInfo( url )

	if url.path then
		print("Checking Twitch")
		local data = url.path:match("/([%w_]+)")
		if (data and not Ignored[data]) then return { Data = data } end
	end

	print("Url not catched")
	return false
	
end

local THUMB_URL = "https://static-cdn.jtvnw.net/previews-ttv/live_user_%s-1280x720.jpg"

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local info = {}
	info.title = ("Twitch Stream: %s"):format(data)
	info.thumbnail = THUMB_URL:format(data)

	if onSuccess then
		pcall(onSuccess, info)
	end
	
	if onFailure then
		print("Failed to load stream.")
	end
end

-- CL

if CLIENT then

	local TWITCH_URL = "https://player.twitch.tv/?channel=%s&parent=pixeltailgames.com"
	local THEATER_JS = [[
		function testSelector(elem, dataStr) {
			var data = document.querySelectorAll( elem + "[data-test-selector]")
			for (let i=0; i<data.length; i++) {
				var selector = data[i].dataset.testSelector
				if (!!selector && selector === dataStr) {
					return data[i]
					break
				}
			}
		}
		function target(dataStr) {
			var data = document.querySelectorAll( "button[data-a-target]")
			for (let i=0; i<data.length; i++) {
				var selector = data[i].dataset.aTarget
				if (!!selector && selector === dataStr) {
					return data[i]
					break
				}
			}
		}
		function build(player) {
			window.player = player;
			if (!window.theater) {
				class CinemaPlayer {
					get player() {
						return window.player;
					}
					setVolume(volume) {
						if (!!this.player) {
							this.player.volume = volume / 100;
						}
					}
					enableHD(on) { }
				};
				window.theater = new CinemaPlayer();
			}
		}
		function check() {
			var mature = target("player-overlay-mature-accept")
			if (!!mature) {mature.click(); return;}
			var player = document.getElementsByTagName('video')[0];
			if (!testSelector("div", "sad-overlay") && !!player && player.paused == false && player.readyState == 4) {
				build(player);
				clearInterval(intervalId);
			}
		}
		var intervalId = setInterval(check, 150);
	]]

	function SERVICE:LoadVideo( Video, panel )
		panel:Stop()
		panel:OpenURL( TWITCH_URL:format( Video:Data() ) )

		panel.OnFinishLoading = function(pnl)
			pnl:RunJavascript(THEATER_JS)
		end
	end

end
theater.RegisterService( "twitchstream", SERVICE )
