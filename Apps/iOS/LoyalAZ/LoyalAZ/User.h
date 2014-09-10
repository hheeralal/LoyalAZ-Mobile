//
//  User.h
//  TestXML
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSString *uid;
    //int uid;
    NSString *st;
    NSString *name;
    NSString *firstname;
    NSString *lastname;
    NSString *email;
    NSString *mobilephone;
    NSString *addressstreet;
    NSString *addresssuburb;
    NSString *addresscity;
    NSString *addresscountry;
    
}

//@property (nonatomic,readwrite) int uid;
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) NSString *st;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *firstname;
@property (nonatomic,retain) NSString *lastname;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *mobilephone;
@property (nonatomic,retain) NSString *addressstreet;
@property (nonatomic,retain) NSString *addresssuburb;
@property (nonatomic,retain) NSString *addresscity;
@property (nonatomic,retain) NSString *addresscountry;

@end
