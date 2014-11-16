//
//  RegisterUserStep2VC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import "CustomVC.h"
//#import "Application.h"
#import "LoyalAZ.h"
#import "BusinessLayer.h"
//#import "HomeVC.h"
#import "EnableLocationsVC.h"
#import "Countries.h"
#import "Country.h"
#import "CMPopTipView.h"
#import "SelectCountryVC.h"


@interface RegisterUserStep2VC : CustomVC <SelectCountryDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,BusinessLayerDelegate,CMPopTipViewDelegate>
{
    UITableView *tblRegister;
    UITextField *phoneNumber;
    UITextField *countryName;
    UITextField *countryCode;
//    UITextField *mobilecompanyCode;
    UITextField *city;
    
    NSArray *arrayFields;
    NSArray *arrayTipMessages;    
    
    CGFloat animatedDistance;
    UITextField *memTextField;
    UITextField *tempTextField;
    
    UIActionSheet *actionSheet;
    UIPickerView *pickerViewCountry;
    
    UIView *customView;
    
    //NSArray *arrayCountries;
    
    Countries *countriesObject;
    
}
@property (nonatomic, retain)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, retain)	id				currentPopTipViewTarget;


@property (nonatomic,retain) IBOutlet UITableView *tblRegister;

@end
