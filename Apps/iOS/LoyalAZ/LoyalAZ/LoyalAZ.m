//
//  LoyalAZ.m
//  TestXML
//

#import "LoyalAZ.h"

@implementation LoyalAZ
@synthesize programs,user;
@synthesize sync;
@synthesize find_enable;
@synthesize enableFBPost;
@synthesize coupons;
@synthesize ads_enable;
//@synthesize methods;

- (id)init
{
    self = [super init];
    if (self) {
        
        programs = [[NSMutableArray alloc]init];
        coupons = [[NSMutableArray alloc]init];
        //methods = [[NSMutableArray alloc]init];
    }
    else {
        user = [[User alloc]init];
    }
    return self;
}


@end
