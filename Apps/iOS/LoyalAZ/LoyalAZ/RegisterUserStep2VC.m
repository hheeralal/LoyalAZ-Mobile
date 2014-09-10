//
//  RegisterUserStep2VC.m
//  LoyalAZ
//

#import "RegisterUserStep2VC.h"

@interface RegisterUserStep2VC ()

@end

@implementation RegisterUserStep2VC
@synthesize tblRegister;
@synthesize visiblePopTipViews;
@synthesize currentPopTipViewTarget;


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
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        
    }

    
    self.title=@"Registration";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonSystemItemAction target:self action:@selector(NextClicked)];
    self.navigationItem.rightBarButtonItem=nextButton;

    countryCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    countryCode.placeholder=@"Country code:";
    countryCode.delegate=self;
    countryCode.keyboardType=UIKeyboardTypePhonePad;
    
//    mobilecompanyCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
//    mobilecompanyCode.placeholder=@"Service code:";
//    mobilecompanyCode.delegate=self;
//    mobilecompanyCode.keyboardType=UIKeyboardTypePhonePad;    
    
    phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    phoneNumber.placeholder=@"Mobile number:";
    phoneNumber.delegate=self;
    phoneNumber.keyboardType=UIKeyboardTypePhonePad;    
    
    countryName = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    countryName.placeholder=@"Country:";
    countryName.delegate=self;
    countryName.tag=1;
    
    city = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    city.placeholder=@"City:";
    city.delegate=self;
    city.keyboardType=UIKeyboardTypeDefault;
    
    arrayFields = [[NSArray alloc]initWithObjects:phoneNumber,city,countryName,nil];
    arrayTipMessages = [[NSArray alloc]initWithObjects:@"In unlikely event of losing all the app data or your phone you can recover all your accumulated points by requesting a ‘restore’ SMS to your mobile.",@"You will receive only programs in your locality – no more annoying marketing without your permission", nil];
    
    
    NSString *countriesXML = [Helper GetCountriesXML];
    countriesObject = [XMLParser XmlToObject:countriesXML];
    //NSLog(@"%d",count1.countries.count);

    
    //arrayCountries = [[NSArray alloc]initWithObjects:@"India",@"Australia",@"United States", nil];
    
    // Load existing values
    Application *appObject = [Application applicationManager];
    phoneNumber.text = appObject.loyalaz.user.mobilephone;
    city.text = appObject.loyalaz.user.addresscity;
    countryName.text = appObject.loyalaz.user.addresscountry;
}


-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.trackedViewName = @"Registration Step 2";
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    UITextField *tf = [arrayFields objectAtIndex:indexPath.row];
    [cell.contentView addSubview:[arrayFields objectAtIndex:indexPath.row]];
    
    if(indexPath.row<2)
    {
        UIButton *buttonHint = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonHint.imageView.image = [UIImage imageNamed:@"hint.png"];
        [buttonHint setImage:[UIImage imageNamed:@"hint.png"] forState:UIControlStateNormal];
        [buttonHint setFrame:CGRectMake(50, 20, 50, 35)];
        buttonHint.tag = indexPath.row;
        [buttonHint addTarget:self action:@selector(ShowToolTip:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = buttonHint;
    }
    
//    if(indexPath.row==0)
//    {
//        [cell.contentView addSubview:countryCode];
//        [cell.contentView addSubview:mobilecompanyCode];
//    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Step 2 (Almost done and ready to earn)!";
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempTextField=textField;
    [self ScrollTableView];
    if(textField.tag==1)
        [self ShowPopup];
    //[self ShowPopup];
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


-(IBAction)ShowPopup
{
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    
    
    pickerViewCountry = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerViewCountry.showsSelectionIndicator = YES;
    pickerViewCountry.dataSource = self;
    pickerViewCountry.delegate = self;
    //pickerViewCountry.datePickerMode=UIDatePickerModeDate;
    [actionSheet addSubview:pickerViewCountry];
    //[pickerViewCountry release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    //[closeButton release];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    //NSInteger selIndex = [arrayCountries indexOfObject:countryName.text];
    //NSInteger selIndex = [countriesObject.countries indexOfObject:countryName.text];    
    
    
    //[pickerViewCountry selectRow:selIndex inComponent:0 animated:YES];
    
}


-(void)dismissActionSheet
{
    //NSLog(@"%@",pickerView.date);
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self HideKeyboard];
}

-(IBAction)HideKeyboard
{
    [tempTextField resignFirstResponder];
}


-(void)NextClicked
{

    
//    if([mobilecompanyCode.text isEqualToString:@""])
//    {
//        UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"Service provider code is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertMsg show];
//        [alertMsg release];
//        //[phoneNumber becomeFirstResponder];
//        return;
//    }    
    
    if([phoneNumber.text isEqualToString:@""])
    {
        UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"Mobile number is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMsg show];
        [alertMsg release];
        //[phoneNumber becomeFirstResponder];
        return;
    }
    
    if([city.text isEqualToString:@""])
    {
        UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"City name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMsg show];
        [alertMsg release];
        //[phoneNumber becomeFirstResponder];
        return;
    }
    
    if([countryName.text isEqualToString:@""])
    {
        UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"Please select the country." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMsg show];
        [alertMsg release];
        //[phoneNumber becomeFirstResponder];
        return;
    }
    
    NSString *phoneString = [[NSString alloc]initWithFormat:@"%@-%@",countryCode.text,phoneNumber.text];
    
    Application *appObject = [Application applicationManager];
    appObject.loyalaz.user.mobilephone=phoneString;
    appObject.loyalaz.user.addresscity=city.text;
    appObject.loyalaz.user.addresscountry=countryName.text;
    
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject UserRegistrationStep2];
    
    
    //NSLog(@"Next clicked.");
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 2;
}




- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"%@",[arrayCountries objectAtIndex:row]);
    Country *tempCountry = [countriesObject.countries objectAtIndex:row];
    countryName.text = tempCountry.name;
    countryCode.text = tempCountry.code;
    
    if(component==0)
        [pickerView selectRow:row inComponent:1 animated:YES];
    else
        [pickerView selectRow:row inComponent:0 animated:YES];
    //countryName.text = [arrayCountries objectAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component==1)
        return 70;
    else
        return 220;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return countriesObject.countries.count;
    //return [arrayCountries count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    
    Country *tempCountry = [countriesObject.countries objectAtIndex:row];
    NSString *rowTitle;
    if(component==0)
    {
        rowTitle = [[NSString alloc]initWithFormat:@"%@",tempCountry.name];
//        if(row>0)
//            rowTitle = [[NSString alloc]initWithFormat:@"%@",tempCountry.name];
//        else
//            rowTitle = @"";
        return rowTitle;
    }
    else if(component==1)
    {
        if(row>0)
        {
            rowTitle = [[NSString alloc]initWithFormat:@"+%@",tempCountry.code];
        }
        else
            rowTitle = [[NSString alloc]initWithFormat:@"%@",tempCountry.code];
        
//        if(row>0)
//            rowTitle = [[NSString alloc]initWithFormat:@"+%@",tempCountry.code];
//        else
//            rowTitle = @"";
        return rowTitle;
    }
    //return tempCountry.name;
    return @"";
    //return [arrayCountries objectAtIndex:row];
}


- (void)BusinessLayerDidFinish:(BOOL)result
{
    if(result==YES)
    {
        Application *appObject = [Application applicationManager];
        appObject.firstTimeRun = YES;
        
        //NSLog(@"Move next.");
        EnableLocationsVC *enableLocationsVC = [[EnableLocationsVC alloc]initWithNibName:@"EnableLocationsVC" bundle:nil];
        //HomeVC *homeVC = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];

        [self.navigationController pushViewController:enableLocationsVC animated:YES];
    }
}


- (void)BusinessLayerErrorOccurred:(NSError *)err
{
    //NSLog(@"Error occurred, can't move further.");
}



@end
