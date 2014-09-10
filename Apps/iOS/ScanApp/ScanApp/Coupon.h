//
//  Coupon.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject
{
    NSString *uid;
    NSString *id;
    NSString *guid;
    NSString *type;
}
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *guid;
@property (nonatomic,retain) NSString *type;

@end