//
//  CompanyDetailsVC.m
//  LoyalAZ
//

#import "CompanyDetailsVC.h"

@interface CompanyDetailsVC ()

@end

@implementation CompanyDetailsVC
@synthesize flagMProgram;
@synthesize selProgram,selMProgram;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibNameAndProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(Program *)selectedProgram
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.flagMProgram = NO;
    self.selProgram = selectedProgram;
    //NSLog(@"Company name=%@",selectedProgram.com_name);
    return self;
}

- (id)initWithNibNameAndMProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(MProgram *)selectedProgram
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.flagMProgram = YES;
    self.selMProgram = selectedProgram;
    //NSLog(@"Company name=%@",selectedProgram.com_name);
    return self;
}

- (void) buttonAddClicked:(id)sender
{
    //NSLog(@"Camera clicked.");
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Recommend Current Location to join LoyalAZ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    av.tag=1;
    [av show];
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
    if(flagMProgram==YES)
    {
//        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
//                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                   target:self action:@selector(buttonAddClicked:)] autorelease];

    }

}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Company Details";
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Index clicked:%@",buttonIndex);
    if(actionSheet.tag==1)
    {
        NSString *gps = @"";
        if(buttonIndex==0)
            gps = @"0";
        else
            gps = @"1";
        
        NSArray *extras = [[NSArray alloc]initWithObjects:selMProgram.com_id,selMProgram.lat,selMProgram.lng,gps, nil];
        ReferBusinessVC *referBusinessVC = [[ReferBusinessVC alloc]initWithNibNameExtras:@"ReferBusinessVC" bundle:nil withExtras:extras];
        [self.navigationController pushViewController:referBusinessVC animated:YES];
        [referBusinessVC release];
    }
    else if(actionSheet.tag==2)
    {
        if(buttonIndex==1)
        {
            NSString *strPhone = [[NSString alloc]initWithFormat:@"tel:+%@",strPhoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
        }
    }
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(flagMProgram==NO)
    {
        
//        NSString *strFBURL = [[NSString alloc]initWithFormat:@"http://%@",selProgram.com_web1];
        NSString *strWebURL = [[NSString alloc]initWithFormat:@"http://%@",selProgram.com_web2];
        //NSString *strPhone = [[NSString alloc]initWithFormat:@"tel:+%@",selProgram.com_phone];
        NSString *strEmail = [[NSString alloc]initWithFormat:@"mailto:%@",selProgram.com_email];
        strPhoneNumber =selProgram.com_phone;
        switch (indexPath.row)
        {
            case 0:
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strFBURL]];
                [self OpenFacebookPage:selProgram.com_web1];
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strWebURL]];
                break;
            case 2:
                [self ConfirmPhoneCall];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
                break;
            case 3:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strEmail]];
                break;
        }
    }
    else
    {
//        NSString *strFBURL = [[NSString alloc]initWithFormat:@"http://%@",selMProgram.com_web1];
        NSString *strWebURL = [[NSString alloc]initWithFormat:@"http://%@",selMProgram.com_web2];
        //NSString *strPhone = [[NSString alloc]initWithFormat:@"tel:+%@",selMProgram.com_phone];
        NSString *strEmail = [[NSString alloc]initWithFormat:@"mailto:%@",selMProgram.com_email];
        strPhoneNumber =selMProgram.com_phone;
        switch (indexPath.row)
        {
            case 0:
                [self OpenFacebookPage:selMProgram.com_web1];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: strFBURL]];
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strWebURL]];
                break;
            case 2:
                [self ConfirmPhoneCall];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
                break;
            case 3:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strEmail]];
                break;
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)OpenFacebookPage:(NSString *)pageName
{
    NSString *page_id = @"";
    NSString *targetURL = @"fb://";
    BOOL fbInstalled =  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:targetURL]];
    
    if(fbInstalled==YES)
    {
        
        FBCommunication *fbCon = [[FBCommunication alloc]init];
        page_id = [fbCon SendGraphRequest:pageName];
        targetURL = [NSString stringWithFormat:@"fb://profile/%@",page_id];
        NSLog(@"FB_PAGE = %@",targetURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetURL]];
    }
    else
    {
        targetURL = [NSString stringWithFormat:@"http://www.facebook.com/%@",pageName];
        NSLog(@"FB_WEB_PAGE = %@",targetURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetURL]];
    }
}

-(void)ConfirmPhoneCall
{
    NSString *msg = [NSString stringWithFormat:@"Do you want to call %@?",strPhoneNumber];
    UIAlertView *alertViewConfirm = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertViewConfirm.tag = 2;
    [alertViewConfirm show];
    [alertViewConfirm release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(flagMProgram==NO)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = selProgram.com_web1;
                cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
                break;
            case 1:
                cell.textLabel.text = selProgram.com_web2;
                cell.imageView.image = [UIImage imageNamed:@"home.png"];
                break;
            case 2:
                cell.textLabel.text = selProgram.com_phone;
                cell.imageView.image = [UIImage imageNamed:@"phone.png"];
                break;
            case 3:
                cell.textLabel.text = selProgram.com_email; //No field for email.
                cell.imageView.image = [UIImage imageNamed:@"email.png"];
                break;            
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = selMProgram.com_web1;
                cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
                break;
            case 1:
                cell.textLabel.text = selMProgram.com_web2;
                cell.imageView.image = [UIImage imageNamed:@"home.png"];
                break;
            case 2:
                cell.textLabel.text = selMProgram.com_phone;
                cell.imageView.image = [UIImage imageNamed:@"phone.png"];
                break;
            case 3:
                cell.textLabel.text = selMProgram.com_email; //No field for email.
                cell.imageView.image = [UIImage imageNamed:@"email.png"];
                break;            
            default:
                break;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


@end
