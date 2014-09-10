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
@synthesize coupondelegate = _coupondelegate;


#pragma mark - Business Logic Methods


-(void)UserRegistrationStep1
{
    //  DATA received from the form.
    //  Create the SOAP envelope and make SOAP call.
    
    
    rType = RegistrationStep1;
    
    Application *appObject = [Application applicationManager];

    NSString *xmlContents = [XMLParser ObjectToXml:appObject.loyalaz];
    
    //NSLog(@"REGISTER_XML===\n%@",xmlContents);
    
    
    NSData *xmlData = [xmlContents dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    
    NSString *xml64 = [NSStringUtil base64StringFromData:xmlData length:xmlData.length]; //Convert PlainXML to Base64 String
    NSString *var = [NSString stringWithFormat:@"<xml_base64 xsi:type=\"xsd:string\">%@</xml_base64>\n",xml64];

    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<register_user> \n"];
    [soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</register_user> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
}

-(void)SaveReferBusiness:(ReferBusiness *)referBusiness
{
    rType = enSaveReferBusiness;
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<recommend_company> \n"];
    
    [soapEnvelope appendString:@"<rec_cname>"];
    [soapEnvelope appendString:referBusiness.rec_cname];
    [soapEnvelope appendString:@"</rec_cname>\n"];
    
    [soapEnvelope appendString:@"<rec_phone>"];
    [soapEnvelope appendString:referBusiness.rec_phone];
    [soapEnvelope appendString:@"</rec_phone>\n"];
    
    [soapEnvelope appendString:@"<rec_email>"];
    [soapEnvelope appendString:referBusiness.rec_email];
    [soapEnvelope appendString:@"</rec_email>\n"];
    
    [soapEnvelope appendString:@"<rec_mgrfname>"];
    [soapEnvelope appendString:referBusiness.rec_mgrfname];
    [soapEnvelope appendString:@"</rec_mgrfname>\n"];
    
    [soapEnvelope appendString:@"<rec_mgrlname>"];
    [soapEnvelope appendString:referBusiness.rec_mgrlname];
    [soapEnvelope appendString:@"</rec_mgrlname>\n"];
    
    [soapEnvelope appendString:@"<rec_whyinvited>"];
    [soapEnvelope appendString:referBusiness.rec_whyinvited];
    [soapEnvelope appendString:@"</rec_whyinvited>\n"];
    
    [soapEnvelope appendString:@"<rec_address>"];
    [soapEnvelope appendString:referBusiness.rec_address];
    [soapEnvelope appendString:@"</rec_address>\n"];
    
//    [soapEnvelope appendString:@"<com_id>"];
//    [soapEnvelope appendString:referBusiness.com_id];
//    [soapEnvelope appendString:@"</com_id>\n"];
    
    [soapEnvelope appendString:@"<lat>"];
    [soapEnvelope appendString:referBusiness.lat];
    [soapEnvelope appendString:@"</lat>\n"];
    
    [soapEnvelope appendString:@"<lng>"];
    [soapEnvelope appendString:referBusiness.lng];
    [soapEnvelope appendString:@"</lng>\n"];
    

    [soapEnvelope appendString:@"</recommend_company> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"REFER_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];

}

- (void) SyncDB
{
    rType = SyncXml;
    Application *appObject = [Application applicationManager];
    appObject.loyalaz.sync=@"0";
    NSString *xmlContents = [XMLParser ObjectToXml:appObject.loyalaz];
    
    //xmlContents = @"<LoyalAZ sync=\"\" ><User uid=\"25\" st=\"\" name=\"\" firstname=\"Harry\" lastname=\"Singh\" email=\"harry@gmail.com\" mobilephone=\"061398349348\" addressstreet=\"\" addresssuburb=\"\" addresscity=\"Chandigarh\" addresscountry=\"Australia\" ></User><programs><Program id=\"42\" pid=\"305758BA-0EC5-8AAD-A353-82B647F63156\" act=\"0\" name=\"$10 Voucher\" tagline=\"dfgfdgdf\" type=\"2\" pt_balance=\"1\" pt_target=\"20\" pic_logo=\"\" pic_front=\"\" pic_back=\"\" com_id=\"25\" com_name=\"Jitters\" com_web1=\"\" com_web2=\"\" com_phone=\"\" coupon_no=\"\"/></programs></LoyalAZ>";
    //xmlContents = [xmlContents stringByReplacingOccurrencesOfString:@"<coupons></coupons>" withString:@""];
//    NSLog(@"SYNCXML_SENT===%@",xmlContents);
    
    
    NSData *xmlData = [xmlContents dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    
    NSString *xml64 = [NSStringUtil base64StringFromData:xmlData length:xmlData.length]; //Convert PlainXML to Base64 String
    NSString *var = [NSString stringWithFormat:@"<xml_base64 xsi:type=\"xsd:string\">%@</xml_base64>\n",xml64];
    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<sync_xmldb> \n"];
    [soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</sync_xmldb> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"SYNC_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    //[soapEnvelope release];
    
}

-(void) GetCouponNumber:(NSString *)userId withProgram:(Program *)programObject
{
    rType = enGetCouponNumber;
    NSString *tempString;
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<process_coupon>\n"];
    
    tempString = [[NSString alloc]initWithFormat:@"<id xsi:type=\"xsd:int\">%@</id>",programObject.id];
    [soapEnvelope appendString:tempString];
    
    tempString = [[NSString alloc]initWithFormat:@"<uid xsi:type=\"xsd:int\">%@</uid>",userId];
    [soapEnvelope appendString:tempString];
    
    tempString = [[NSString alloc]initWithFormat:@"<pt_balance xsi:type=\"xsd:int\">%@</pt_balance>",programObject.pt_balance];
    [soapEnvelope appendString:tempString];
    
    tempString = [[NSString alloc]initWithFormat:@"<pt_target xsi:type=\"xsd:int\">%@</pt_target>",programObject.pt_target];
    [soapEnvelope appendString:tempString];
    
    tempString = [[NSString alloc]initWithFormat:@"<com_id xsi:type=\"xsd:int\">%@</com_id>",programObject.com_id];
    [soapEnvelope appendString:tempString];
    
    //[soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</process_coupon></SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"GET_COUPON_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    //[soapEnvelope release];
}

-(void)AddUserCoupon:(Coupon *)coupon userId:(NSString *)uid
{
    rType =enAddUserCoupon;

    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<add_usercoupon> \n"];
    NSString *tempString = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:xsd:int\">%@</uid>  \n",uid];
    [soapEnvelope appendString:tempString];
    tempString = [NSString stringWithFormat:@"<id xsi:type=\"xsd:xsd:int\">%@</id>  \n",coupon.id];
    [soapEnvelope appendString:tempString];
    tempString = [NSString stringWithFormat:@"<guid xsi:type=\"xsd:xsd:string\">%@</guid>  \n",coupon.guid];
    [soapEnvelope appendString:tempString];
    tempString = [NSString stringWithFormat:@"<coupontype xsi:type=\"xsd:xsd:string\">%@</coupontype>  \n",coupon.typename];
    [soapEnvelope appendString:tempString];
    tempString = [NSString stringWithFormat:@"<com_id xsi:type=\"xsd:xsd:int\">%@</com_id>  \n",coupon.com_id];
    [soapEnvelope appendString:tempString];
    [soapEnvelope appendString:@"</add_usercoupon> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    //[soapEnvelope release];
}


- (void) FindPrograms:(NSString *)latValue lngValue:(NSString *)lngValue userId:(NSString *)uid
{
    rType =enFindPrograms;
    NSString *uidString = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:float\">%@</uid> \n",uid];    
    NSString *latString = [NSString stringWithFormat:@"<lat xsi:type=\"xsd:float\">%@</lat>  \n",latValue];
    NSString *lngString = [NSString stringWithFormat:@"<lng xsi:type=\"xsd:float\">%@</lng> \n",lngValue];

    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<find_moreprogs> \n"];
    [soapEnvelope appendString:uidString];
    [soapEnvelope appendString:latString];
    [soapEnvelope appendString:lngString];
    //[soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</find_moreprogs> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"MORE_PRG_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    //[soapEnvelope release];
}

- (void) FindCoupons:(NSString *)latValue lngValue:(NSString *)lngValue userId:(NSString *)uid
{
    rType =enFindCoupons;
    NSString *uidString = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:float\">%@</uid> \n",uid];
    NSString *latString = [NSString stringWithFormat:@"<lat xsi:type=\"xsd:float\">%@</lat>  \n",latValue];
    NSString *lngString = [NSString stringWithFormat:@"<lng xsi:type=\"xsd:float\">%@</lng> \n",lngValue];
    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<find_morecoupons> \n"];
    [soapEnvelope appendString:uidString];
    [soapEnvelope appendString:latString];
    [soapEnvelope appendString:lngString];
    //[soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</find_morecoupons> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
//    NSLog(@"MORE_PRG_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    //[soapEnvelope release];
}


- (void) RemoveUserCoupon:(NSString *)userId CouponId:(NSString *)couponId
{
    rType = enRemoveUserCoupon;
    NSString *userTag = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:float\">%@</uid>  \n",userId];
    NSString *couponTag = [NSString stringWithFormat:@"<id xsi:type=\"xsd:float\">%@</id> \n",couponId];
    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<remove_usercoupon> \n"];
    [soapEnvelope appendString:userTag];
    [soapEnvelope appendString:couponTag];
    //[soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</remove_usercoupon> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"MORE_PRG_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    //[soapEnvelope release];
}



-(void) GetBaseURL
{
    rType = enGetBaseURL;
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<get_baseurl> \n"];
    [soapEnvelope appendString:@"</get_baseurl> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    //NSLog(@"%@",soapEnvelope);
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
}


-(void)UpdateProgramImages
{
    Application *appObject = [Application applicationManager];    
    for(Program *prg in appObject.loyalaz.programs)
    {
        if([prg.u isEqualToString:@"1"] || [prg.d isEqualToString:@"1"])
        {
                if([prg.pic_logo hasPrefix:@"http://"])
                {
                    //NSLog(@"Image to be updated.");
                    [self DeleteImage:prg.pic_back]; //delete existing images
                    [self DeleteImage:prg.pic_front]; //delete existing images
                    [self DeleteImage:prg.pic_logo]; //delete existing images
                    
                    prg.pic_logo = [self DownloadImage:prg.pic_logo];
                    prg.pic_front = [self DownloadImage:prg.pic_front];
                    prg.pic_back = [self DownloadImage:prg.pic_back];
                    //NSLog(@"Images updated.");
                }
            
            
                if([prg.d isEqualToString:@"1"])
                {
                    prg.d=@"";
                }
            
                if([prg.u isEqualToString:@"1"])
                {
                    prg.u=@"";
                }
            
            
                
                [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
                //NSLog(@"XMLDB updated.");

        }
    }
}

-(void)DeleteImage:(NSString *)fileName
{
    //NSLog(@"Previous files deleted.");
    //NSString* fileName = [[NSString alloc]initWithFormat:@"logo_%@.png",pid];
    [Helper DeleteFile:fileName];
    
//    fileName = [[NSString alloc]initWithFormat:@"front_%@.png",pid];
//    [Helper DeleteFile:fileName];
//    
//    fileName = [[NSString alloc]initWithFormat:@"back_%@.png",pid];
//    [Helper DeleteFile:fileName];
//    
//    
//    fileName = [[NSString alloc]initWithFormat:@"logo_%@.jpg",pid];
//    [Helper DeleteFile:fileName];
//    
//    fileName = [[NSString alloc]initWithFormat:@"front_%@.jpg",pid];
//    [Helper DeleteFile:fileName];
//    
//    fileName = [[NSString alloc]initWithFormat:@"back_%@.jpg",pid];
//    [Helper DeleteFile:fileName];    
    
    //[fileName release];
}


-(void)UserRegistrationStep2
{
    rType = RegistrationStep1;
    
    Application *appObject = [Application applicationManager];
    [Helper SaveObjectToDB:appObject.loyalaz];
    [self.delegate BusinessLayerDidFinish:YES];
    //NSString *xmlContents = [XMLParser ObjectToXml:appObject.loyalaz];

}

-(void)UserRegistrationStep3
{
    
}

- (BOOL) IsProgramExists:(NSString *)pid
{
    Program *prg;
    Application *appObject = [Application applicationManager];    
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        prg = [appObject.loyalaz.programs objectAtIndex:i];
        if([pid isEqualToString:prg.pid])
        {
            return YES;
        }
    }
    return NO;
}


- (BOOL) IsProgramExistsWithLocation:(NSString *)pid withLocation:(NSString *)com_id
{
    Program *prg;
    Application *appObject = [Application applicationManager];
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        prg = [appObject.loyalaz.programs objectAtIndex:i];
        if([pid isEqualToString:prg.pid] && [com_id isEqualToString:prg.com_id])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)IsProgramReachedRechargeLevel:(NSString *)pid withLocation:(NSString *)com_id
{
    Program *prg;
    Application *appObject = [Application applicationManager];
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        prg = [appObject.loyalaz.programs objectAtIndex:i];
        if([pid isEqualToString:prg.pid] && [com_id isEqualToString:prg.com_id])
        {
            if([prg.pt_balance isEqualToString:@"0"])
                return YES;
        }
    }
    return NO;

}

- (BOOL) IsCouponExists:(NSString *)id
{
    Coupon *cpn;
    Application *appObject = [Application applicationManager];
    for(int i=0;i<appObject.loyalaz.coupons.count;i++)
    {
        cpn = [appObject.loyalaz.coupons objectAtIndex:i];
        if([id isEqualToString:cpn.id]==YES)
        {
            return YES;
            break;
        }
    }
    return NO;
}

-(void)UpdateProgramActState:(Program *)programObject
{
    Program *prg;
    Application *appObject = [Application applicationManager];    
    
    if([self IsProgramExists:programObject.pid]) //check if program already exists than update its balance
    {
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                prg.act = @"1";
                prg.coupon_no=programObject.coupon_no;
                [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
                //break;
            }
        }
    }
}

-(void)ProcessRedeem:(NSString *)userId withProgram:(Program *)programObject
{
    rType = enProcessRedemption;
    NSString *tempString;
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<process_redemption> \n"];
    
    tempString = [[NSString alloc]initWithFormat:@"<id xsi:type=\"xsd:int\">%@</id>",programObject.id];
    [soapEnvelope appendString:tempString];
    
    tempString = [[NSString alloc]initWithFormat:@"<uid xsi:type=\"xsd:int\">%@</uid>",userId];
    [soapEnvelope appendString:tempString];

    
    tempString = [[NSString alloc]initWithFormat:@"<pt_balance xsi:type=\"xsd:int\">%@</pt_balance>",programObject.pt_balance];
    [soapEnvelope appendString:tempString];

    
    tempString = [[NSString alloc]initWithFormat:@"<com_id xsi:type=\"xsd:int\">%@</com_id>",programObject.com_id];
    [soapEnvelope appendString:tempString];

    
    tempString = [[NSString alloc]initWithFormat:@"<coupon xsi:type=\"xsd:int\">%@</coupon>",programObject.coupon_no];
    [soapEnvelope appendString:tempString];            

    
    //[soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</process_redemption> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"process_redemption_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
}


-(NSString *)AddProgramFromFind:(Program *)programObject
{
    NSString *return_balance=[[NSString alloc]init];
    addFromFind = YES;
    return_balance = [self UpdateProgramBalance:programObject];
    return return_balance;
}

-(NSString *)AddCouponFromFind:(Coupon *)couponObject
{
    Application *appObject = [Application applicationManager];
    if([self IsCouponExists:couponObject.id]) //check if coupon already exists
    {
    }
    else // if coupon doesn't exist than add new coupon in the array and save it.
    {
        if(appObject.loyalaz.coupons.count==0)
            appObject.loyalaz.coupons = [[NSMutableArray alloc]init];
        
        [appObject.loyalaz.coupons addObject:couponObject];
        
        if([Helper IsInternetAvailable]==YES)
        {
            couponObject.pic_logo = [self DownloadImage:couponObject.pic_logo];
            couponObject.pic_front = [self DownloadImage:couponObject.pic_front];
            couponObject.pic_back = [self DownloadImage:couponObject.pic_back];
        }
        
        //NSLog(@"XML==%@",[XMLParser ObjectToXml:appObject.loyalaz]);
        [self AddUserCoupon:couponObject userId:appObject.loyalaz.user.uid];
        
        [Helper SaveObjectToDB:appObject.loyalaz];
    }
    return @"";
}

-(NSString *)UpdateProgramBalance:(Program *)programObject
{
    
    //NSLog(@"PID==%@",programObject.pid);
    
    Program *prg;
    Application *appObject = [Application applicationManager];    
    int current_balance;
    int target_points;
    int current_loc_balance;
    BOOL flagAct = NO;
    NSString *return_balance=[[NSString alloc]init];
    
//    if([self IsProgramExists:programObject.pid]) //check if program already exists than update its balance
    if([self IsProgramExistsWithLocation:programObject.pid withLocation:programObject.com_id])
    {
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            NSLog(@"PRG=%@",prg.pid);
            if([programObject.pid isEqualToString:prg.pid] && [programObject.com_id isEqualToString:prg.com_id])
            {
                NSLog(@"SAMESAMESAME");
                if([prg.act isEqualToString:@"1"])
                {
                    NSLog(@"ACT FOUNDDDDDDDDDDDD");
                    flagAct = YES;
                    return_balance = @"-1";
                    break;
                }
                else 
                {
                    current_balance =[prg.pt_balance intValue];
                    target_points = [prg.pt_target intValue];
                    current_loc_balance = [prg.pt_loc_balance intValue];
                    if(current_balance<target_points)
                    {
                        
                        if([programObject.spt isEqualToString:@""]) // check if spt node exists or not.
                        {
                            current_balance++;
                            current_loc_balance++;
                        }
                        else
                        {
                            current_balance = current_balance + [programObject.spt intValue];
                            current_loc_balance= current_loc_balance + [programObject.spt intValue];
                        }
                        
                        prg.pt_balance = return_balance;
                        prg.pt_loc_balance = [[NSString alloc]initWithFormat:@"%d",current_loc_balance];
                        NSDate *current = [NSDate date];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
                        NSString *stringDTStamp = [formatter stringFromDate:current];
                        prg.s_dt = stringDTStamp;
                        
                        [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
                    }
                    break;
                }
            }
        }
        
        current_balance = 0;
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                current_balance = current_balance + [prg.pt_loc_balance intValue];
            }
        }
        
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                prg.pt_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
            }
        }
        return_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
        [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
    }
    else // if program doesn't exist than add new program in the array and save it.
    {
        if(appObject.loyalaz.programs.count==0)
            appObject.loyalaz.programs = [[NSMutableArray alloc]init]; 
        
        programObject.u=@"";
        
        if(addFromFind==YES)
        {
            programObject.pt_balance=@"0";
            programObject.pt_loc_balance = @"0";
        }
        else
        {
            
            if([programObject.spt isEqualToString:@""])
            {
                programObject.pt_balance=@"1";
                programObject.pt_loc_balance = @"1";

            }
            else
            {
                programObject.pt_balance=programObject.spt;
                programObject.pt_loc_balance = programObject.spt;

            }
            
        }
        
        
        addFromFind=NO;
        
        [appObject.loyalaz.programs addObject:programObject];
        current_balance =[programObject.pt_balance intValue];
        return_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];

        if([Helper IsInternetAvailable]==YES)
        {
            programObject.pic_logo = [self DownloadImage:programObject.pic_logo];
            programObject.pic_front = [self DownloadImage:programObject.pic_front];
            programObject.pic_back = [self DownloadImage:programObject.pic_back];
            programObject.d=@"0"; //Status that images are downloaded.
        }
        else
        {
            programObject.d=@"1"; //status that images are not downloaded.
        }
        //NSLog(@"Saved Program=%@",programObject.pid);
        [Helper SaveObjectToDB:appObject.loyalaz];
////////////////////////////////////////////////////////////////////////////////////////////////
        
        current_balance = 0;
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                current_balance = current_balance + [prg.pt_loc_balance intValue];
            }
        }
        
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                prg.pt_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
                if(flagAct==YES)
                    prg.act=@"1";
            }
        }
        
        return_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
        [Helper SaveObjectToDB:appObject.loyalaz];
////////////////////////////////////////////////////////////////////////////////////////////////
    }
    
    if(flagAct==YES)
        return_balance=@"-1";
    
    return return_balance;
}


-(NSString *)UpdateSavingTypeProgramBalance:(Program *)programObject
{
    
    //NSLog(@"PID==%@",programObject.pid);
    
    Program *prg;
    Application *appObject = [Application applicationManager];
    int current_balance;
    int target_points;
    int current_loc_balance;
    BOOL flagAct = NO;
    NSString *return_balance=[[NSString alloc]init];
    
    //    if([self IsProgramExists:programObject.pid]) //check if program already exists than update its balance
    if([self IsProgramExistsWithLocation:programObject.pid withLocation:programObject.com_id])
    {
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            NSLog(@"PRG=%@",prg.pid);
            if([programObject.pid isEqualToString:prg.pid] && [programObject.com_id isEqualToString:prg.com_id])
            {
                NSLog(@"SAMESAMESAME");
                if([prg.act isEqualToString:@"1"])
                {
                    NSLog(@"ACT FOUNDDDDDDDDDDDD");
                    flagAct = YES;
                    return_balance = @"-1";
                    break;
                }
                else
                {
                    
                    NSLog(@"BALANCE=%@",prg.pt_balance);
                    current_balance =[prg.pt_balance intValue];
                    target_points = [prg.pt_target intValue];
                    current_loc_balance = [prg.pt_loc_balance intValue];
                    if(current_balance>0)
                    {
                        
                        if([programObject.spt isEqualToString:@""]) // added check if spt node value is not empty
                        {
                            current_balance--;
                            current_loc_balance--;
                        }
                        else
                        {
                            current_balance = current_balance - [programObject.spt intValue];
                            current_loc_balance = current_loc_balance - [programObject.spt intValue];
                        }

                        
//                        prg.pt_balance = return_balance;
                        prg.pt_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
                        prg.pt_loc_balance = [[NSString alloc]initWithFormat:@"%d",current_loc_balance];
                        
                        NSLog(@"CURR BALANCE=%@",prg.pt_loc_balance);
                        
                        NSDate *current = [NSDate date];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
                        NSString *stringDTStamp = [formatter stringFromDate:current];
                        prg.s_dt = stringDTStamp;
                        
                        [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
                    }
                    break;
                }
            }
        }
        
        current_balance = 0;
        int total_target = 0;
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                //                current_balance =current_balance + ([prg.pt_target intValue] - [prg.pt_loc_balance intValue]);
                current_balance =current_balance +  [prg.pt_loc_balance intValue];
                NSLog(@"LOC_BALA=%@",prg.pt_loc_balance);
                total_target += [prg.pt_target intValue];
                
            }
        }
        
        //current_balance = abs(total_target - current_balance);
        int temp_balance =abs(total_target - current_balance);
        NSLog(@"CURR=%d",temp_balance);
        
        
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                current_balance = [prg.pt_target intValue]-temp_balance;
                NSLog(@"VALUEEEEEEEEE=%d",current_balance);
                prg.pt_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
            }
        }

        return_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
        [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
    }
    else // if program doesn't exist than add new program in the array and save it.
    {
        if(appObject.loyalaz.programs.count==0)
            appObject.loyalaz.programs = [[NSMutableArray alloc]init];
        
        programObject.u=@"";
        
        if(addFromFind==YES)
        {
//            programObject.pt_balance=@"0";
//            programObject.pt_loc_balance = @"0";
            programObject.pt_balance = programObject.pt_target;
            programObject.pt_loc_balance = programObject.pt_target;
        }
        else
        {
            programObject.pt_balance = programObject.pt_target;
            programObject.pt_loc_balance = programObject.pt_target;
        }
        
        
        addFromFind=NO;
        

        if([self IsProgramExists:programObject.pid]==NO) //Program with same PID does not exists hence update the path of new program by downloading the images
        {
            if([Helper IsInternetAvailable]==YES)
            {
                programObject.pic_logo = [self DownloadImage:programObject.pic_logo];
                programObject.pic_front = [self DownloadImage:programObject.pic_front];
                programObject.pic_back = [self DownloadImage:programObject.pic_back];
                programObject.d=@"0"; //Status that images are downloaded.
            }
            else
            {
                programObject.d=@"1"; //status that images are not downloaded.
            }
        }
        else //Program with same PID already exists hence update the path of new program with previous program object
        {
            for(int i=0;i<appObject.loyalaz.programs.count;i++)
            {
                prg = [appObject.loyalaz.programs objectAtIndex:i];
                if([programObject.pid isEqualToString:prg.pid])
                {
                    programObject.pic_back = prg.pic_back;
                    programObject.pic_front=prg.pic_front;
                    programObject.pic_logo=prg.pic_logo;
                    programObject.d=@"0";
                }
            }

        }
        
        [appObject.loyalaz.programs addObject:programObject];
        current_balance =[programObject.pt_balance intValue];
        return_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];


        //NSLog(@"Saved Program=%@",programObject.pid);
        [Helper SaveObjectToDB:appObject.loyalaz];
        ////////////////////////////////////////////////////////////////////////////////////////////////
        
        current_balance = 0;
        int total_target = 0;
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
//                current_balance =current_balance + ([prg.pt_target intValue] - [prg.pt_loc_balance intValue]);
                current_balance =current_balance +  [prg.pt_loc_balance intValue];
                NSLog(@"LOC_BALA=%@",prg.pt_loc_balance);
                total_target += [prg.pt_target intValue];
                
            }
        }
        
        //current_balance = abs(total_target - current_balance);
        int temp_balance =abs(total_target - current_balance);
        NSLog(@"CURR=%d",temp_balance);

        
        for(int i=0;i<appObject.loyalaz.programs.count;i++)
        {
            prg = [appObject.loyalaz.programs objectAtIndex:i];
            if([programObject.pid isEqualToString:prg.pid])
            {
                current_balance = [prg.pt_target intValue]-temp_balance;
                NSLog(@"VALUEEEEEEEEE=%d",current_balance);
                prg.pt_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
                if(flagAct==YES)
                    prg.act=@"1";
            }
        }
        
        return_balance = [[NSString alloc]initWithFormat:@"%d",current_balance];
        [Helper SaveObjectToDB:appObject.loyalaz];
        
        NSLog(@"XML=%@",[XMLParser ObjectToXml:appObject.loyalaz]);
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
    }
    
    
    return return_balance;
}

-(NSString *)RechargeSavingTypeProgram:(Program *)programObject
{
    Application *appObject = [Application applicationManager];
    NSString *return_balance;
    Program* prg;
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        prg = [appObject.loyalaz.programs objectAtIndex:i];
        NSLog(@"PRG=%@",prg.pid);
        if([programObject.pid isEqualToString:prg.pid] && [programObject.com_id isEqualToString:prg.com_id])
        {
            prg.pt_balance = programObject.pt_target;
            prg.pt_loc_balance = programObject.pt_target;
        }
    }
    [Helper SaveObjectToDB:appObject.loyalaz];
    return return_balance;
}


-(NSString *)DownloadImage:(NSString *)imageAddress
{
    NSString *ext;
    NSString *imageName;
    NSURL *imageURL = [NSURL URLWithString:imageAddress];
    NSArray *parts = [imageAddress componentsSeparatedByString:@"/"];
    ext=[parts objectAtIndex:[parts count]-1];

    
    parts = [ext componentsSeparatedByString:@"."];
    ext=[parts objectAtIndex:[parts count]-1];
    imageName = [parts objectAtIndex:[parts count]-2];
    
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    //NSString *fileName = [[NSString alloc]initWithFormat:@"%@_%@.%@",imageType,pid,ext];
    NSString *fileName = [[NSString alloc]initWithFormat:@"%@.%@",imageName,ext];
    //NSLog(@"Image is updated with:%@",fileName);
    [Helper SaveImageFile:image imageFileName:fileName fileExtension:ext];
    
//    [imageData release];
//    [image release];
    
//    return [Helper GetStoragePath:fileName];
    return fileName;
    
}

-(void) UpdateProgramRedeemed:(Program *)programObject
{
    Program *prg;
    Application *appObject = [Application applicationManager];    
    
    for(int i=0;i<appObject.loyalaz.programs.count;i++)
    {
        prg = [appObject.loyalaz.programs objectAtIndex:i];
        if([programObject.pid isEqualToString:prg.pid])
        {
            
            //NSLog(@"Current Balance=%@",prg.pt_balance);
            //NSLog(@"Current Coupon=%@",prg.coupon_no);                
            
            prg.pt_balance = @"0";
            prg.coupon_no=@"";
            prg.act=@"";
            prg.pt_loc_balance=@"0";
            [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
            //break;
        }
    }
}

-(void)UpdateCouponQRCodeImage:(Coupon *)couponObject
{
    Application *appObject = [Application applicationManager];
    if(appObject.loyalaz.coupons.count >0)
    {
        Coupon *cpn;
        for(int i=0;i< appObject.loyalaz.coupons.count;i++)
        {
            cpn = [appObject.loyalaz.coupons objectAtIndex:i];
            if([cpn.id isEqualToString:couponObject.id])
            {
                cpn.pic_qrcode = [self DownloadImage:couponObject.pic_qrcode];
                [appObject.loyalaz.coupons setObject:cpn atIndexedSubscript:i];
                [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
                //NSLog(@"QRCode pic=%@",cpn.pic_qrcode);
                break;
            }
        }
    }
}

- (BOOL) IsRedeemPending
{
    BOOL redeemPending = NO;
    
    Application *appObject = [Application applicationManager];
    if(appObject.loyalaz.programs.count >0)
    {
        for(Program *prg in appObject.loyalaz.programs)
        {
            if([prg.act isEqualToString:@"1"])
            {
                redeemPending = YES;
                break;
            }
        }
    }
    
    return redeemPending;
}


-(void) ValidateEmailId:(NSString *)emailId
{
    rType = enValidateEmailId;
    
    NSData *xmlData = [emailId dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    NSString *xml64 = [NSStringUtil base64StringFromData:xmlData length:xmlData.length]; //Convert PlainXML to Base64 String
    NSString *var = [NSString stringWithFormat:@"<email xsi:type=\"xsd:string\">%@</email>\n",xml64];
    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<validate_email> \n"];
    [soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</validate_email> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    NSLog(@"ValidateEmailId_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    
}

-(void) SendSecurityTokenEmail:(NSString *)emailId
{
    rType = enSendMail;
    
    NSData *xmlData = [emailId dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    NSString *xml64 = [NSStringUtil base64StringFromData:xmlData length:xmlData.length]; //Convert PlainXML to Base64 String
    NSString *var = [NSString stringWithFormat:@"<email xsi:type=\"xsd:string\">%@</email>\n",xml64];
    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<send_email> \n"];
    [soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</send_email> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //    NSLog(@"ValidateEmailId_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];
    
}

-(void) XMLDBRecovery:(NSString *)SecurityToken
{
    rType = enValidateSecurityToken;
    NSData *xmlData = [SecurityToken dataUsingEncoding:NSUTF8StringEncoding]; //Convert the string to DATA
    NSString *xml64 = [NSStringUtil base64StringFromData:xmlData length:xmlData.length]; //Convert PlainXML to Base64 String
    NSString *var = [NSString stringWithFormat:@"<token xsi:type=\"xsd:string\">%@</token>\n",xml64];
    
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<xmldb_recovery> \n"];
    [soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</xmldb_recovery> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"XMLDBRecovery_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];

}


-(void)DeleteAccount
{
    Application *appObject = [Application applicationManager];
    
    rType = enDeleteAccount;
    NSString *tempString;
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<deactivate_user> \n"];
    
    
    tempString = [[NSString alloc]initWithFormat:@"<uid xsi:type=\"xsd:int\">%@</uid>",appObject.loyalaz.user.uid];
    [soapEnvelope appendString:tempString];

    
    //[soapEnvelope appendString:var];
    [soapEnvelope appendString:@"</deactivate_user> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
    
    //NSLog(@"process_redemption_SOAP====%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];

    
    
    //NSLog(@"XML==%@",[XMLParser ObjectToXml:appObject.loyalaz]);
}

-(BOOL)ValidateProgramScan:(Program *)prg
{
    BOOL valid = NO;
    
    if([self IsProgramExists:prg.pid]==NO)
    {
        valid=YES;
    }
    else
    {
        Application *appObject = [Application applicationManager];
        if(appObject.loyalaz.programs.count >0)
        {
            for(Program *tempPrg in appObject.loyalaz.programs)
            {
                if([tempPrg.pid isEqualToString:prg.pid])
                {
                    NSString *strDelay = tempPrg.rt;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
                    NSDate *lastScanDate = [formatter dateFromString:tempPrg.s_dt];
                    NSLog(@"%@",lastScanDate);
                    
                    NSDate *current = [NSDate date];
                    NSString *stringDTStamp = [formatter stringFromDate:current];
                    NSDate *currentDate = [[NSDate alloc] init];
                    // voila!
                    currentDate = [formatter dateFromString:stringDTStamp];

                    
                    NSTimeInterval tInt =  [currentDate timeIntervalSinceDate:lastScanDate];
                    if(tInt > [strDelay doubleValue])
                    {
                        valid=YES;
                    }
                    break;
                }
            }
        }
    
    }
    return valid;
}

-(void)DeleteAllFiles
{
    Application *appObject = [Application applicationManager];
    appObject.loyalaz.user = [[User alloc]init];
    [appObject.loyalaz.programs removeAllObjects];
    [appObject.loyalaz.coupons removeAllObjects];
    [Helper SaveObjectToDB:appObject.loyalaz];
    [Helper DeleteAllFiles];
    
}

-(void)GetAdsURL
{
    rType = enGetAds;
    Application *appObject = [Application applicationManager];
    NSString *userTag = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:int\">%@</uid>  \n",appObject.loyalaz.user.uid];
    NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
    [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
    [soapEnvelope appendString:@"<get_ads> \n"];
    [soapEnvelope appendString:userTag];
    [soapEnvelope appendString:@"<device xsi:type=\"xsd:string\">Iphone</device> \n"];
    [soapEnvelope appendString:@"</get_ads> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
//    NSLog(@"SOAP=%@",soapEnvelope);
    
    CommunicationManager *commMgr = [[CommunicationManager alloc]init];
    commMgr.delegate=self;
    [commMgr SendSOAPRequest:soapEnvelope];

}

-(BOOL)RemoveProgram:(Program *)prg
{
    Application *appObject = [Application applicationManager];
    rType = enRemoveProgram;
    if([Helper IsInternetAvailable])
    {
        //Call the web method to delete the programs.

        NSString *userTag = [NSString stringWithFormat:@"<uid xsi:type=\"xsd:float\">%@</uid>  \n",appObject.loyalaz.user.uid];
        NSString *programTag = [NSString stringWithFormat:@"<id xsi:type=\"xsd:float\">%@</id> \n",prg.id];
        
        NSMutableString *soapEnvelope = [[NSMutableString alloc]init];
        [soapEnvelope appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
        [soapEnvelope appendString:@"<SOAP-ENV:Body>\n"];
        [soapEnvelope appendString:@"<remove_userprogram> \n"];
        [soapEnvelope appendString:userTag];
        [soapEnvelope appendString:programTag];
        //[soapEnvelope appendString:var];
        [soapEnvelope appendString:@"</remove_userprogram> </SOAP-ENV:Body></SOAP-ENV:Envelope>\n"];
        
        //NSLog(@"MORE_PRG_SOAP====%@",soapEnvelope);
        
        CommunicationManager *commMgr = [[CommunicationManager alloc]init];
        commMgr.delegate=self;
        [commMgr SendSOAPRequest:soapEnvelope];
        
    }
    else
    {
        //[self DeleteProgramFromXML:prg];
        [self.delegate BusinessLayerDidFinish:YES];
    }
    
    return YES;
}

-(void)DeleteProgramFromXML:(Program *)prg
{

    Application *appObject = [Application applicationManager];
    if([Helper IsInternetAvailable])
    {
        if(appObject.loyalaz.programs.count >0)
        {
//            for(Program *tempPrg in appObject.loyalaz.programs)
//            {
//                if([tempPrg.pid isEqualToString:prg.pid])
//                {
//                    [appObject.loyalaz.programs removeObject:tempPrg];
//                }
//            }

            Program *tempPrg;
            NSMutableIndexSet *deleteIndexes = [[NSMutableIndexSet alloc]init];
            int programCount = appObject.loyalaz.programs.count;
//            NSLog(@"PRG COUNT=%i",programCount);
            for(int i=0;i<programCount;i++)
            {
                tempPrg = [appObject.loyalaz.programs objectAtIndex:i];
                if([tempPrg.pid isEqualToString:prg.pid])
                {
                    [deleteIndexes addIndex:i];
//                    [appObject.loyalaz.programs removeObject:tempPrg];
                }
            }
            [appObject.loyalaz.programs removeObjectsAtIndexes:deleteIndexes];
            
        }
        
        [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.
        
    }
    else
    {
        if(appObject.loyalaz.programs.count >0)
        {
            for(Program *tempPrg in appObject.loyalaz.programs)
            {
                if([tempPrg.pid isEqualToString:prg.pid])
                {
                    tempPrg.active = @"0";
                }
            }
        }
        
        [Helper SaveObjectToDB:appObject.loyalaz]; //save the updated object back to db.

    }
}

#pragma mark - Communication Manager Delegate

// This delegate method will be fired when Communication manager sends the response back here.
- (void)communicationManagerDidFinish:(NSString *)ResponseXML
{
    //NSLog(@"GOT RESPONSE=%@",ResponseXML);
    if(rType==enGetBaseURL)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSData *data = [NSStringUtil base64DataFromString:returnedXML];
        NSString *plainURL = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"BASEURL==%@",plainURL);
        Application *appObject = [Application applicationManager];
        appObject.SOAPURL=plainURL;
        appObject.BaseURLSet = YES;
        [self.delegate BusinessLayerDidFinish:YES];
    }
    else if(rType==RegistrationStep1)
    {
        NSString *uid = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        //NSLog(@"New User ID = %@",uid);
        Application *appObject = [Application applicationManager];
        appObject.loyalaz.user.uid = uid;
        [Helper SaveObjectToDB:appObject.loyalaz];
        [self.delegate BusinessLayerDidFinish:YES];
    }
    else if(rType==SyncXml)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSData *data = [NSStringUtil base64DataFromString:returnedXML];
        NSString *plainXML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"XML_SYNC_RETURNED===%@",plainXML);
        Application *appObject = [Application applicationManager];
        appObject.loyalaz = [XMLParser XmlToObject:plainXML];
        [Helper SaveObjectToDB:appObject.loyalaz];
        //NSLog(@"XMLRETURNED_SYNC===%@",appObject.loyalaz.sync);
        [self UpdateProgramImages];

        [self.delegate BusinessLayerDidFinish:YES];
    }
    else if(rType==enFindPrograms)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSData *data = [NSStringUtil base64DataFromString:returnedXML];
        NSString *plainXML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"XMLRETURNED_MORE===%@",plainXML);
        Application *appObject = [Application applicationManager];
        appObject.morePrograms = [XMLParser XmlToObject:plainXML];
        [self.delegate BusinessLayerDidFinish:YES];        
        //[Helper SaveObjectToDB:appObject.loyalaz];

        
    }
    else if(rType==enFindCoupons)
    {
        NSString *returnedXML = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSData *data = [NSStringUtil base64DataFromString:returnedXML];
        NSString *plainXML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"XMLRETURNED_MORECOUPONS===%@",plainXML);
        Application *appObject = [Application applicationManager];
        appObject.moreCoupons = [XMLParser XmlToObject:plainXML];
        [self.delegate BusinessLayerDidFinish:YES];
        //[Helper SaveObjectToDB:appObject.loyalaz];

        
    }
    else if(rType==enGetCouponNumber)
    {
        NSString *couponNumber = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        //NSLog(@"Coupon Number = %@",couponNumber);
        [self.coupondelegate CouponCodeFinishedWithCouponCode:YES withCouponCode:couponNumber];
    }
    else if(rType==enProcessRedemption)
    {
        NSString *redemptionResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        //NSLog(@"Redemption Return = %@",redemptionResponse);
        if([redemptionResponse isEqualToString:@"1"])
        {
            [self.coupondelegate CouponRedeemCompleted:YES];
        }
        else {
            [self.coupondelegate CouponRedeemCompleted:NO];
        }
        //[self.delegate BusinessLayerDidFinish:YES];
    }
    else  if(rType==enValidateEmailId)
    {
        NSString *validateEmailResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//exists"];
        NSString *validateEmailResponse2 = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//active"];
        NSLog(@"Valid email id=%@",validateEmailResponse2);
        if([validateEmailResponse isEqualToString:@"0"] && [validateEmailResponse2 isEqualToString:@"0"]) // if email doesn't exist
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }
        else
        {
            [self.delegate BusinessLayerDidFinish:YES];
        }
    }
    else  if(rType==enSendMail)
    {
        NSString *sendEmailResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSLog(@"Send email id=%@",sendEmailResponse);
        if([sendEmailResponse isEqualToString:@"0"]) // if email not sent
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }
        else
        {
            [self.delegate BusinessLayerDidFinish:YES];
        }
    }
    else if(rType==enValidateSecurityToken)
    {
        //NSLog(@"XML===%@",ResponseXML);
        
        NSString *tokenResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        //NSLog(@"Valid security token=%@",tokenResponse);
        if([tokenResponse isEqualToString:@"0"])
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }
        else
        {
            NSData *data = [NSStringUtil base64DataFromString:tokenResponse];
            NSString *plainXML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"RECOVERED=%@",plainXML);
            Application *appObject = [Application applicationManager];
            appObject.loyalaz = [XMLParser XmlToObject:plainXML];
            [Helper SaveObjectToDB:appObject.loyalaz];
            rType=enValidateSecurityToken;
            [self UpdateProgramImages];
            [self.delegate BusinessLayerDidFinish:YES];
        }
    }
    else if(rType==enSaveReferBusiness)
    {
        NSString *referResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        if([referResponse isEqualToString:@"1"])
        {
            [self.delegate BusinessLayerDidFinish:YES];
        }
        else
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }
    }
    else if(rType==enAddUserCoupon)
    {
        //NSString *addUserCouponResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        NSString *status = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//status"];
        NSString *qrCodeURL = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//pic_qrcode"];
        //NSLog(@"status=%@",status);
        //NSLog(@"qrcode=%@",qrCodeURL);
        if([status isEqualToString:@"1"])
        {
            //[self.delegate BusinessLayerDidFinish:YES];
            [self.couponQRCodedelegate CouponQRCodeDelegateFinishedWithQRCode:qrCodeURL];
        }
        else
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }
    }
    else if(rType==enDeleteAccount)
    {
        NSString *deleteResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        if([deleteResponse isEqualToString:@"1"])
        {
            [self DeleteAllFiles];
            [self.delegate BusinessLayerDidFinish:YES];
        }
        else
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }
    }
    else if(rType==enRemoveProgram)
    {
        NSLog(@"DELETERESPO=%@",ResponseXML);
        NSString *removeResponse = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return"];
        if([removeResponse isEqualToString:@"1"])
        {
            [self.delegate BusinessLayerDidFinish:YES];
        }
        else
        {
            [self.delegate BusinessLayerDidFinish:NO];
        }

    }
    else if(rType==enGetAds)
    {
        
        NSString *tempStr = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//image"];
        Application *appObj = [Application applicationManager];
        appObj.advertObject.imageURL = [NSURL URLWithString:tempStr];
        
        tempStr = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//link"];
        appObj.advertObject.linkURL =[NSURL URLWithString:tempStr];
        
        tempStr = [XMLParser GetNodeValue:ResponseXML nodePath:@"//return//duration"];
        appObj.advertObject.duration =tempStr;
//        appObj.adsURL = adsResponse;
//        NSLog(@"ADS = %@",adsResponse);
        [self.delegate BusinessLayerDidFinish:YES];
    }
}

// This delegate method will be fired when Communication manager generates error.
- (void)communicationManagerErrorOccurred:(NSError *)err
{
    [self.delegate BusinessLayerErrorOccurred:err];
}

-(NSString *)GetProgramPins:(Program *)programObject
{
    NSMutableString *strPins = [[NSMutableString alloc]init];
    Application *appObject = [Application applicationManager];
    if(appObject.loyalaz.programs.count >0)
    {
        for(Program *tempPrg in appObject.loyalaz.programs)
        {
            if([tempPrg.pid isEqualToString:programObject.pid])
            {
                if([strPins length]>0)
                {
                    [strPins appendString:@","];
                }
                [strPins appendString:tempPrg.pins];
            }
        }
    }
    return strPins;
}



@end
