//
//  MorePrograms.m
//  LoyalAZ
//

#import "MorePrograms.h"

@implementation MorePrograms
@synthesize MPrograms;

- (id)init
{
    self = [super init];
    if (self) {
        
        MPrograms = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
