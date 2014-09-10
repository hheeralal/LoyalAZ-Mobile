//
//  Application.m
//  LoyalAZ
//

#import "Application.h"

@implementation Application
@synthesize loyalaz;
@synthesize morePrograms;
@synthesize moreCoupons;
@synthesize SOAPURL;
@synthesize BaseURLSet;
@synthesize cachedResults;
@synthesize cachedCoupons;
@synthesize adsURL;
@synthesize advertObject;

static Application *applicationManager = nil;


#pragma mark Singleton Methods

+ (id)applicationManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (applicationManager == nil) {
            applicationManager = [[self alloc] init];
        }
    });
    return applicationManager;
}

- (id)init {
    if (self = [super init]) {
        //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
        loyalaz = [[LoyalAZ alloc]init];
        morePrograms = [[MorePrograms alloc]init];
        moreCoupons = [[MoreCoupons alloc]init];
        SOAPURL = [[NSString alloc]init];
        SOAPURL = @"http://www.loyalaz.com/setup/";
        adsURL = [[NSString alloc]init];
        adsURL = @"";
        BaseURLSet = NO;
        cachedResults = NO;
        cachedCoupons = NO;
        advertObject = [[Advertisement alloc]init];
    }
    return self;
}

@end
