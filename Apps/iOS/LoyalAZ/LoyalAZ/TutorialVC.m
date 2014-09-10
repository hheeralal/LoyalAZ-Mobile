//
//  TutorialVC.m
//  LoyalAZ
//

#import "TutorialVC.h"

@interface TutorialVC ()

@end

@implementation TutorialVC
@synthesize buttonSkip;

@synthesize imageViewFindCoupons,imageViewFindPrograms,imageViewMyCoupons,imageViewMyPrograms,imageViewScan,imageViewSetup,imageViewStep;
@synthesize imageViewButton;

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
    
    // Do any additional setup after loading the view from its nib.
    //[buttonSkip setAlpha:1.0];
    stepIndex = 0;
    [self HideAll];

}

-(void)viewWillAppear:(BOOL)animated
{
        self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)GetStarted:(id)sender
{
    self.buttonGetStarted.hidden=YES;
//    self.buttonSkip.hidden=YES;
    stepIndex++;
    [self ShowStep];
}

-(IBAction)SkipTutorial
{
    Application *appObject = [Application applicationManager];
    appObject.loyalaz = [Helper GetObjectFromDB];

    if([appObject.loyalaz.user.uid isEqualToString:@""]) //This will be EMPTY if the user is not yet registered.
    {
        RegisterUserVC *registerUserVC = [[RegisterUserVC alloc]initWithNibName:@"RegisterUserVC" bundle:nil];
        [self.navigationController pushViewController:registerUserVC animated:YES];
        [registerUserVC release];

    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

-(IBAction)ShowBack:(id)sender
{
    stepIndex--;
    [self ShowStep];    
}

-(IBAction)ShowNext:(id)sender
{
    if(self.buttonGetStarted.hidden==NO)
        self.buttonGetStarted.hidden=YES;
    
    if(stepIndex==13)
    {
        [self SkipTutorial];
    }
    
    
    stepIndex++;
    [self ShowStep];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Tutorials";
}


-(void)ShowStep
{
    if(stepIndex==1)
    {
        [self.buttonSkip setFrame:CGRectMake(112, 410, 90, 41)];
//        self.buttonSkip.hidden=NO;
        self.buttonBack.hidden=YES;
    }
    else if(stepIndex==13)
    {
        //self.buttonNext.hidden=YES;
        [self.buttonNext setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonNext setImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        self.buttonNext.hidden=NO;
        self.buttonBack.hidden=NO;
    }
    [self HideAll];
    NSLog(@"STEP=%d",stepIndex);
    CGRect cRect;
    switch (stepIndex) {
        case 1:
            self.imageViewStep.hidden=YES;
            self.imageViewButton.hidden=NO;
            self.imageViewButton.image = [UIImage imageNamed:@"page1-asset1.png"];
            cRect = self.imageViewButton.frame;
            cRect.size.width = 262;
            cRect.size.height = 93;
            cRect.origin.x=18;
            cRect.origin.y=218;
            [self.imageViewButton setFrame:cRect];
            [self.view bringSubviewToFront:self.imageViewButton];

            break;
        case 2:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page2-asset1.png"];
            break;
        case 3:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page2-2-asset1.png"];
            break;
        case 4:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page2-3-asset1.png"];
            break;
        case 5:
            self.imageViewStep.hidden=YES;
            self.imageViewButton.hidden=NO;
            self.imageViewButton.image = [UIImage imageNamed:@"page3-asset1.png"];
            cRect = self.imageViewButton.frame;
            cRect.size.width = 180;
            cRect.size.height = 172;
            cRect.origin.x=87;
            cRect.origin.y=135;
            [self.imageViewButton setFrame:cRect];
            [self.view bringSubviewToFront:self.imageViewButton];

            break;
        case 6:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page4-asset1.png"];
            break;
        case 7:
            self.imageViewStep.hidden=YES;
            self.imageViewButton.hidden=NO;
            self.imageViewButton.image = [UIImage imageNamed:@"page5-asset1.png"];
            cRect = self.imageViewButton.frame;
            cRect.size.width = 175;
            cRect.size.height = 205;
            cRect.origin.x=137;
            cRect.origin.y=106;
            [self.imageViewButton setFrame:cRect];
            [self.view bringSubviewToFront:self.imageViewButton];

            break;
        case 8:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page6-asset1.png"];

            break;
        case 9:
            self.imageViewStep.hidden=YES;
            self.imageViewButton.hidden=NO;
            self.imageViewButton.image = [UIImage imageNamed:@"page7-asset1.png"];
            cRect = self.imageViewButton.frame;
            cRect.size.width = 270;
            cRect.size.height = 100;
            cRect.origin.x=14;
            cRect.origin.y=304;
            [self.imageViewButton setFrame:cRect];
            [self.view bringSubviewToFront:self.imageViewButton];
            break;
        case 10:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page8-asset1.png"];

            break;
        case 11:
            self.imageViewStep.hidden=YES;
            self.imageViewButton.hidden=NO;
            self.imageViewButton.image = [UIImage imageNamed:@"page9-asset1.png"];
            cRect = self.imageViewButton.frame;
            cRect.size.width = 178;
            cRect.size.height = 144;
            cRect.origin.x=81;
            cRect.origin.y=258;
            [self.imageViewButton setFrame:cRect];
            [self.view bringSubviewToFront:self.imageViewButton];

            break;
        case 12:
            self.imageViewStep.hidden=NO;
            self.imageViewStep.image = [UIImage imageNamed:@"page10-asset1.png"];
            break;
        case 13:
            self.imageViewStep.hidden=YES;
            self.imageViewButton.hidden=NO;
            self.imageViewButton.image = [UIImage imageNamed:@"page11-asset1.png"];
            cRect = self.imageViewButton.frame;
            cRect.size.width = 272;
            cRect.size.height = 97;
            cRect.origin.x=39;
            cRect.origin.y=309;
            [self.imageViewButton setFrame:cRect];
            [self.view bringSubviewToFront:self.imageViewButton];
            break;
            
        default:
            break;
    }
    
}


-(void)HideAll
{
    self.imageViewButton.hidden=YES;
    self.imageViewStep.hidden=YES;
    self.imageViewFindCoupons.image = [UIImage imageNamed:@"find_coupon.png"];
    self.imageViewFindPrograms.image = [UIImage imageNamed:@"find_programs.png"];
    self.imageViewScan.image = [UIImage imageNamed:@"scan.png"];
    self.imageViewMyPrograms.image = [UIImage imageNamed:@"myprograms.png"];
    self.imageViewMyCoupons.image = [UIImage imageNamed:@"mycoupons.png"];
    self.imageViewSetup.image = [UIImage imageNamed:@"setup.png"];
    
    [self SetViewFrame:self.imageViewFindPrograms];
    [self SetViewFrame:self.imageViewFindCoupons];
    [self SetViewFrame:self.imageViewScan];
    [self SetViewFrame:self.imageViewMyPrograms];
    [self SetViewFrame:self.imageViewMyCoupons];
    [self SetViewFrame:self.imageViewSetup];
    

    
}

-(void)SetViewFrame:(UIImageView *)imageView
{
    CGRect cRect = imageView.frame;
    cRect.size.width = 84;
    [imageView setFrame:cRect];
    
    [imageView setAlpha:0.2];
}

@end
