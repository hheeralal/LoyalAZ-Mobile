//
//  Application.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "LoyalAZ.h"
#import "Helper.h"
#import "MorePrograms.h"
#import "MoreCoupons.h"
#import "Settings.h"
#import "Advertisement.h"

@interface Application : NSObject
{
    LoyalAZ* loyalaz;
    MorePrograms *morePrograms;
    MoreCoupons *moreCoupons;
}

@property (atomic,retain) LoyalAZ *loyalaz;
@property (nonatomic,retain) MorePrograms *morePrograms;
@property (nonatomic,retain) MoreCoupons *moreCoupons;
//@property (nonatomic,retain) Settings *settings;
@property (nonatomic,retain) NSString *SOAPURL;
@property (nonatomic,retain) NSString *adsURL;
@property (readwrite,assign) BOOL BaseURLSet;
@property (readwrite,assign) BOOL firstTimeRun;
@property (readwrite,assign) BOOL cachedResults;
@property (readwrite,assign) BOOL cachedCoupons;
@property (nonatomic,strong) Advertisement *advertObject;
@property (nonatomic,strong) NSString *deviceToken;
@property (nonatomic,assign) BOOL fromNotification;
@property (nonatomic,assign) NSString *prgId;
@property (nonatomic,assign) NSString *cpnId;
@property (nonatomic,assign) BOOL isCoupon;

+ (id)applicationManager;

@end
