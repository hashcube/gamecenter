#import <UIKit/UIKit.h>
#import "PluginManager.h"

@class GameCenterManager;
@interface GameCenterPlugin : GCPlugin{
	GameCenterManager* gameCenterManager;	
}
@property (retain, nonatomic) UINavigationController *navController;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

- (void) beginUserInitiatedSignIn;
- (void) sendScore;
- (void) sendAchievement;
@end