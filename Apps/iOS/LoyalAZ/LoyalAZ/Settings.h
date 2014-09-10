//
//  Settings.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject <NSCoding>
{
    BOOL enableLocations;
    BOOL flagTutorial;
}

@property (nonatomic) BOOL enableLocations;
@property (nonatomic) BOOL flagTutorial;

@end
