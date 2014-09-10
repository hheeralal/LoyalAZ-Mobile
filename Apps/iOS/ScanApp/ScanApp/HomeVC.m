//
//  HomeVC.m
//  ScanApp
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
@synthesize labelCompany;

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
    Application *appObj = [Application applicationManager];
    labelCompany.text = appObj.scanapp.companyname;
    
    [self ScanCoupon:@""];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ScanCoupon:(id)sender
{
    ScanQR *scanObject = [[ScanQR alloc]init];
    scanObject.scandelegate = self;
    [scanObject ScanCode:self];
    
//    [self ScanDidFinish:@"357+22+32620131137-4966D+expiration based"];
}

- (void)ScanDidFinish:(NSString *)resultString
{
    NSLog(@"Scanned code===%@",resultString);
    //Create the object of Program here and do the next step.
    
    NSArray *stringValues = [resultString componentsSeparatedByString:@"+"];
    if([stringValues count]!=4)
    {
        NSString *message = [[NSString alloc]initWithFormat:@"This is not a valid coupon."];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];
        return;

    }
    else
    {
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        businessObject.delegate = self;
        cpn = [[Coupon alloc]init];
        cpn.uid = [stringValues objectAtIndex:0];
        cpn.id = [stringValues objectAtIndex:1];
        cpn.guid = [stringValues objectAtIndex:2];
        //cpn.type = [stringValues objectAtIndex:3];
        flagValidate = YES;
        [businessObject ValidateCoupon:cpn];

    }
}

- (void)ScanDidCancelled
{
    [self HideActivityView];
}


-(void)BusinessLayerDidFinishWithResponseCode:(NSString *)responseCode
{
    if(flagValidate==YES)
    {
        flagValidate=NO;
        NSString *message = @"";
        if([responseCode isEqualToString:@"2"])
            message = [[NSString alloc]initWithFormat:@"System Error"];
        else if([responseCode isEqualToString:@"3"])
            message = [[NSString alloc]initWithFormat:@"Coupon expired."];
        else if([responseCode isEqualToString:@"4"])
            message = [[NSString alloc]initWithFormat:@"Coupon redemption exceeds its limitation"];
        else if([responseCode isEqualToString:@"5"])
            message = [[NSString alloc]initWithFormat:@"User has already redeemed the same coupon"];
        else if([responseCode isEqualToString:@"6"])
            message = [[NSString alloc]initWithFormat:@"GUID has already been used"];
        else if([responseCode isEqualToString:@"7"])
            message = [[NSString alloc]initWithFormat:@"Not allowed to scan other company's coupon"];
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];
    }
    else
    {
        flagValidate=NO;
        
        NSString *message = @"";
        message = [[NSString alloc]initWithFormat:@"System Error"];
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];
    }
}


#pragma mark - Business Layer Delegates

- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    //NSLog(@"Error occurred, can't move further.");
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    if(flagValidate==YES)
    {
        flagValidate=NO;
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        businessObject.delegate = self;
        [businessObject RedeemCoupon:cpn];
    }
    else
    {
        flagValidate=NO;
        NSString *message = @"";
        message = [[NSString alloc]initWithFormat:@"Coupon redeemed sucessfully."];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [message release];

    }

}


-(IBAction)Logout:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
