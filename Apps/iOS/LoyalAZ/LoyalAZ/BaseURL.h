//
//  BaseURL.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "NSStringUtil.h"
#import "Helper.h"
#import "Application.h"

@class BaseURL;



@protocol BaseURLDelegate
- (void)BaseURLDidFinish:(NSString *)ResponseXML;
- (void)BaseURLErrorOccurred:(NSError *)err;
@end


@interface BaseURL : NSObject
{
    NSMutableData *webData;
    NSString *convertToStringData;
}


@property (assign, nonatomic) id <BaseURLDelegate> delegate;

-(void)GetBaseURL;

@end
