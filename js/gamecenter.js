import util.setProperty as setProperty;

var onSyncUpdate;

function pluginSend(evt, params) {
	NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent &&
		NATIVE.plugins.sendEvent("GameCenterPlugin", evt,
				JSON.stringify(params || {}));
}

function pluginOn(evt, next) {
	NATIVE && NATIVE.events && NATIVE.events.registerHandler &&
		NATIVE.events.registerHandler(evt, next);
}

function invokeCallbacks(list, clear) {
	// Pop off the first two arguments and keep the rest
	var args = Array.prototype.slice.call(arguments);
	args.shift();
	args.shift();

	// For each callback,
	for (var ii = 0; ii < list.length; ++ii) {
		var next = list[ii];

		// If callback was actually specified,
		if (next) {
			// Run it
			next.apply(null, args);
		}
	}

	// If asked to clear the list too,
	if (clear) {
		list.length = 0;
	}
}

var Gamecenter = Class(function () {

	var loginCB = [];

	this.init = function(opts) {
		logger.log("{gamecenter} Registering for events on startup");
		setProperty(this, "onSyncUpdate", {
			set: function(f) {
				//logger.log("Am seting it");
				// If a callback is being set,
				if (typeof f === "function") {
					onSyncUpdate = f;
				} else {
					onSyncUpdate = null;
				}
			},
			get: function() {
				//logger.log("Am getting it");
				return onSyncUpdate;
			}
		});

		pluginOn("gamecenterLogin", function(evt) {
			logger.log("{gamecenter} State updated:", evt.state);

			invokeCallbacks(loginCB, true, evt.state === "open", evt);
		});
	}

	this.sendAchievement = function(achievementID, percentSolved) {
		logger.log("{gamecenter} Sending of achievement");

		var param = {"achievementID":achievementID,"percentSolved":percentSolved};

		pluginSend("sendAchievement",param);
	}

	this.sendScore = function(leaderBoardID, score) {
		logger.log("{gamecenter} Sending of Score to leaderboard");

		var param = {"leaderBoardID":leaderBoardID,"score":score};

		pluginSend("sendScore",param);
	}

	this.setNumber = function(name, val) {
		return;
	}

	this.initSync = function(param_name) {
		return;
	}

	this.logout = function() {
		logger.log("{gamecenter} Logging Out a user");

		pluginSend("signOut");
	}

	this.login = function(next) {
		logger.log("{gamecenter} Logging in a user");

		loginCB.push(next);

		pluginSend("beginUserInitiatedSignIn");
	}

	this.showLeaderBoard = function() {
		logger.log("{gamecenter} Showing Leaderboard");

		pluginSend("showLeaderBoard");
	}
});

exports = new Gamecenter();