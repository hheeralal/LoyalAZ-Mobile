//
//  HomeVC.h
//  ScanApp
//

#import "CustomVC.h"
#import "ScanQR.h"
#import "BusinessLayer.h"

@interface HomeVC : CustomVC <ScanQRDelegate,BusinessLayerDelegate>

{
    Coupon *cpn;
    BOOL flagValidate;
}
-(IBAction)ScanCoupon:(id)sender;
-(IBAction)Logout:(id)sender;
@property (nonatomic,retain) IBOutlet UILabel *labelCompany;
@end
