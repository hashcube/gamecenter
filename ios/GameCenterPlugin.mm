#import "GameCenterPlugin.h"
#import "GameCenterManager.h"

static NSArray* _leaderboards = nil;
@implementation GameCenterPlugin

@synthesize gameCenterManager;

// The plugin must call super dealloc.
- (void) dealloc {
	[super dealloc];
}

// The plugin must call super init.
- (id) init {
	self = [super init];
	if (!self) {
		return nil;
	}
	return self;
}


- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
    if([GameCenterManager isGameCenterAvailable])
    {
        self.gameCenterManager= [[GameCenterManager alloc] init];
        //[self.gameCenterManager setDelegate: self];
        [self.gameCenterManager authenticateLocalUser];
    }
}

- (void) applicationWillTerminate:(UIApplication *)app {
}

- (void) applicationDidBecomeActive:(UIApplication *)app {
}

- (void) handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
}

- (void) didBecomeActive:(NSDictionary *)jsonObject {
}

- (void) sendAchievement:(NSDictionary *)jsonObject {
    NSString *achievementID =  [NSString stringWithFormat:@""];

    for (id key in jsonObject) {
        id o = [jsonObject objectForKey:key];
        if([key isEqual:@"achievementID"]){
            achievementID = o;
            continue;
        }
    }

    if([GameCenterManager isGameCenterAvailable]) {
        [self.gameCenterManager submitAchievement: achievementID percentComplete: 100.0];
    }
}

- (void) showLeaderBoard: (NSDictionary*)opts withRequestId:(NSNumber*) requestId {
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        if(error != nil) {
            [[PluginManager get] dispatchJSResponse:nil
                withError:@{@"message": error.localizedDescription}
                andRequestId:requestId];
        }
        NSMutableArray* res = [[NSMutableArray alloc] init];
        for (GKLeaderboard* lb in leaderboards) {
            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
            tmp[@"identifier"] = lb.identifier;
            tmp[@"title"] = lb.title;
            if (lb.groupIdentifier != nil) {
                tmp[@"groupIdentifier"] = lb.groupIdentifier;
            } else {
                tmp[@"groupIdentifier"] = @"";
            }
            [res addObject:tmp];
        }
        _leaderboards = leaderboards;
        [[PluginManager get] dispatchJSResponse:@{@"leaderboards":res}
                         withError:nil
                         andRequestId:requestId];
    }];
}
- (void) sendScore:(NSDictionary *)jsonObject {
    NSString *leaderBoardID =  [NSString stringWithFormat:@""];
    NSNumber *score;

    for (id key in jsonObject) {
        id o = [jsonObject objectForKey:key];
        if([key isEqual:@"leaderBoardID"]){
            leaderBoardID = o;
            continue;
        }
        if([key isEqual:@"score"]){
            score = o;
            continue;
        }
    }

    if([GameCenterManager isGameCenterAvailable]) {
        [self.gameCenterManager reportScore: [score intValue] forCategory: leaderBoardID];
    }
}
@end