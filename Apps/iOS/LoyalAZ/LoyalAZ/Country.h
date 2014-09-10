//
//  Country.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>

@interface Country : NSObject
{
    NSString *name;
    NSString *code;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *code;
@end
