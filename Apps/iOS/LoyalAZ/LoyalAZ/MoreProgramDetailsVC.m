//
//  MoreProgramDetailsVC.m
//  LoyalAZ
//

#import "MoreProgramDetailsVC.h"

@interface MoreProgramDetailsVC ()

@end

@implementation MoreProgramDetailsVC
@synthesize frontImage,backImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibNameAndProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(MProgram *)selectedProgram
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    selProgram = selectedProgram;
    //NSLog(@"NAME=%@",selProgram.name);
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

    
    self.title = @"Add Program";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddClicked)];
//    UIBarButtonItem *referButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(buttonAddClicked:)] autorelease];
    //self.navigationItem.rightBarButtonItem=addButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    NSArray *rightBarButtons = [[NSArray alloc]initWithObjects:addButton, nil];
    self.navigationItem.rightBarButtonItems = rightBarButtons;

    [self ShowActivityView];
    // Do any additional setup after loading the view from its nib.
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44)];
    
    

    NSURL *imageURL = [NSURL URLWithString:selProgram.pic_front];
    NSURLCacheStoragePolicy policy = NSURLCacheStorageNotAllowed;
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL cachePolicy:policy timeoutInterval:15.0];
    [[RequestQueue mainQueue] addRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error)
        {
            //image downloaded
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                frontImage = [[UIImageView alloc] initWithImage:image];
                frontImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
                [self LoadProgramImage];
                [self HideActivityView];
            }
        }
    }];
    
    
    [self.view addSubview:containerView];
    
    NSURL *imageURLBack = [NSURL URLWithString:selProgram.pic_back];
    //NSURLCacheStoragePolicy policy = NSURLCacheStorageNotAllowed;
    NSURLRequest *requestBack = [NSURLRequest requestWithURL:imageURLBack cachePolicy:policy timeoutInterval:15.0];
    [[RequestQueue mainQueue] addRequest:requestBack completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error)
        {
            //image downloaded
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                backImage = [[UIImageView alloc] initWithImage:image];
                backImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
            }
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"More Program Details";
}


- (void) buttonAddClicked:(id)sender
{
    //NSLog(@"Camera clicked.");
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:@"Recommend Current Location to join LoyalAZ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [av show];
    
}

//- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //NSLog(@"Index clicked:%@",buttonIndex);
//    NSString *gps = @"";
//    if(buttonIndex==0)
//        gps = @"0";
//    else
//        gps = @"1";
//    
//    NSArray *extras = [[NSArray alloc]initWithObjects:selProgram.com_id,selProgram.lat,selProgram.lng,gps, nil];
//    ReferBusinessVC *referBusinessVC = [[ReferBusinessVC alloc]initWithNibNameExtras:@"ReferBusinessVC" bundle:nil withExtras:extras];
//    [self.navigationController pushViewController:referBusinessVC animated:YES];
//    [referBusinessVC release];
//
//}


- (void) LoadProgramImage
{
    
    //backImage = [[UIImageView alloc] initWithImage:[UIImage 
    //                                                    imageNamed:@"cardback.png"]];
    if(flag==YES)
    {
        
        //backImage.center = frontImage.center;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                               forView:containerView 
                                 cache:YES];
        [frontImage removeFromSuperview];
        [containerView addSubview:backImage];
        [UIView commitAnimations];
        
        UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(InfoClicked)];
        self.navigationItem.rightBarButtonItem=infoButton;
        
        
    }
    else 
    {
        
        //frontImage.center = backImage.center;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                               forView:containerView 
                                 cache:YES];
        [backImage removeFromSuperview];
        [containerView addSubview:frontImage];
        [UIView commitAnimations];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddClicked)];
        self.navigationItem.rightBarButtonItem=addButton;
        
    }
    
    
//    NSString *strURL;
//    if(flag==NO)
//        strURL = selProgram.pic_front;
//    else 
//        strURL = selProgram.pic_back;
//    
//    NSURL *imageURL = [NSURL URLWithString:strURL];
//    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageURL];
//    programImage.image = [UIImage imageWithData:imageData];
//    [imageData release];
    
}

//- (IBAction)ImageViewTapped:(id)sender
//{
//    flag =! flag;
//    [self LoadProgramImage];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == containerView)
    {
        flag =! flag;
        [self LoadProgramImage];
        //NSLog(@"Image view clicked.");
        //add your code for image touch here 
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) AddClicked
{
    Program *program = [[Program alloc]init];
    program.id = selProgram.id;
    program.pid = selProgram.pid;
    program.pic_logo = selProgram.pic_logo;
    program.pic_back = selProgram.pic_back;
    program.pic_front = selProgram.pic_front;
    program.pt_target = selProgram.pt_target;
    program.name = selProgram.name;
    program.act = selProgram.act;
    program.tagline =  selProgram.tagline ;
    program.type   =    selProgram.type   ;
    program.com_id    = selProgram.com_id      ;  
    program.com_name  = selProgram.com_name     ; 
    program.com_web1  = selProgram.com_web1      ;
    program.com_web2  = selProgram.com_web2      ;
    program.com_phone = selProgram.com_phone     ;
    program.com_email = selProgram.com_email;
//    program.lat = selProgram.lat;
//    program.lng = selProgram.lng;
    program.c=@"";
    program.s_dt=@"";
    program.rt = selProgram.rt;
    
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    
    if([businessObject IsProgramExists:program.pid])
    {
        UIAlertView *avExists = [[UIAlertView alloc]initWithTitle:@"Validation" message:@"You are already subscribed to this program." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [avExists show];
        [avExists release];
        return;
    }
    
//    if([selProgram.type isEqualToString:@"3"])
//    {
//        
//        savingProgram = program;
//        NSString *message = [[NSString alloc]initWithFormat:@"To recharge or load your SAVINGS card – please show your handset to staff member for validation"];
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        av.tag = 5;
//        [av show];
//        [av release];
//        [message release];
//        
//
//    }
//    else
//    {
        NSString *newbalance = [businessObject AddProgramFromFind:program]; //get the new balance as string
        
        NSString *message = [[NSString alloc]initWithFormat:@"Congratulations! You now have %@ rewards. Your reward target is %@",newbalance,program.pt_target];
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [av release];
        
        ProgramsVC *programsVC = [[ProgramsVC alloc]initWithNibName:@"ProgramsVC" bundle:nil];
        [self.navigationController pushViewController:programsVC animated:YES];


//    }
    //NSString *newbalance = [businessObject UpdateProgramBalance:program]; //get the new balance as string
    
    
    //CompanyDetailsVC *companyDetailsVC = [[CompanyDetailsVC alloc]initWithNibNameAndProgram:@"CompanyDetailsVC" bundle:nil :program];
    //[self.navigationController pushViewController:companyDetailsVC animated:YES];
    //NSLog(@"Company info clicked.");
}


-(void) InfoClicked
{
    CompanyDetailsVC *companyDetailsVC = [[CompanyDetailsVC alloc]initWithNibNameAndMProgram:@"CompanyDetailsVC" bundle:nil withProgram:selProgram];
    [self.navigationController pushViewController:companyDetailsVC animated:YES];
    //NSLog(@"Company info clicked.");
}

-(void) BackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - AlertView Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==5)
    {
        if(buttonIndex==0)
        {
            PasscodeVC *passcodeVC = [[PasscodeVC alloc]initWithNibName:@"PasscodeVC" bundle:nil withProgram:savingProgram];
            passcodeVC.delegate = self;
            [self presentViewController:passcodeVC animated:YES completion:nil];
        }
    }
}

-(void)PasscodeVerified:(Program *)prg
{
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    int target_points = 0;
    int balance_points = 0;
    target_points = [savingProgram.pt_target intValue];
    balance_points = [savingProgram.pt_balance intValue];

    NSString *newbalance = [businessObject UpdateSavingTypeProgramBalance:savingProgram]; //get the new balance as string
    
    ProgramsVC *programsVC = [[ProgramsVC alloc]initWithNibName:@"ProgramsVC" bundle:nil];
    [self.navigationController pushViewController:programsVC animated:YES];

}

-(void)PasscodeDidCancelled
{
    NSMutableString *message = [[NSMutableString alloc]initWithFormat:@"Confirmation cancelled."];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [av show];
    [av release];
    [message release];
    
}


@end
