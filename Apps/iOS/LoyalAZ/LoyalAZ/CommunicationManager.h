//
//  CommunicationManager.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "NSStringUtil.h"
#import "Helper.h"
#import "Application.h"
#import "BaseURL.h"

@class CommunicationManager;

@protocol CommunicationManagerDelegate
- (void)communicationManagerDidFinish:(NSString *)ResponseXML;
- (void)communicationManagerErrorOccurred:(NSError *)err;
@end

@interface CommunicationManager : NSObject
{
    NSMutableString *nodeContent;
    NSMutableData *webData;
    NSString *convertToStringData;
}

@property (assign, nonatomic) id <CommunicationManagerDelegate> delegate;

-(void)MakeHTTPPost:(NSString*)urlToPost postData:(NSString *)post;
-(void)SendSOAPRequest:(NSString *)SOAPEnvelopeString;

@end
