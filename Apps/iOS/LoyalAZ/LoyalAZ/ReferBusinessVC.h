//
//  ReferBusinessVC.h
//  LoyalAZ
//

#import "CustomVC.h"
#import "Application.h"
#import "ReferBusiness.h"
#import "BusinessLayer.h"

@interface ReferBusinessVC : CustomVC <UITextFieldDelegate,BusinessLayerDelegate>

{
    UITextField *textcompanyname;
    UITextField *textcompanyphone;
    UITextField *textcompanyemail;
    UITextField *textcompanymgrfirsttname;
    UITextField *textcompanymgrlastname;
    UITextField *textreason;
    UITextField *textcompanyaddress;

    CGFloat animatedDistance;
    UITextField *memTextField;
    UITextField *tempTextField;
    
    NSArray *arrayFields;
    
    ReferBusiness *refBusiness;
    BOOL use_gps;
    
    NSString *lat,*lng,*com_id;
}

- (id)initWithNibNameExtras:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withExtras:(NSArray*)extras;

@end

