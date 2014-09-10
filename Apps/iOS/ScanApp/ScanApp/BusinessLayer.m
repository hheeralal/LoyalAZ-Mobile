//
//  BusinessLayer.m
//  LoyalAZ
//

#import "BusinessLayer.h"

#pragma mark - Declarations

@interface BusinessLayer ()

@end


@implementation BusinessLayer

@synthesize delegate = _delegate;

#pragma mark - Business Logic Methods


-(void) AuthenticateUser:(NSString *)username withPassword:(NSString*)password;
{
    
    NSData *uData = [username dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    NSData *pData = [password dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    
    NSString *strUser = [NSStringUtil base64StringFromData:uData length:uData.length]; //Convert PlainXML to Base64 String
    NSString *strPass =  [NSStringUtil base64StringFromData:pData length:pData.length]; //Convert PlainXML to Base64 String
    
    NSString *varUser = [NSString stringWithFormat:@"<username xsi:type=\"xsd:string\">%@</username>\n",strUser];
    NSString *varPass = [NSString stringWithFormat:@"<password xsi:type=\"xsd:string\">%@</password>\n",strPass];
    rType = enAuthenticateUser;

    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<login_user> \n"];
    [soapEnvelope appendString:varUser];
    [soapEnvelope appendString:varPass];
    [soapEnvelope appendString:@"</login_user> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    //NSLog(@"%@",soapEnvelope);
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
}

-(void) ValidateCoupon:(Coupon *)withCoupon
{
    rType = enValidateCoupon;
    Application *appObj = [Application applicationManager];
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    NSString *strTemp;
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<coupon_validation> \n"];
    strTemp = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:string\">%@</uid>\n",withCoupon.uid];
    [soapEnvelope appendString:strTemp];
    strTemp =  [NSString stringWithFormat:@"<id xsi:type=\"xsd:string\">%@</id>\n",withCoupon.id];
    [soapEnvelope appendString:strTemp];
    strTemp =  [NSString stringWithFormat:@"<guid xsi:type=\"xsd:string\">%@</guid>\n",withCoupon.guid];
    [soapEnvelope appendString:strTemp];
    strTemp =  [NSString stringWithFormat:@"<companyid xsi:type=\"xsd:string\">%@</companyid>\n",appObj.scanapp.companyid];
    [soapEnvelope appendString:strTemp];
    //strTemp =  [NSString stringWithFormat:@"<coupontype xsi:type=\"xsd:string\">%@</coupontype>\n",withCoupon.type];
    //[soapEnvelope appendString:strTemp];
    [soapEnvelope appendString:@"</coupon_validation> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    //NSLog(@"%@",soapEnvelope);
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
}

-(void) RedeemCoupon:(Coupon *)withCoupon
{
    rType = enRedeemCoupon;
    Application *appObj = [Application applicationManager];
    NSString *strTemp;
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<coupon_redemption> \n"];
    strTemp =  [NSString stringWithFormat:@"<uid xsi:type=\"xsd:string\">%@</uid>\n",withCoupon.uid];
    [soapEnvelope appendString:strTemp];
    strTemp =  [NSString stringWithFormat:@"<id xsi:type=\"xsd:string\">%@</id>\n",withCoupon.id];
    [soapEnvelope appendString:strTemp];
    strTemp =  [NSString stringWithFormat:@"<guid xsi:type=\"xsd:string\">%@</guid>\n",withCoupon.guid];
    [soapEnvelope appendString:strTemp];
    strTemp =  [NSString stringWithFormat:@"<companyid xsi:type=\"xsd:string\">%@</companyid>\n",appObj.scanapp.companyid];
    [soapEnvelope appendString:strTemp];
    //strTemp =  [NSString stringWithFormat:@"<coupontype xsi:type=\"xsd:string\">%@</coupontype>\n",withCoupon.type];
    //[soapEnvelope appendString:strTemp];

    [soapEnvelope appendString:@"</coupon_redemption> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    //NSLog(@"%@",soapEnvelope);
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
}




#pragma mark - Communication Manager Delegate

// This delegate method will be fired when Communication manager sends the response back here.
- (void)communicationManagerDidFinish:(NSString *)ResponseXML
{
    //NSLog(@"GOT RESPONSE=%@",ResponseXML);
    if(rType==enAuthenticateUser)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//status"];
        NSLog(@"Authenticate=%@",returnedXML);
        if([returnedXML isEqualToString:@"1"])
        {
            Application *appObj = [Application applicationManager];
            appObj.scanapp.companyid = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//companyid"];
            appObj.scanapp.companyname = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//companyname"];
            [self.delegate BusinessLayerDidFinish:YES];
        }
        else
            [self.delegate BusinessLayerDidFinish:NO];
    }
    else if(rType==enValidateCoupon)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSLog(@"Validate=%@",returnedXML);
        if([returnedXML isEqualToString:@"1"])
            [self.delegate BusinessLayerDidFinish:YES];
        else
            [self.delegate BusinessLayerDidFinishWithResponseCode:returnedXML];
    }
    else if(rType==enRedeemCoupon)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSLog(@"Redeem=%@",returnedXML);
        if([returnedXML isEqualToString:@"1"])
            [self.delegate BusinessLayerDidFinish:YES];
        else
            [self.delegate BusinessLayerDidFinishWithResponseCode:returnedXML];
    }
}

// This delegate method will be fired when Communication manager generates error.
- (void)communicationManagerErrorOccurred:(NSError *)err
{
    [self.delegate BusinessLayerErrorOccurred:err];
}



@end
