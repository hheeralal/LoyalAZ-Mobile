//
//  Countries.m
//  LoyalAZ
//

#import "Countries.h"

@implementation Countries

@synthesize countries;


- (id)init
{
    self = [super init];
    if (self) {
        
        countries = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
