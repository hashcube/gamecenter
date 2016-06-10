import util.setProperty as setProperty;

var onSyncUpdate;

function pluginSend(evt, params) {
	NATIVE.plugins.sendEvent("GameCenterPlugin", evt,JSON.stringify(params || {}));
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
	}

	this.resetAchievements = function () {
		logger.log("{gamecenter} Reseting achievement");
		pluginSend("resetAchievements", {});
	};

	this.sendAchievement = function(achievementID, percentSolved) {
		logger.log("{gamecenter} Sending of achievement");

		var param = {"achievementID":achievementID,"percentSolved":percentSolved || 100};

		pluginSend("sendAchievement",param);
	};

	this.sendScore = function(leaderBoardID, score) {
		logger.log("{gamecenter} Sending of Score to leaderboard");

		var param = {"leaderBoardID":leaderBoardID,"score":score};

		pluginSend("sendScore",param);
	};

	this.setNumber = function(name, val) {
		return;
	};

	this.initSync = function(param_name) {
		return;
	};

	this.logout = function() {
		return;
	};

	this.login = function(next) {
		next(true);
	};

       this.showGameCenter = function() {
          pluginSend("showGameCenter");
       };
});

exports = new Gamecenter();
