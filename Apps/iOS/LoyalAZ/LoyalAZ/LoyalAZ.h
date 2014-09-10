//
//  LoyalAZ.h
//  TestXML
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Program.h"
#import "Coupon.h"

@interface LoyalAZ : NSObject

{
    User *user;
    NSString *sync;
    NSString *find_enable;
    NSString *enableFBPost;
    NSMutableArray *programs;
    NSMutableArray *coupons;
    NSString *ads_enable;
//    NSMutableArray *methods;
}

@property (nonatomic,retain) NSString *ads_enable;
@property (nonatomic,retain) NSString *find_enable;
@property (nonatomic,retain) NSString *sync;
@property (nonatomic,retain) NSString *enableFBPost;
@property (nonatomic,retain) User *user;
@property (atomic,retain) NSMutableArray *programs;
@property (nonatomic,retain) NSMutableArray *coupons;
//@property (nonatomic,retain) NSMutableArray *methods;

@end
