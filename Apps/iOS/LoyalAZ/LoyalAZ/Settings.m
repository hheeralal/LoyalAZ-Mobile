//
//  Settings.m
//  LoyalAZ
//

#import "Settings.h"

@implementation Settings
@synthesize enableLocations,flagTutorial;

#define EnableLocations @"EnableLocations"
#define FlagTutorial @"FlagTutorial"

- (id)initWithCoder:(NSCoder *)decoder 
{
    self = [super init];
    if(self) {
        self.enableLocations = [decoder decodeBoolForKey:EnableLocations];
        self.flagTutorial = [decoder decodeBoolForKey:FlagTutorial];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeBool:self.enableLocations forKey:EnableLocations];
    [encoder encodeBool:self.flagTutorial forKey:FlagTutorial];
}


@end
