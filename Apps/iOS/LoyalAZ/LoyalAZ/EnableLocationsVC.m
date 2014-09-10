//
//  EnableLocationsVC.m
//  LoyalAZ
//

#import "EnableLocationsVC.h"

@interface EnableLocationsVC ()

@end

@implementation EnableLocationsVC

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
    NSString *msg = @"Please enable \"Location Services\", so that AZ can find more opportunities for you to  earn Loyalty Rewards nearby...";
    UIAlertView *alertViewLocations = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Enable" otherButtonTitles:@"Disable", nil];
    [alertViewLocations show];
    [alertViewLocations release];
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

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Index clicked:%@",buttonIndex);
    
    Application *appObject = [Application applicationManager];
    appObject.loyalaz.enableFBPost = @"";
    
    if(buttonIndex==0)
        appObject.loyalaz.find_enable = @"1";
    else
        appObject.loyalaz.find_enable = @"0";
    
    [Helper SaveObjectToDB:appObject.loyalaz];
    //[Helper SaveSettingsToFile:appObject.settings];
    
    HomeVC *homeVC = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:YES];
    [homeVC release];
}

@end
