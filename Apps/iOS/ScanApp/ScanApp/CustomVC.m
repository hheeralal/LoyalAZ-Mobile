//
//  CustomVC.m
//  LoyalAZ
//

#import "CustomVC.h"

@interface CustomVC ()

@end

@implementation CustomVC

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) ShowActivityView
{
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    loadingView.backgroundColor = [UIColor darkGrayColor];
    loadingView.alpha=0.7f;
    
    [self.view addSubview:loadingView];
    //activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(160-16, 228-37, 37, 37)];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center=self.view.center;
    [loadingView addSubview:activityView];
    [activityView startAnimating];
    
}

- (void) HideActivityView
{
    [loadingView setHidden:YES];
    [activityView setHidden:YES];
    [activityView stopAnimating];
    [loadingView removeFromSuperview];
    [activityView removeFromSuperview];
}

@end
