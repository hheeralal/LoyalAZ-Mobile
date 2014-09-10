//
//  AppDelegate.h
//  LoyalAZ

#import <UIKit/UIKit.h>
//#import "Application.h"
#import "Helper.h"
#import "XMLParser.h"
#import "NSStringUtil.h"
#import "CommunicationManager.h"
#import "HomeVC.h"
#import "RegisterUserVC.h"
#import "BusinessLayer.h"
#import "RegisterUserStep2VC.h"
#import "Reachability.h"
#import "WaitingVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import <BugSense-iOS/BugSenseController.h>
#import "GAI.h"
#import "FBCommunication.h"
#import "Appirater.h"

@class ViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate,BusinessLayerDelegate,FBCommunicationManagerDelegate>
{
    BOOL gotBaseURL;
}


extern NSString *tempValue;

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navController;
@property (strong,nonatomic) HomeVC *homeVC;
@property (strong,nonatomic) RegisterUserVC *registerUserVC;
@property (strong,nonatomic) TutorialVC *tutorialVC;
@property (strong,nonatomic) WaitingVC *waitingVC;

extern NSString *const FBSessionStateChangedNotification;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

- (void) closeSession;
-(void)StartStep1;

@end
