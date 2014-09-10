//
//  SetupVC.m
//  LoyalAZ
//

#import "SetupVC.h"

@interface SetupVC ()

@end

@implementation SetupVC
@synthesize tableSetup;
@synthesize window = _window;
@synthesize navController;
@synthesize registerUserVC;


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


#pragma mark - View methods

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

    
    self.navigationController.navigationBarHidden=NO;
    
    isDeleting = NO;
    
    appObject = [Application applicationManager];
    
    NSArray *phoneItems = [appObject.loyalaz.user.mobilephone componentsSeparatedByString:@"-"];
    
    firstName = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    firstName.placeholder=@"Your name:";
    firstName.delegate=self;
    firstName.text = appObject.loyalaz.user.firstname;
    
    lastName = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    lastName.placeholder=@"Surname:";
    lastName.delegate=self;
    lastName.text = appObject.loyalaz.user.lastname;
    
    emailId = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    emailId.placeholder=@"Your best email:";
    emailId.delegate=self;
    emailId.keyboardType=UIKeyboardTypeEmailAddress;
    emailId.text = appObject.loyalaz.user.email;
    
    phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    phoneNumber.placeholder=@"Mobile number:";
    phoneNumber.delegate=self;
    phoneNumber.keyboardType=UIKeyboardTypePhonePad;
    //phoneNumber.text = appObject.loyalaz.user.mobilephone;
    phoneNumber.text = [phoneItems objectAtIndex:1];
    
    countryCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    countryCode.placeholder=@"Country code:";
    countryCode.delegate=self;
    countryCode.keyboardType=UIKeyboardTypePhonePad;    
    countryCode.text = [phoneItems objectAtIndex:0];    
    
//    mobilecompanyCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
//    mobilecompanyCode.placeholder=@"Service code:";
//    mobilecompanyCode.delegate=self;
//    mobilecompanyCode.keyboardType=UIKeyboardTypePhonePad;        
//    mobilecompanyCode.text = [phoneItems objectAtIndex:1];
    
    city = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    city.placeholder=@"City:";
    city.delegate=self;
    city.keyboardType=UIKeyboardTypeEmailAddress;
    city.text = appObject.loyalaz.user.addresscity;
    
    countryName = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    countryName.placeholder=@"Country:";
    countryName.delegate=self;
    countryName.tag=1;
    countryName.text = appObject.loyalaz.user.addresscountry;
    
    
    location = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    location.text=@"Location Services";
    locationService = [[UISwitch alloc]init];
    location.backgroundColor = [UIColor clearColor];
    
    enableFB = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    enableFB.text=@"Facebook Posts";
    enableFB.backgroundColor = [UIColor clearColor];
    
    dataSync = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    dataSync.text=@"Data Sync";
    dataSync.backgroundColor = [UIColor clearColor];
    
    deleteAccount = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
    deleteAccount.text=@"Delete Account";
    deleteAccount.backgroundColor = [UIColor clearColor];
    
    enableFBPosts = [[UISwitch alloc]init];
    
    if([appObject.loyalaz.find_enable isEqualToString:@"1"])
    {
        locationService.on=YES;
    }
    else
    {
        locationService.on=NO;
    }
    
    if([appObject.loyalaz.enableFBPost isEqualToString:@"1"])
    {
        enableFBPosts.on=YES;
    }
    else
    {
        enableFBPosts.on=NO;
    }
    
    
    arrayFields = [[NSArray alloc]initWithObjects:firstName,lastName,emailId, phoneNumber,city,countryName,location,enableFB,dataSync,nil];
    
    
    //sectionContents = [[NSArray alloc]initWithObjects:arrayFields,@"", nil];
    
    NSString *countriesXML = [Helper GetCountriesXML];
    countriesObject = [XMLParser XmlToObject:countriesXML];

    
    //arrayCountries = [[NSArray alloc]initWithObjects:@"India",@"Australia",@"United States", nil];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonSystemItemDone target:self action:@selector(DoneClicked)];
    //self.navigationItem.rightBarButtonItem=doneButton;

    UIBarButtonItem *tutorialButton = [[UIBarButtonItem alloc]initWithTitle:@"Help" style:UIBarButtonSystemItemDone target:self action:@selector(TutorialClicked)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:doneButton,tutorialButton, nil];

    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Textfield delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tempTextField=textField;
    [self ScrollTableView];
    if(textField.tag==1)
        [self ShowPopup];
    //[self ShowPopup];
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

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Setup";
}




-(void)ShowPopup
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
    [pickerViewCountry release];
    
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    [closeButton release];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    NSInteger selIndex =0;
//    NSLog(@"CODE=%@",countryCode.text);
    
    Country *cntTemp = [[Country alloc]init];
    Country *cntTemp2 = [[Country alloc]init];
//    cntTemp.code = countryCode.text;
    cntTemp.name = countryName.text;
    
    for(int i=0;i<countriesObject.countries.count;i++)
    {
        cntTemp2 = [countriesObject.countries objectAtIndex:i];
        if([cntTemp2.name isEqualToString:cntTemp.name])
        {
            selIndex = i;
            break;
        }
    }
    
    [cntTemp release];
    [cntTemp2 release];
//    selIndex = [countriesObject.countries indexOfObject:cntTemp];
    [pickerViewCountry selectRow:selIndex inComponent:0 animated:YES];
    [pickerViewCountry selectRow:selIndex inComponent:1 animated:YES];
    
}


-(void)dismissActionSheet
{
    //NSLog(@"%@",pickerView.date);
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [countryName resignFirstResponder];
//    [self HideKeyboard];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return sectionContents.count;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section==0)
        return arrayFields.count;
    else
        return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return @"Edit your profile";
    else
        return @"";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section==1)
        return @"2.0.3";
    else
        return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(indexPath.section==0)
    {
        
        if(indexPath.row<7)
        {
            UITextField *tf = [arrayFields objectAtIndex:indexPath.row];
            [cell.contentView addSubview:tf];
        }
        else if(indexPath.row==7)
        {
            [cell.contentView addSubview:[arrayFields objectAtIndex:indexPath.row]];
        }
        else if(indexPath.row==8)
        {
            [cell.contentView addSubview:[arrayFields objectAtIndex:indexPath.row]];
        }
        
        
        if(indexPath.row==6)
        {
            cell.accessoryView=locationService;
        }
        
        if(indexPath.row==7)
        {
            cell.accessoryView = enableFBPosts;
        }
        
        if(indexPath.row==8)
        {
            UIButton *buttonSync = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [buttonSync setTitle:@"Sync" forState:UIControlStateNormal];
            [buttonSync setFrame:CGRectMake(0, 0, 100, 35)];
            [buttonSync addTarget:self action:@selector(ButtonSyncClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = buttonSync;
            //[tableView cellForRowAtIndexPath:indexPath].accessoryView = downloadButton;
        }
    }
    else if(indexPath.section==1)
    {
//        cell.textLabel.text = @"DELETE!!!!!!";
        UIButton *buttonDelete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonDelete setTitle:@"DELETE" forState:UIControlStateNormal];
        [buttonDelete setFrame:CGRectMake(5, 5, 290, 30)];
        [buttonDelete addTarget:self action:@selector(ButtonDeleteAccountClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttonDelete];
    }
    

    return cell;
}

-(void)ButtonDeleteAccountClicked
{
    [self ConfirmDelete];
}

-(void)NavigateToRegistrationScreen
{
    self.registerUserVC = [[RegisterUserVC alloc] initWithNibName:@"RegisterUserVC" bundle:nil];
    navController = [[UINavigationController alloc]initWithRootViewController:self.registerUserVC];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

-(void)ConfirmDelete
{
    NSString *msg = @"All your account data will be deleted. You will not be able to retrieve your rewards with 'Restore'. Proceed?";
    UIAlertView *alertViewConfirm = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertViewConfirm.tag=1;
    [alertViewConfirm show];
    [alertViewConfirm release];
}

-(void)ConfirmDeleteAgain
{
    NSString *msg = @"Confirm Delete: All your data will be deleted. are you sure?";
    UIAlertView *alertViewConfirm2 = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertViewConfirm2.tag=2;
    [alertViewConfirm2 show];
    [alertViewConfirm2 release];
}

-(void)DeleteAccount
{
    isDeleting = YES;
    NSLog(@"DELETE OPERATION");
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject DeleteAccount];
}

-(void)ButtonSyncClicked
{
    if([Helper IsInternetAvailable])
    {
        [self ShowActivityView];
        BusinessLayer *businessObject = [[BusinessLayer alloc]init];
        businessObject.delegate = self;
        [businessObject SyncDB];
    }
    else
    {
        UIAlertView* alertMessage = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Internet connection is required for data Sync." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMessage show];
        [alertMessage release];
    }
}


#pragma mark - PickerView delegates

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
        return 50;
    else
        return 250;
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
            rowTitle = [[NSString alloc]initWithFormat:@"+%@",tempCountry.code];
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


#pragma mark - Action Button Functions

-(void)HideKeyboard
{
    [tempTextField resignFirstResponder];
}

-(void)TutorialClicked
{
    TutorialVC *tutorialVC = [[TutorialVC alloc]initWithNibName:@"TutorialVC" bundle:nil];
    //    [self presentModalViewController:tutorialVC animated:YES];
    [self presentViewController:tutorialVC animated:YES completion:nil];
}

-(void)DoneClicked
{
    
    [self HideKeyboard];
    
    if([self ValidateData])
    {
        
        [self ShowActivityView];
        
        NSString *phoneString = [[NSString alloc]initWithFormat:@"%@-%@",countryCode.text,phoneNumber.text];
        
        appObject.loyalaz.user.firstname=firstName.text;
        appObject.loyalaz.user.lastname=lastName.text;
        appObject.loyalaz.user.email=emailId.text;
        
        appObject.loyalaz.user.mobilephone=phoneString;
        appObject.loyalaz.user.addresscity=city.text;
        appObject.loyalaz.user.addresscountry=countryName.text;
        
        if(locationService.on)
            appObject.loyalaz.find_enable = @"1";
        else
            appObject.loyalaz.find_enable = @"0";
        
        
        if(enableFBPosts.on)
            appObject.loyalaz.enableFBPost = @"1";
        else
            appObject.loyalaz.enableFBPost = @"0";
        
        [Helper SaveObjectToDB:appObject.loyalaz];
        
        [self HideActivityView];
        [self.navigationController popViewControllerAnimated:YES];
    }    
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
    else if([phoneNumber.text isEqualToString:@""])
    {
        msg = @"Mobile number is required.";
    }
    else if([city.text isEqualToString:@""])
    {
        msg = @"City name is required.";
    }
    else if([countryName.text isEqualToString:@""])
    {
        msg = @"Country name is required.";
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
//    else if([mobilecompanyCode.text isEqualToString:@""])
//    {
//        msg=@"Service provider code is required.";
//    }
    
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
    
    if(actionSheetView.tag==1)
    {
        if(buttonIndex==1)
        {
            [self ConfirmDeleteAgain];
        }
    }
    else if(actionSheetView.tag==2)
    {
        if(buttonIndex==1)
        {
            [self DeleteAccount];
        }
    }
    else if(actionSheetView.tag==3)
    {
        [self NavigateToRegistrationScreen];
    }
}

-(void)ShowDeleteConfirmationMessage
{
    NSString *msg = @"You have successfully deleted your Profile.";
    UIAlertView *alertViewConfirm2 = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    alertViewConfirm2.tag=3;
    [alertViewConfirm2 show];
    [alertViewConfirm2 release];
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    [self HideActivityView];
    
    if(isDeleting==YES)
    {
        [self ShowDeleteConfirmationMessage];
    }
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
}



@end
