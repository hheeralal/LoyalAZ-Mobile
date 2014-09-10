//
//  ScanAZIAPHelper.m
//  ScanAZ
//

#import "ScanAZIAPHelper.h"

@implementation ScanAZIAPHelper

+ (ScanAZIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static ScanAZIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.outstandingresults.inapp.scanapp",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
