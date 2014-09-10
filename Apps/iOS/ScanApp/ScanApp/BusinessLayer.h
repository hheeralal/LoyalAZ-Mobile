//
//  BusinessLayer.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "Application.h"
#import "XMLParser.h"
#import "NSStringUtil.h"
#import "CommunicationManager.h"



@class BusinessLayer;

@protocol BusinessLayerDelegate
- (void)BusinessLayerDidFinish:(BOOL)result;

- (void)BusinessLayerErrorOccurred:(NSError *)err;

-(void)BusinessLayerDidFinishWithResponseCode:(NSString*)responseCode;

@end

enum RequestType
{
    enAuthenticateUser = 1,
    enValidateCoupon = 2,
    enRedeemCoupon = 3
};


@interface BusinessLayer : NSObject <CommunicationManagerDelegate>
{
    enum RequestType rType;
    BOOL addFromFind;
}

@property (assign, nonatomic) id <BusinessLayerDelegate> delegate;

-(void) AuthenticateUser:(NSString *)username withPassword:(NSString*)password;

-(void) ValidateCoupon:(Coupon *)withCoupon;

-(void) RedeemCoupon:(Coupon *)withCoupon;

@end
