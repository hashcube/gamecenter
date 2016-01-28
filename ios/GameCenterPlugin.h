#import <UIKit/UIKit.h>
#import "PluginManager.h"

@class GameCenterManager;
@interface GameCenterPlugin : GCPlugin {
	GameCenterManager* gameCenterManager;	
}
@property (retain, nonatomic) UINavigationController *navController;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

- (void) sendScore:(NSDictionary *)jsonObject;
- (void) sendAchievement:(NSDictionary *)jsonObject;
@end
