//
//  RegisterUserVC.h
//  LoyalAZ

#import <UIKit/UIKit.h>
#import "CustomVC.h"
//#import "Application.h"
#import "LoyalAZ.h"
#import "BusinessLayer.h"
#import "RegisterUserStep2VC.h"
#import "DataRecoveryVC.h"
#import "CMPopTipView.h"

//@interface RegisterUserVC : UIViewController <UITextFieldDelegate,BusinessLayerDelegate>
@interface RegisterUserVC : CustomVC <UITextFieldDelegate,BusinessLayerDelegate,UIAlertViewDelegate,DataRecoveryVCDelegate,CMPopTipViewDelegate>
{
    UITableView *tblRegister;
    UITextField *firstName;
    UITextField *lastName;
    UITextField *emailId;
    
    NSArray *arrayFields;
    NSArray *arrayTipMessages;
    
    CGFloat animatedDistance;
    UITextField *memTextField;
    UITextField *tempTextField;
    
    UIActionSheet *actionSheet;
    UIDatePicker *pickerView;
    
    UIView *customView;
    Application *appObject;
    
    UILabel *labelAgree;
    UILabel *labelTip;
    
    BOOL agreeed;
    UIButton *unchecked;
    
    UIView *viewEULA;
    IBOutlet UIWebView *webEULA;
    BOOL validatingEmail;
    BOOL sendingEmail;
    
//    UIView *loadingView;
//    UIActivityIndicatorView *activityView;

}


//@property (nonatomic,strong) IBOutlet UIView *loadingView;
//@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic, retain)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, retain)	id				currentPopTipViewTarget;

- (BOOL) ValidateData;

@property (nonatomic,strong) IBOutlet UIView *viewEULA;

@property (nonatomic,strong) IBOutlet UITableView *tblRegister;
//@property (nonatomic,strong) UITextField *firstName;

-(void)NextClicked;

- (void) CheckUncheck;

- (IBAction)DismissEULA;

@end
