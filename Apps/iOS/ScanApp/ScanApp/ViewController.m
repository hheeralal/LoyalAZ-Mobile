//
//  ViewController.m
//  ScanApp
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textPassword,textUsername;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)AuthenticateUser
{

    [self ShowActivityView];
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject AuthenticateUser:textUsername.text withPassword:textPassword.text];
    
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    [self HideActivityView];
    if(result==YES)
    {
        HomeVC *homeVC = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:YES];
        [homeVC release];
    }
    else
    {
        NSString *message = [[NSString alloc]initWithFormat:@"Invalid Username/Password, please try again."];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    textUsername.text = @"";
    textPassword.text = @"";
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
}

-(void)BusinessLayerDidFinishWithResponseCode:(NSString *)responseCode
{

}

@end
