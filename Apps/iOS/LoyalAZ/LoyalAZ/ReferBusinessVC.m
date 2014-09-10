//
//  ReferBusinessVC.m
//  LoyalAZ
//

#import "ReferBusinessVC.h"

@interface ReferBusinessVC ()

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation ReferBusinessVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibNameExtras:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withExtras:(NSArray*)extras
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        lat = [extras objectAtIndex:0];
        lng = [extras objectAtIndex:1];
        
//        NSLog(@"LAT=%@",lat);
        
        if([[extras objectAtIndex:2] isEqualToString:@"1"])
            use_gps = YES;
        else
            use_gps = NO;
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
    refBusiness = [[ReferBusiness alloc]init];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveClicked:)];
    self.navigationItem.rightBarButtonItem=saveButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked:)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    textcompanyname = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    textcompanyname.placeholder=@"Company name";
    textcompanyname.delegate=self;
    
    textcompanyphone = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    textcompanyphone.placeholder=@"Company phone";
    textcompanyphone.delegate=self;
    
    textcompanyemail = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    textcompanyemail.placeholder=@"Company email";
    textcompanyemail.delegate=self;
    
    textcompanymgrfirsttname = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    textcompanymgrfirsttname.placeholder=@"Manager first name";
    textcompanymgrfirsttname.delegate=self;
    
    textcompanymgrlastname = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    textcompanymgrlastname.placeholder=@"Manager last name";
    textcompanymgrlastname.delegate=self;
    
    textreason = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 60)];
    textreason.placeholder=@"Reason for recommendation";
    textreason.delegate=self;
    
    textcompanyaddress = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 60)];
    textcompanyaddress.placeholder=@"Company address";
    textcompanyaddress.delegate=self;
    
    refBusiness.com_id = com_id;
    refBusiness.lat = lat;
    refBusiness.lng = lng;
    
    if(use_gps)
        arrayFields = [[NSArray alloc]initWithObjects:textcompanyname,textcompanyphone,textcompanyemail, textcompanymgrfirsttname,textcompanymgrlastname,textreason,nil];
    else
        arrayFields = [[NSArray alloc]initWithObjects:textcompanyname,textcompanyphone,textcompanyemail, textcompanymgrfirsttname,textcompanymgrlastname,textreason,textcompanyaddress,nil];
}

- (void) SaveClicked:(id)sender
{

    if([self ValidateData])
    {
        [self ShowActivityView];
        
        refBusiness.rec_cname = textcompanyname.text;
        refBusiness.rec_phone = textcompanyphone.text;
        refBusiness.rec_email = textcompanyemail.text;
        refBusiness.rec_mgrfname = textcompanymgrfirsttname.text;
        refBusiness.rec_mgrlname = textcompanymgrlastname.text;
        refBusiness.rec_whyinvited = textreason.text;
        if(use_gps==YES)
            refBusiness.rec_address = @"";
        else
            refBusiness.rec_address = textcompanyaddress.text;
        
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        businessObject.delegate = self;
        [businessObject SaveReferBusiness:refBusiness];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Refer Business";
}


-(BOOL)ValidateData
{
    BOOL validData = NO;
    NSString *alertMessage = @"";
    if([textcompanyname.text isEqualToString:@""])
    {
        alertMessage = @"Company name can't be blank.";
    }
    else if([textcompanyphone.text isEqualToString:@""])
    {
        alertMessage = @"Company phone can't be blank.";
    }
    else if([textcompanyemail.text isEqualToString:@""])
    {
        alertMessage = @"Company email can't be blank.";
    }
    else if([textcompanymgrfirsttname.text isEqualToString:@""])
    {
        alertMessage = @"Company manager first name can't be blank.";
    }
    else if([textcompanymgrlastname.text isEqualToString:@""])
    {
        alertMessage = @"Company manager last name can't be blank.";
    }
    else if(use_gps==NO && [textcompanyaddress.text isEqualToString:@""])
    {
        alertMessage = @"Company address can't be blank.";
    }
    else
    {
        validData = YES;
    }
    
    if(validData==NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [alertMessage release];
    }
    
    return validData;
}

- (void) BackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Textfield delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempTextField=textField;
    [self ScrollTableView];
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


#pragma mark - Scroll methods

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return sectionContents.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arrayFields.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Please add this Company to LoyalAZ...";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(indexPath.section==0)
    {
        if(cell==nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
            [cell.contentView addSubview:[arrayFields objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    [self HideActivityView];
    if(result==YES)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Thank you for your recommendation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
}

@end
