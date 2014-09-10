//
//  LoyalAZ.m
//  TestXML
//

#import "ScanApp.h"

@implementation ScanApp
@synthesize companyid,companyname;

- (id)init
{
    self = [super init];
    if (self) {
        companyname = @"";
        companyid = @"";
    }
    else {
        //user = [[User alloc]init];
    }
    return self;
}


@end
