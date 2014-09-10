//
//  SetupVC.h
//  LoyalAZ
//

#import "CustomVC.h"
#import "Application.h"
#import "Countries.h"
#import "Country.h"
#import "DataRecoveryVC.h"
#import "RegisterUserVC.h"

@class RegisterUserVC;


@interface SetupVC : CustomVC <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,BusinessLayerDelegate,UIAlertViewDelegate>
{
    
    
    UITableView *tableSetup;
    Application *appObject;
    
    UITextField *firstName;
    UITextField *lastName;
    UITextField *emailId;
    UITextField *phoneNumber;
    UITextField *city;
    UITextField *countryName;
    UITextField *countryCode;
//    UITextField *mobilecompanyCode;
    UILabel *location;
    UILabel *enableFB;
    UILabel *dataSync;
    UILabel *deleteAccount;
    UISwitch *locationService;
    UISwitch *enableFBPosts;
    
    NSArray *arrayFields;   
    
    CGFloat animatedDistance;
    UITextField *memTextField;
    UITextField *tempTextField;
    
    UIActionSheet *actionSheet;
    UIPickerView *pickerViewCountry;
    
    UIView *customView;
    
    //NSArray *arrayCountries;
    
    Countries *countriesObject;
    BOOL isDeleting;;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) RegisterUserVC *registerUserVC;
@property (strong,nonatomic) UINavigationController *navController;
@property (nonatomic,retain) IBOutlet UITableView *tableSetup;


-(void)DoneClicked;
-(void)ButtonSyncClicked;

@end
