//
//  Coupon.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject
{
    NSString *id;
    NSString *guid;
    NSString *name;
    NSString *typeid;
    NSString *typename;
    NSString *xdate;
    NSString *description;
    NSString *pic_logo;
    NSString *pic_front;
    NSString *pic_back;
    NSString *com_id;
    NSString *com_name;
    NSString *com_web1;
    NSString *com_web2;
    NSString *com_phone;
    NSString *com_street;
    NSString *com_suburb;
    NSString *com_city;
    NSString *lat;
    NSString *lng;
    NSString *distance;
    NSString *pic_qrcode;
    NSString *used;
    NSString *c;
}

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *guid;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *typeid;
@property (nonatomic,retain) NSString *typename;
@property (nonatomic,retain) NSString *xdate;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *pic_logo;
@property (nonatomic,retain) NSString *pic_front;
@property (nonatomic,retain) NSString *pic_back;
@property (nonatomic,retain) NSString *com_id;
@property (nonatomic,retain) NSString *com_name;
@property (nonatomic,retain) NSString *com_web1;
@property (nonatomic,retain) NSString *com_web2;
@property (nonatomic,retain) NSString *com_phone;
@property (nonatomic,retain) NSString *com_street;
@property (nonatomic,retain) NSString *com_suburb;
@property (nonatomic,retain) NSString *com_city;
@property (nonatomic,retain) NSString *lat;
@property (nonatomic,retain) NSString *lng;
@property (nonatomic,retain) NSString *distance;
@property (nonatomic,retain) NSString *pic_qrcode;
@property (nonatomic,retain) NSString *used;
@property (nonatomic,retain) NSString *c;

@end