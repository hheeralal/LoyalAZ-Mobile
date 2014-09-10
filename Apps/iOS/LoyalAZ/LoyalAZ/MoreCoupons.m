//
//  MoreCoupons.m
//  LoyalAZ
//

#import "MoreCoupons.h"

@implementation MoreCoupons

@synthesize MCoupons;

- (id)init
{
    self = [super init];
    if (self) {
        
        MCoupons = [[NSMutableArray alloc]init];
    }
    return self;
}
@end

