#import "GameCenterPlugin.h"
#import "GameCenterManager.h"

static UIViewController* rootViewController = nil;
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

    rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if([GameCenterManager isGameCenterAvailable])
    {
        self.gameCenterManager= [[GameCenterManager alloc] init];
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
- (void) showGameCenter: (NSDictionary *)jsonObject {
    NSLog(@"showGameCenter has been called");
    if([GameCenterManager isGameCenterAvailable]) {
        [self.gameCenterManager showGameCenter: rootViewController];
    } else {
      return;
    }
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
