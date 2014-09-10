//
//  CouponDetailsVC.h
//  LoyalAZ
//

#import "CustomVC.h"
#import "MCoupon.h"
#import "BusinessLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "CouponsVC.h"
#import "RequestQueue.h"

@interface CouponDetailsVC : CustomVC <BusinessLayerDelegate,CouponQRCodeDelegate>
{
    MCoupon *mcoupon;
    BOOL flag;
    
    UIImageView *frontImage;
    UIImageView *backImage;
    
    UIView *containerView;
    BOOL flagMyCoupon;
    Coupon *cpn;
    
}

- (id)initWithNibNameAndCoupon:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCoupon:(MCoupon *)selectedCoupon;
- (id)initWithNibNameAndMyCoupon:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCoupon:(Coupon *)selectedCoupon;

@property (nonatomic,retain) IBOutlet UIImageView *frontImage;
@property (nonatomic,retain) IBOutlet UIImageView *backImage;

-(void) BackClicked;

- (void) LoadProgramImage;

//- (IBAction)ImageViewTapped:(id)sender;

@end

