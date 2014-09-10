//
//  WaitingVC.m
//  LoyalAZ
//

#import "WaitingVC.h"

@interface WaitingVC ()

@end

@implementation WaitingVC

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
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    BusinessLayer *businessObject = [[BusinessLayer alloc]init];
    businessObject.delegate = self;
    [businessObject SyncDB];
    [self ShowActivityView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BusinessLayerDidFinish:(BOOL)result
{
    [self HideActivityView];
    HomeVC* homeVC = [[[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil] autorelease];
    [self.navigationController pushViewController:homeVC animated:NO];
    //[self MoveToHomeScreen];
}

-(void)BusinessLayerErrorOccurred:(NSError *)err
{
    [self HideActivityView];
}

@end
