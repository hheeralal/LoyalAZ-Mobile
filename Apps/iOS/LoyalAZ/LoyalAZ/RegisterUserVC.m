//
//  RegisterUserVC.m
//  LoyalAZ

#import "RegisterUserVC.h"

@interface RegisterUserVC ()

@end

@implementation RegisterUserVC
@synthesize tblRegister;
@synthesize viewEULA;
@synthesize visiblePopTipViews;
@synthesize currentPopTipViewTarget;

//@synthesize loadingView,activityView;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


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

    
    self.title=@"Registration";
    appObject = [Application applicationManager];
    sendingEmail = NO;    
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonSystemItemAction target:self action:@selector(NextClicked)];
    self.navigationItem.rightBarButtonItem=nextButton;
    [nextButton release];

    firstName = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 240, 30)];
    firstName.placeholder=@"Your name:";
    firstName.delegate=self;
    
    lastName = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 240, 30)];
    lastName.placeholder=@"Surname:";
    lastName.delegate=self;
    
    
    emailId = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 240, 30)];
    emailId.placeholder=@"Your best email:";
    emailId.delegate=self;
    emailId.keyboardType=UIKeyboardTypeEmailAddress;
    
    
    labelAgree = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 30)];
    labelAgree.text = @"I agree to terms";
    labelAgree.textColor = [UIColor blueColor];
    
    labelTip = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 30)];
    [labelTip setFont:[UIFont systemFontOfSize:12]];
    labelTip.text = @"Tap ";
    
    
    arrayFields = [[NSArray alloc]initWithObjects:firstName,lastName,emailId,labelAgree,labelTip,nil];
    
    arrayTipMessages = [[NSArray alloc]initWithObjects:@"Your Reward Cards will be personalised so that only you can use it",@"You will be protected from an identity theft",@"You can always recover ALL your Reward Cards or Coupons and its data, even if you lost your phone or accidentally deleted this app – the LoyalAZ will email to you ‘restore’ info and you can continue using all your loyalty cards and can redeem all accumulated rewards. Your Privacy is Safe with LoyalAZ.com’", nil];
    
//    [lastName release];
//    [emailId release];
//    [labelAgree release];
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
    self.navigationController.navigationBarHidden = NO;
    self.trackedViewName = @"Registration Step 1";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arrayFields.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Step 1 (Amazing savings ahead)!";
    //return @"Step 2 (Almost done and ready to earn)!";
}


-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    
}

-(void)ShowToolTip:(UIButton *)sender
{
    [self HideKeyboard];
    [self dismissAllPopTipViews];
    CMPopTipView *popTipView;
    int buttonTag = sender.tag;
    popTipView = [[[CMPopTipView alloc] initWithMessage:[arrayTipMessages objectAtIndex:buttonTag]] autorelease];
    popTipView.delegate = self;
    
    popTipView.animation = arc4random() % 2;
    popTipView.textColor = [UIColor blackColor];
    popTipView.backgroundColor = [UIColor lightTextColor];
    
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:5.0];

    
    [popTipView presentPointingAtView:[arrayFields objectAtIndex:buttonTag] inView:self.view animated:YES];
    
    [visiblePopTipViews addObject:popTipView];
    self.currentPopTipViewTarget = self;
}


- (void)dismissAllPopTipViews {
	while ([visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = [visiblePopTipViews objectAtIndex:0];
		[popTipView dismissAnimated:YES];
		[visiblePopTipViews removeObjectAtIndex:0];
	}
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc]init]autorelease];
//    UITextField *tf = [arrayFields objectAtIndex:indexPath.row];
    [cell.contentView addSubview:[arrayFields objectAtIndex:indexPath.row]];
    if(indexPath.row==3)
    {
        unchecked = [UIButton buttonWithType:UIButtonTypeCustom];
        unchecked.imageView.image = [UIImage imageNamed:@"unchecked.png"];
        [unchecked setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [unchecked setFrame:CGRectMake(0, 0, 50, 35)];
        [unchecked addTarget:self action:@selector(CheckUncheck) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = unchecked;
    }
    else if(indexPath.row==4)
    {

        UIImageView *imgTip = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hint.png"]];
        [imgTip setFrame:CGRectMake(45, 13, 16, 16)];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(65,9,185,25)];
        lbl.text = @"to find out why this info is needed.";
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:imgTip];
        [cell.contentView addSubview:lbl];
    }
    else
    {
        UIButton *buttonHint = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonHint.imageView.image = [UIImage imageNamed:@"hint.png"];
        [buttonHint setImage:[UIImage imageNamed:@"hint.png"] forState:UIControlStateNormal];
        [buttonHint setFrame:CGRectMake(50, 20, 50, 35)];
        buttonHint.tag = indexPath.row;
        [buttonHint addTarget:self action:@selector(ShowToolTip:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = buttonHint;
    }
    return cell;
}

- (void) CheckUncheck
{
    //NSLog(@"clicked");
    agreeed =! agreeed;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [tblRegister cellForRowAtIndexPath:indexPath];
    UIImage *image;
    if(agreeed)
    {
        image = [UIImage imageNamed:@"checked.png"];
    }
    else 
    {
        image = [UIImage imageNamed:@"unchecked.png"];
    }
    [unchecked setImage:image forState:UIControlStateNormal];
    cell.accessoryView = unchecked;
    
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==3)
    {
        
        self.navigationController.navigationBarHidden=YES;
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
        [viewEULA setFrame:CGRectMake(0, 0, 320, 460)];
        NSString *urlAddress = @"http://www.loyalaz.com/mobileTOC.htm";
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [webEULA loadRequest:requestObj];
        [self.view addSubview:viewEULA];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempTextField=textField;
    [self ScrollTableView];
}

- (IBAction)DismissEULA
{
    self.navigationController.navigationBarHidden=NO;    
    [viewEULA removeFromSuperview];
}


-(void)ScrollTableView
{
    //CustomTextField *ctf = (CustomTextField *)tempTextField;
    //NSLog(@"BodyPartId=%d",ctf.WeightsORReps);
    
    CGRect textFieldRect = [self.view.window convertRect:tempTextField.bounds fromView:tempTextField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)HideKeyboard
{
    [tempTextField resignFirstResponder];
}


-(void)NextClicked
{

    [self HideKeyboard];
    
    if([self ValidateData])
    {
        [self ShowActivityView];
        
        if([Helper IsInternetAvailable]==NO)
        {

            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Internet connection is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles :nil];
            [av show];
            [av release];
            [self HideActivityView];
        }
        else
        {
            [self ValidateEmailId];
        }
    
    }
}

-(void)ValidateEmailId
{
    validatingEmail = YES;
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject ValidateEmailId:emailId.text];
}


-(void)ValidateSecurityToken
{
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject XMLDBRecovery:@""];
}

- (BOOL) ValidateData
{
    
    UIAlertView *alertMessage;
    NSString *title=nil, *msg = nil;
    title = @"Validation";

    if(firstName.text.length==0)
    {
        msg = @"First name can't be blank.";
    }
    else if(lastName.text.length==0)
    {
        msg = @"Last name can't be blank.";
    }
    else if(emailId.text.length==0)
    {
        msg = @"Email Id can't be blank.";
    }
    else if(agreeed==NO)
    {
        msg = @"You must agree to terms and conditions before proceeding.";
    }
    else
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL valid = [emailTest evaluateWithObject:emailId.text];
        if(valid==NO)
        {
            msg = @"Email Id should be valid.";
        }
        
    }
    
    
    if(msg != nil)
    {
        alertMessage = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMessage show];
        [alertMessage release];
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheetView.tag==2) //Alert box of email sent message.
    {
        DataRecoveryVC *dataRecoveryVC = [[DataRecoveryVC alloc]initWithNibName:@"DataRecoveryVC" bundle:nil];
        dataRecoveryVC.delegate = self;
        [self presentViewController:dataRecoveryVC animated:YES completion:nil];
        [dataRecoveryVC release];
        return;
    }
    
    if(buttonIndex==0)
    {
        //NSLog(@"No clicked");
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"You need to use different email id for registration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
    else if(buttonIndex==1)
    {
        //NSLog(@"Yes clicked"); // start the recovery process
        
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        
        businessObject.delegate = self;
        sendingEmail = YES;
        [businessObject SendSecurityTokenEmail:emailId.text];
        
    }
}

- (void)BusinessLayerDidFinish:(BOOL)result
{

    [self HideActivityView];
    
    if(sendingEmail==YES)
    {
        sendingEmail = NO;
        if(result==YES)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"An email with Security Token is sent to your registered email id." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            av.tag = 2;
            [av show];
            [av release];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Unable to send you the Security Token to your email id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
        return;
    }
    
    if(validatingEmail==YES)
    {
        if(result==YES) // this means email id doesn't exist
        {
            [self ShowActivityView];
            
            appObject.loyalaz.user.firstname=firstName.text;
            appObject.loyalaz.user.lastname=lastName.text;
            appObject.loyalaz.user.email=emailId.text;
            appObject.loyalaz.user.dtoken = appObject.deviceToken;
            
            BusinessLayer *businessObject = [[BusinessLayer alloc]init];
            
            businessObject.delegate = self;
            [businessObject UserRegistrationStep1];
            validatingEmail = NO;
        }
        else if(result==NO)
        {
            // Show alert to user that email already exists
            // Do you want to recover the data?
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"This email is already registered in the database.\nDo you want to recover your existing data?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            [av show];
            [av release];
        }
    }
    else if(validatingEmail==NO)
    {
        if(result==YES)
        {
            RegisterUserStep2VC *registerUserStep2VC = [[RegisterUserStep2VC alloc]initWithNibName:@"RegisterUserStep2VC" bundle:nil];
            [self.navigationController pushViewController:registerUserStep2VC animated:YES];
            [registerUserStep2VC release];
        }
    }
}


- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"The email already exists and currently inactive. Please contact system administrator to activate or try another email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    av.tag=9;
    [av show];
    [av release];

}

-(void) DataRecoveryVCDidFinish
{
    //NSLog(@"data recovered.");
    HomeVC *homeVC = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:YES];
    [homeVC release];
}

-(void) DataRecoveryVCDidCancelled
{
    
}



@end
