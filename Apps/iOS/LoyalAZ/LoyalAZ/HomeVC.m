//
//  HomeVC.m
//  LoyalAZ

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
@synthesize webViewAds;
//@synthesize buttonMyPrograms;
//@synthesize buttonScan,buttonSetup,buttonFindPrograms;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        
    }
    
    getCouponCode = NO;
    
    UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    webViewTapped.numberOfTapsRequired = 1;
    webViewTapped.delegate = self;
    [webViewAds addGestureRecognizer:webViewTapped];
    [webViewTapped release];
    [self AddMotionEffect];
    
    Application *appObject = [Application applicationManager];
    if(appObject.fromNotification==YES)
    {
        if(appObject.isCoupon==NO) {
            [self ShowFindPrograms:nil];
        }
        else if(appObject.isCoupon==YES) {
            [self ShowFindCoupons:nil];
        }
        
    }
    
//    Application *appObject = [Application applicationManager];
//    if(appObject.firstTimeRun==YES)
//        [self ShowTutorial];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{

    Application *appObj = [Application applicationManager];
//    NSLog(@"touched=%@",appObj.adsURL);
//    NSURL *adsURL = [[NSURL alloc]initWithString:appObj.adsURL];
    [[UIApplication sharedApplication] openURL:appObj.advertObject.linkURL];
    // Get the specific point that was touched
//    CGPoint point = [sender locationInView:self.view];
}

-(void)ShowTutorial
{
    TutorialVC *tutorialVC = [[TutorialVC alloc]initWithNibName:@"TutorialVC" bundle:nil];
    [self presentViewController:tutorialVC animated:YES completion:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    if([businessObject IsRedeemPending])
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Redeem" message:@"You have FREE reward, please check My Programs for details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    Application *appObj = [Application applicationManager];
    if([appObj.loyalaz.ads_enable isEqualToString:@"1"])
    {
        if([Helper IsInternetAvailable])
        {
            [self.webViewAds setHidden:NO];
            BusinessLayer *businessLayer = [[BusinessLayer alloc]init];
            businessLayer.delegate = self;
            [businessLayer GetAdsURL];
            [self.webViewAds setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-50, 280, 40)];
        }
        else
        {
            [self.webViewAds setHidden:YES];
        }
    }
    else
    {
        [self.webViewAds setHidden:YES];
    }
    
}

-(void)RefreshAds
{
    BusinessLayer *businessLayer = [[BusinessLayer alloc]init];
    businessLayer.delegate = self;
    [businessLayer GetAdsURL];
//    NSLog(@"Ad refreshed.");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)ScanQRCode:(id)sender
{
    [self StartScan];
}

-(void)StartScan
{
    ProgramsVC *programsVC = [[ProgramsVC alloc]initWithNibNameAndCamera:@"ProgramsVC" bundle:nil];
    [self.navigationController pushViewController:programsVC animated:YES];
    [programsVC release];
}


-(IBAction)ShowMyPrograms:(id)sender
{
    ProgramsVC *programsVC = [[ProgramsVC alloc]initWithNibName:@"ProgramsVC" bundle:nil];
    [self.navigationController pushViewController:programsVC animated:YES];
    [programsVC release];
}

-(IBAction)ShowFindPrograms:(id)sender
{
    if([Helper IsInternetAvailable]==YES)
    {
        FindProgramsVC *fpvc = [[FindProgramsVC alloc]initWithNibName:@"FindProgramsVC" bundle:nil];
        [self.navigationController pushViewController:fpvc animated:YES];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Internet connection is required to Find Programs.\nPlease check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles :nil];
        [av show];
        [av release];
    }

    //[fpvc release];
}

-(IBAction)ShowFindCoupons:(id)sender
{
    if([Helper IsInternetAvailable]==YES)
    {
        FindCouponsVC *fcvc = [[FindCouponsVC alloc]initWithNibName:@"FindCouponsVC" bundle:nil];
        [self.navigationController pushViewController:fcvc animated:YES];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Internet connection is required to Find Programs.\nPlease check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles :nil];
        [av show];
        [av release];
    }
}

-(IBAction)ShowSetup:(id)sender
{
    SetupVC *setupVC = [[SetupVC alloc]initWithNibName:@"SetupVC" bundle:nil];
    [self.navigationController pushViewController:setupVC animated:YES];
    [setupVC release];
    //
}

-(IBAction)ShowMyCoupons:(id)sender
{
    CouponsVC *couponsVC = [[CouponsVC alloc]initWithNibName:@"CouponsVC" bundle:nil];
    [self.navigationController pushViewController:couponsVC animated:YES];
    [couponsVC release];
}


- (void)BusinessLayerDidFinish:(BOOL)result
{
    if(result==YES)
    {
        Application *appObj = [Application applicationManager];
//        NSURL *adsURL = [[NSURL alloc]initWithString:appObj.adsURL];
//        NSLog(@"URL=%@",adsURL);
        NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:appObj.advertObject.imageURL];
        [self.webViewAds loadRequest:urlRequest];
        
//        NSLog(@"%d",appObj.advertObject.duration);
        int duration = [appObj.advertObject.duration intValue];
        [NSTimer scheduledTimerWithTimeInterval:duration
                                         target:self
                                       selector:@selector(RefreshAds)
                                       userInfo:nil
                                        repeats:NO];
    }
}


- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    //NSLog(@"Error occurred, can't move further.");
    
}

-(void)AddMotionEffect
{
    /////////////////////////////////////PARALLAX Effect begins/////////////////////////
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);

    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);

    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.buttonScan addMotionEffect:group];
    [self.buttonSetup addMotionEffect:group];
    [self.buttonFindCoupons addMotionEffect:group];
    [self.buttonFindPrograms addMotionEffect:group];
    [self.buttonMyCoupons addMotionEffect:group];
    [self.buttonMyPrograms addMotionEffect:group];
    
    //
    //    // Add both effects to your view
    //    [webViewAds addMotionEffect:group];
    /////////////////////////////////////PARALLAX Effect ends/////////////////////////
}


@end