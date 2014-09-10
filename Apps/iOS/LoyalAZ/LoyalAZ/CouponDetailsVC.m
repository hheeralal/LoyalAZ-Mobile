//
//  CouponDetailsVC.m
//  LoyalAZ
//

#import "CouponDetailsVC.h"

@interface CouponDetailsVC ()

@end

@implementation CouponDetailsVC
@synthesize frontImage,backImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibNameAndCoupon:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCoupon:(MCoupon *)selectedCoupon
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    flagMyCoupon = NO;
    mcoupon = selectedCoupon;
    return self;
}

- (id)initWithNibNameAndMyCoupon:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCoupon:(Coupon *)selectedCoupon
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    cpn = selectedCoupon;
    flagMyCoupon = YES;
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.trackedViewName = @"Coupon Details";
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

    
    self.title = @"Coupon Details";
    self.navigationController.navigationBarHidden=NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    if(flagMyCoupon==NO)
    {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddClicked)];
        self.navigationItem.rightBarButtonItem=addButton;
    }
    //self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    
//    frontImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:mcoupon.pic_front]];
//    backImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:mcoupon.pic_back]];
    
    [self ShowActivityView];
    
    if(flagMyCoupon==NO)
    {
        NSURL *imageURL = [NSURL URLWithString:mcoupon.pic_front];
//        NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageURL];
        
        NSURL *imageURLBack = [NSURL URLWithString:mcoupon.pic_back];
//        NSData *imageDataBack = [[NSData alloc]initWithContentsOfURL:imageURLBack];
        
        //NSLog(@"front=%@",imageURL);
        //NSLog(@"back=%@",imageURLBack);
        
        NSURLCacheStoragePolicy policy = NSURLCacheStorageNotAllowed;
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL cachePolicy:policy timeoutInterval:15.0];
        [[RequestQueue mainQueue] addRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (!error)
            {
                //image downloaded
                UIImage *image = [UIImage imageWithData:data];
                if (image)
                {
                    flag=NO;
                    frontImage = [[UIImageView alloc] initWithImage:image];
                    frontImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
                    [self LoadProgramImage];
                    [self HideActivityView];
                }
            }
        }];
        
        
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
        
        //containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44)];
        
//        frontImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        //containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        
//        backImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageDataBack]];
        
    }
    else
    {
        NSData *imageData = [[NSData alloc]initWithContentsOfFile:[Helper GetStoragePath:cpn.pic_qrcode]];
        NSData *imageDataBack = [[NSData alloc]initWithContentsOfFile:[Helper GetStoragePath:cpn.pic_back]];
        
        //containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        
        frontImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        //containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44)];
        
        backImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageDataBack]];
        
        [self LoadProgramImage];
    }
    
    [self.view addSubview:containerView];
    
    
//    backImage.frame = CGRectMake(0, 0, 320, 460);
//    frontImage.frame = CGRectMake(0, 0, 320, 460);
    
    backImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
    frontImage.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
    
    //backImage
    
    [containerView release];
    

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

-(void) BackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) AddClicked
{
    
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    cpn = [[Coupon alloc]init];
    
    cpn.name = mcoupon.name;
    cpn.description = mcoupon.description;
    cpn.pic_logo = mcoupon.pic_logo;
    cpn.pic_front = mcoupon.pic_front;
    cpn.pic_back = mcoupon.pic_back;
    cpn.com_id = mcoupon.com_id;
    cpn.com_name = mcoupon.com_name;
    cpn.com_web1 = mcoupon.com_web1;
    cpn.com_web2 = mcoupon.com_web2;
    cpn.com_phone = mcoupon.com_phone;
    cpn.com_street = mcoupon.com_street;
    cpn.com_suburb = mcoupon.com_suburb;
    cpn.com_city = mcoupon.com_city;
    cpn.lat = mcoupon.lat;
    cpn.lng = mcoupon.lng;
    cpn.distance = mcoupon.distance;
    cpn.guid = mcoupon.guid;
    cpn.c=@"";

    cpn.id = mcoupon.id;
    [self ShowActivityView];
    if([businessObject IsCouponExists:cpn.id]==YES)
    {
        [self HideActivityView];
        NSString *msg = @"This coupon is already added in your coupons list.";
        UIAlertView *avMsg = [[UIAlertView alloc]initWithTitle:@"LoyalAZ" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [avMsg show];
        [avMsg release];
    }
    else
    {
        businessObject.couponQRCodedelegate = self;
        [businessObject AddCouponFromFind:cpn];

        CouponsVC *couponsVC = [[CouponsVC alloc]initWithNibName:@"CouponsVC" bundle:nil];
        [self.navigationController pushViewController:couponsVC animated:YES];
        [couponsVC release];
    }
}

-(void)CouponQRCodeDelegateFinishedWithQRCode:(NSString *)qrCodeURL
{
    [self HideActivityView];
    cpn.pic_qrcode = qrCodeURL;
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    [businessObject UpdateCouponQRCodeImage:cpn];
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    
    [self HideActivityView];
    if(result==YES)
    {
    }
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
}

@end
