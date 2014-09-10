//
//  ProgramDetailsVC.m
//  LoyalAZ

#import "ProgramDetailsVC.h"

@interface ProgramDetailsVC ()

@end

@implementation ProgramDetailsVC
@synthesize frontImage,backImage;

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
    program = selectedProgram;
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

    
    self.title = @"Program Details";
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(InfoClicked)];

    self.navigationItem.rightBarButtonItem=infoButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked)];
    self.navigationItem.leftBarButtonItem=backButton;
    

    // Do any additional setup after loading the view from its nib.

    if([program.d isEqualToString:@"0"] || [program.d isEqualToString:@""]) //Images are downloaded
    {
        frontImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[Helper GetStoragePath:program.pic_front]]];
        backImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[Helper GetStoragePath:program.pic_back]]];
        
//        frontImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:program.pic_front]];
//        backImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:program.pic_back]];
    }
    else if([program.d isEqualToString:@"1"]) //Images are not yet downloaded.
    {
        frontImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_logo"]];
        backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_logo"]];
    }
    
    
    //containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44)];
    [self.view addSubview:containerView];
    
    
    backImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
    frontImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
    
    [containerView release];
    
    [self LoadProgramImage];
}


- (void) LoadProgramImage
{

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
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Program Details";
}



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
        //add your code for image touch here 
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) InfoClicked
{
    CompanyDetailsVC *companyDetailsVC = [[CompanyDetailsVC alloc]initWithNibNameAndProgram:@"CompanyDetailsVC" bundle:nil withProgram:program];
    [self.navigationController pushViewController:companyDetailsVC animated:YES];
    [companyDetailsVC release];
    //NSLog(@"Company info clicked.");
}

-(void) BackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
