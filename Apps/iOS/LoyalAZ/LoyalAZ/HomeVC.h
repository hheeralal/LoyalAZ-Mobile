//
//  HomeVC.h
//  LoyalAZ

#import <UIKit/UIKit.h>
#import "RegisterUserVC.h"
//#import "ScanQRCodeVC.h"
#import "ScanQR.h"
#import "ProgramsVC.h"
#import "FindProgramsVC.h"
#import "FindCouponsVC.h"
#import "SetupVC.h"
#import "CouponsVC.h"
#import "TutorialVC.h"
#import <QuartzCore/QuartzCore.h>


@class SetupVC;

@interface HomeVC : UIViewController <BusinessLayerDelegate,UIGestureRecognizerDelegate>
{
//    UIButton *buttonMyPrograms;
//    UIButton *buttonScan;
//    UIButton *buttonFindPrograms;
//    UIButton *buttonSetup;
    
    BOOL getCouponCode;
    NSString *tempCompanyName;
    Program *couponProgram;

}

@property (nonatomic,strong) IBOutlet UIWebView *webViewAds;


@property (nonatomic,retain) IBOutlet UIButton *buttonSetup;
@property (nonatomic,retain) IBOutlet UIButton *buttonScan;

@property (nonatomic,retain) IBOutlet UIButton *buttonFindPrograms;
@property (nonatomic,retain) IBOutlet UIButton *buttonFindCoupons;

@property (nonatomic,retain) IBOutlet UIButton *buttonMyCoupons;
@property (nonatomic,retain) IBOutlet UIButton *buttonMyPrograms;

-(IBAction)ScanQRCode:(id)sender;
-(IBAction)ShowMyPrograms:(id)sender;
//-(IBAction)Find:(id)sender;
-(IBAction)ShowFindPrograms:(id)sender;
-(IBAction)ShowSetup:(id)sender;
-(IBAction)ShowFindCoupons:(id)sender;
-(IBAction)ShowMyCoupons:(id)sender;

-(void)StartScan;

@end
