//
//  DataRecoveryVC.m
//  LoyalAZ
//

#import "DataRecoveryVC.h"

@interface DataRecoveryVC ()

@end

@implementation DataRecoveryVC
@synthesize delegate = _delegate;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Data Recovery";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)doneClicked
{
    [self ValidateSecurityToken];
}

-(IBAction)cancelClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate DataRecoveryVCDidCancelled];    
}


-(void)ValidateSecurityToken
{
    [self ShowActivityView];
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject XMLDBRecovery:textToken.text];
}

-(void)BusinessLayerDidFinish:(BOOL)result
{

    [self HideActivityView];
    if(result==YES)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your data has been successfully recovered." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate DataRecoveryVCDidFinish];
    }
    else {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"Security Token entered is invalid.\nPlease try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        
    }
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
}

@end
