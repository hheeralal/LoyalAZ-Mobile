//
//  ReferBusiness.m
//  LoyalAZ
//

#import "ReferBusiness.h"

@interface ReferBusiness ()


@end


@implementation ReferBusiness
@synthesize rec_cname;
@synthesize rec_phone;
@synthesize rec_email;
@synthesize rec_mgrfname;
@synthesize rec_mgrlname;
@synthesize rec_whyinvited;
@synthesize rec_address;
@synthesize com_id;
@synthesize lat;
@synthesize lng;

- (id)init
{
    self = [super init];
    if (self) {
        
        rec_cname = @"";
        rec_phone = @"";
        rec_email = @"";
        rec_mgrfname = @"";
        rec_mgrlname = @"";
        rec_whyinvited = @"";
        rec_address = @"";
        com_id = @"";
        lat = @"";
        lng = @"";
    }
    return self;
}

@end
