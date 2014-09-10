//
//  mprogram.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>

@interface MProgram : NSObject

{
    NSString *pid;
    NSString *act;
    NSString *name;
    NSString *tagline;
    NSString *description;
    NSString *type;
    NSString *pt_target;
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
    NSString *id;
    NSString *com_email;
    UIImage *icon;
    NSString *rt;
    NSString *c;
}

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *pid;
@property (nonatomic,retain) NSString *act;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *tagline;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *pt_target;
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
@property (nonatomic,retain) NSString *com_email;
@property (nonatomic,retain) UIImage *icon;
@property (nonatomic,retain) NSString *rt;
@property (nonatomic,retain) NSString *c;

@end
