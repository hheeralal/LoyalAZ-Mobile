//
//  Application.m
//  LoyalAZ
//

#import "Application.h"

@implementation Application
@synthesize scanapp;
@synthesize SOAPURL;
@synthesize BaseURLSet;

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
        scanapp = [[ScanApp alloc]init];
        SOAPURL = [[NSString alloc]init];
        SOAPURL = @"http://www.loyalaz.com/setup/";
        BaseURLSet = NO;
    }
    return self;
}

@end
