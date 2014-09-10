//
//  FBCommunication.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>

#import "NSStringUtil.h"
#import "Helper.h"
#import "Application.h"
#import "SBJson.h"


@class FBCommunication;

@protocol FBCommunicationManagerDelegate
- (void)communicationManagerDidFinish:(NSString *)ResponseXML;
- (void)communicationManagerErrorOccurred:(NSError *)err;
@end


@interface FBCommunication : NSObject
{
NSMutableString *nodeContent;
NSMutableData *webData;
NSString *convertToStringData;
}

@property (assign, nonatomic) id <FBCommunicationManagerDelegate> delegate;

-(NSString *)SendGraphRequest:(NSString *)pageName;

@end
