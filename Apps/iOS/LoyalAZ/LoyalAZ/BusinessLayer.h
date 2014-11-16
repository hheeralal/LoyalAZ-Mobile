//
//  BusinessLayer.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "Application.h"
#import "XMLParser.h"
#import "NSStringUtil.h"
#import "CommunicationManager.h"
#import "ReferBusiness.h"



@class BusinessLayer;

@protocol BusinessLayerDelegate
- (void)BusinessLayerDidFinish:(BOOL)result;

- (void)BusinessLayerErrorOccurred:(NSError *)err;
@end

@protocol CouponCodeDelegate
- (void)CouponCodeFinishedWithCouponCode:(BOOL)result withCouponCode:(NSString *)couponCode;
- (void)CouponRedeemCompleted:(BOOL)result;
@end

@protocol CouponQRCodeDelegate
- (void)CouponQRCodeDelegateFinishedWithQRCode:(NSString *)qrCodeURL;
@end

enum RequestType
{
    RegistrationStep1 = 0,
    RegistrationStep2 = 1,
    RegistrationStep3 = 2,
    SyncXml = 4,
    enFindPrograms = 5,
    enGetCouponNumber = 6,
    enProcessRedemption = 7,
    enValidateEmailId = 8,
    enValidateSecurityToken = 9,
    enGetBaseURL = 10,
    enSaveReferBusiness = 11,
    enFindCoupons = 12,
    enAddUserCoupon = 13,
    enRemoveUserCoupon = 14,
    enSendMail = 15,
    enDeleteAccount = 16,
    enRemoveProgram = 17,
    enGetAds = 18
};


@interface BusinessLayer : NSObject <CommunicationManagerDelegate>
{
    enum RequestType rType;
    BOOL addFromFind;
}

@property (assign, nonatomic) id <BusinessLayerDelegate> delegate;

@property (assign, nonatomic) id <CouponCodeDelegate> coupondelegate;

@property (assign, nonatomic) id <CouponQRCodeDelegate> couponQRCodedelegate;

-(void)UserRegistrationStep1;

-(void)UserRegistrationStep2;

-(void)UserRegistrationStep3;

- (void) SyncDB;

- (void) FindPrograms:(NSString *)latValue lngValue:(NSString *)lngValue userId:(NSString *)uid;

- (void) FindCoupons:(NSString *)latValue lngValue:(NSString *)lngValue userId:(NSString *)uid;

- (BOOL) IsProgramExists:(NSString *)pid;

- (BOOL) IsProgramExistsWithLocation:(NSString *)pid withLocation:(NSString *)com_id;

-(BOOL)IsProgramReachedRechargeLevel:(NSString *)pid withLocation:(NSString *)com_id;

- (BOOL) IsCouponExists:(NSString *)id;

-(NSString *)UpdateProgramBalance:(Program *)programObject;

-(NSString *)AddProgramFromFind:(Program *)programObject;

-(NSString *)AddCouponFromFind:(Coupon *)couponObject;

-(void) GetCouponNumber:(NSString *)userId withProgram:(Program *)programObject;

-(void)UpdateProgramActState:(Program *)programObject;

-(void)ProcessRedeem:(NSString *)userId withProgram:(Program *)programObject;

- (BOOL) IsRedeemPending;

-(void) UpdateProgramRedeemed:(Program *)programObject;

-(void) ValidateEmailId:(NSString *)emailId;

-(void) XMLDBRecovery:(NSString *)SecurityToken;

-(void) UpdateProgramImages;

-(void) GetBaseURL;

-(NSString *)DownloadImage:(NSString *)imageAddress;

-(void)DeleteImage:(NSString *)fileName;

-(void)SaveReferBusiness:(ReferBusiness *)referBusiness;

-(void)AddUserCoupon:(Coupon *)coupon userId:(NSString *)uid;

-(void)UpdateCouponQRCodeImage:(Coupon *)couponObject;

- (void) RemoveUserCoupon:(NSString *)userId CouponId:(NSString *)couponId;

-(void) SendSecurityTokenEmail:(NSString *)emailId;

-(void)DeleteAccount;

-(BOOL)ValidateProgramScan:(Program *)prg;

-(BOOL)RemoveProgram:(Program *)prg;

-(void)DeleteProgramFromXML:(Program *)prg;

-(void)GetAdsURL;

-(NSString *)UpdateSavingTypeProgramBalance:(Program *)programObject;

-(NSString *)RechargeSavingTypeProgram:(Program *)programObject;

-(NSString *)GetProgramPins:(Program *)programObject;

-(NSString *)UpdateAccumulationProgram:(Program *)programObject;

-(NSString *)GetProgramAccumulationLevels:(Program *)program;

-(void)RecoverProgramImages;

@end
