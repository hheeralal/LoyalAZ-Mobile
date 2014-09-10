//
//  NSStringUtil.h
//  LoyalAZ
//
//

#import <Foundation/Foundation.h>

@interface NSStringUtil : NSObject

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

+ (NSData *) base64DataFromString:(NSString *)string;


@end
