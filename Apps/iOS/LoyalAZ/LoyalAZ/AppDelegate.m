//
//  AppDelegate.m
//  LoyalAZ

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize homeVC;
@synthesize navController;
@synthesize registerUserVC;
@synthesize tutorialVC;
@synthesize waitingVC;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [self GetFileNameFromCompletePath:@""];
    
    [BugSenseController sharedControllerWithBugSenseAPIKey:@"dffdc98f"];
    
//    [Appirater setAppId:@"552035781"];
//    [Appirater setDaysUntilPrompt:1];
//    [Appirater setUsesUntilPrompt:9];
//    [Appirater setSignificantEventsUntilPrompt:-1];
//    [Appirater setTimeBeforeReminding:3];
//    [Appirater setDebug:YES];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8952881-16"];
//    NSLog(@"%@",tracker);

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //        NSLog(@"iOS 8");
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    } else {
        //        NSLog(@"iOS 7");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }


    Application *appObject = [Application applicationManager];
    appObject.loyalaz = [Helper GetObjectFromDB];

    
//    NSLog(@"XML==%@",[XMLParser ObjectToXml:appObject.loyalaz]); // To debug the actual XML contents.
    
    if(appObject.loyalaz.programs==nil)
    {
        appObject.loyalaz.programs = [[NSMutableArray alloc]init];
    }
    
    if(appObject.loyalaz.coupons==nil)
    {
        appObject.loyalaz.coupons = [[NSMutableArray alloc]init];
    }
    
    

    
    if([appObject.loyalaz.user.uid isEqualToString:@""]) //This will be EMPTY if the user is not yet registered.
    {
        //Navigate to screen for registration process.
//        [self StartStep1];
        [self StartTutorial];
    }
    else
    {
        //NSLog(@"User Id=%@",appObject.loyalaz.user.uid);
        if([appObject.loyalaz.user.mobilephone isEqualToString:@""])
        {
            // Second step of registration is yet to be completed.
            [self StartStep2];
        }
        else
        {
            // Sync at the start of app.
            //Navigate to home screen for registered user.
            [self SetImagesFileNames];
            [self StartSyncProcess];
            //[self MoveToHomeScreen];
        }
        
    }
//    [Appirater appLaunched:YES];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Get a hex string from the device token with no spaces or < >
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    Application *appObject = [Application applicationManager];
    appObject.deviceToken = deviceTokenStr;
    
    NSLog(@"Device Token: %@", deviceTokenStr);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



-(void)communicationManagerDidFinish:(NSString *)ResponseXML
{
    NSLog(@"Got Graph Resonse=%@",ResponseXML);
}

-(void)communicationManagerErrorOccurred:(NSError *)err
{
    NSLog(@"EEEEEEEEEEEE");
}

-(void)SetImagesFileNames
{
    Program *prg;
    Coupon *cpn;
    Application *appObject = [Application applicationManager];
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        prg = [appObject.loyalaz.programs objectAtIndex:i];
        prg.pic_back = [self GetFileNameFromCompletePath:prg.pic_back];
        prg.pic_front = [self GetFileNameFromCompletePath:prg.pic_front];
        prg.pic_logo = [self GetFileNameFromCompletePath:prg.pic_logo];
    }
    
    for(int i=0;i<appObject.loyalaz.coupons.count;i++)
    {
        cpn = [appObject.loyalaz.coupons objectAtIndex:i];
        cpn.pic_back = [self GetFileNameFromCompletePath:cpn.pic_back];
        cpn.pic_front = [self GetFileNameFromCompletePath:cpn.pic_front];
        cpn.pic_logo = [self GetFileNameFromCompletePath:cpn.pic_logo];
        cpn.pic_qrcode = [self GetFileNameFromCompletePath:cpn.pic_qrcode];
    }
    
    [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
    
//    for(int i=0;i<appObject.loyalaz.programs.count;i++)
//    {
//        
//    }
    
}

-(NSString *)GetFileNameFromCompletePath:(NSString *)completePath
{
    NSArray *pathValues = [completePath componentsSeparatedByString:@"/"];
//    NSLog(@"FILENAME=%@",[pathValues objectAtIndex:pathValues.count-1]);
    return [pathValues objectAtIndex:pathValues.count-1];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

NSString *const FBSessionStateChangedNotification = @"com.outstandingresultscompany:FBSessionStateChangedNotification";

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    //NSLog(@"State Changed%c",session.isOpen);
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}


//- (void)BusinessLayerDidFinish:(BOOL)result
//{
////    if(result==YES)
////    {
////        gotBaseURL = YES;
////        
////        
////    }
//}

-(void)AccountDeleted
{
    [self StartStep1];
}

-(void)StartTutorial
{
//    TutorialVC *tutorialVC = [[TutorialVC alloc]initWithNibName:@"TutorialVC" bundle:nil];
//    [self presentViewController:tutorialVC animated:YES completion:nil];
    
    self.tutorialVC = [[TutorialVC alloc] initWithNibName:@"TutorialVC" bundle:nil];
    navController = [[UINavigationController alloc]initWithRootViewController:self.tutorialVC];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
}

-(void)StartStep1
{
    
//    if([Helper IsInternetRequired])
//    {
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Internet connection is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles :nil];
//        [av show];
//        [av release];
//    }
//    else
//    {
        self.registerUserVC = [[RegisterUserVC alloc] initWithNibName:@"RegisterUserVC" bundle:nil];
        navController = [[UINavigationController alloc]initWithRootViewController:self.registerUserVC];
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        // Override point for customization after application launch.
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
//    }
}

-(void)StartStep2
{
    // Second step of registration is yet to be completed.
    RegisterUserStep2VC *registerUserStep2VC = [[RegisterUserStep2VC alloc]initWithNibName:@"RegisterUserStep2VC" bundle:nil];
    navController = [[UINavigationController alloc]initWithRootViewController:registerUserStep2VC];
    [registerUserStep2VC release];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

-(void)StartSyncProcess
{
    if([Helper IsInternetAvailable]==YES)
    {
        [self MoveToWaitingScreen];
//        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
//        businessObject.delegate = self;
//        [businessObject SyncDB];
    }
    else
    {
        [self MoveToHomeScreen];
    }

}

-(void)MoveToWaitingScreen
{
    //Navigate to home screen for registered user.
    self.waitingVC = [[[WaitingVC alloc] initWithNibName:@"WaitingVC" bundle:nil] autorelease];
    navController = [[UINavigationController alloc]initWithRootViewController:waitingVC];
    [waitingVC release];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

-(void)MoveToHomeScreen
{
    Application *appObject = [Application applicationManager];
    appObject.loyalaz = [Helper GetObjectFromDB];
    
    if(appObject.loyalaz.programs ==nil)
    {
        appObject.loyalaz.programs = [[NSMutableArray alloc]init];
    }
    
    //Navigate to home screen for registered user.
    self.homeVC = [[[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil] autorelease];
    navController = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeVC release];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    [self MoveToHomeScreen];
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    
}


//- (void)BusinessLayerErrorOccurred:(NSError *)err
//{
//    
//    BOOL connectionRequired = [Helper IsInternetRequired];
//    
//    Application *appObject = [Application applicationManager];
//    appObject.loyalaz = [Helper GetObjectFromDB];
//    
//    if([appObject.loyalaz.user.uid isEqualToString:@""]) //This will be EMPTY if the user is not yet registered.
//    {
//        if(connectionRequired)
//        {
//            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Internet connection is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles :nil];
//            [av show];
//            [av release];
//        }
//    }
//    else
//    {
//        if([appObject.loyalaz.user.mobilephone isEqualToString:@""])
//        {
//            [self StartStep2];
//        }
//        else
//        {
//            [self MoveToHomeScreen];
//        }
//    }
//    
//}

@end
