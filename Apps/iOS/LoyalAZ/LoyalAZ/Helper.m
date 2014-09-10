//
//  Helper.m
//  LoyalAZ
//

#import "Helper.h"

@implementation Helper



+(NSString *)GetStoragePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}


+(BOOL)SaveFile:(NSString *)fileContents nameOfFile:(NSString*)fileName
{
    BOOL ok=NO;

    NSString *filePath = [self GetStoragePath:fileName];
    NSError *err;
    ok = [fileContents writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    if (!ok) 
    {
        //NSLog(@"PATH=%@",filePath);
        //NSLog(@"Error writing file at %@\n%@",filePath, [err localizedFailureReason]);
    }
    
    return ok;
}

+(NSString*)GetFileContents:(NSString *)fileName
{
    NSString *fileContents;
    NSString *filePath = [self GetStoragePath:fileName];
    NSError *err;
    fileContents = [[[NSString alloc]initWithContentsOfFile:filePath encoding:NSUnicodeStringEncoding error:&err]autorelease];
    return fileContents;
}



+(NSString*)GetXMLHeader
{
    NSMutableString *xmlHeader = [[[NSMutableString alloc]init]autorelease];
    
    [xmlHeader appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
    [xmlHeader appendString:@"<!DOCTYPE loyalaz [\n"];
    [xmlHeader appendString:@"<!ELEMENT loyalaz (user, programs)>\n"];
    [xmlHeader appendString:@"<!ATTLIST loyalaz\n"];
    [xmlHeader appendString:@"sync CDATA #IMPLIED><!-- Indicates on whether or not this local XML DB was synced (saved) back to Server DB, boolean 1=Yes, 0=No -->\n"];
    [xmlHeader appendString:@"<!ELEMENT user EMPTY>\n"];
    [xmlHeader appendString:@"<!ATTLIST user\n"];
    [xmlHeader appendString:@"uid CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"st CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"name CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"firstname CDATA #IMPLIED\n"];
    [xmlHeader appendString:@"lastname CDATA #IMPLIED\n"];
    [xmlHeader appendString:@"email CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"mobilephone CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"addresscity CDATA #IMPLIED\n"];
    [xmlHeader appendString:@"addresscountry CDATA #IMPLIED>\n"];
    [xmlHeader appendString:@"<!ELEMENT programs (program)>\n"];
    [xmlHeader appendString:@"<!ELEMENT program EMPTY>\n"];
    [xmlHeader appendString:@"<!-- act: If 0=no action required, 1=redemption on App start display dialogue box You have FREE reward check My Programs for details -->\n"];
    
    [xmlHeader appendString:@"<!-- 'user' elements and descriptions -->\n"];
    
    [xmlHeader appendString:@"<!-- 'uid' corresponds to cus_customer.id -->\n"];
    [xmlHeader appendString:@"<!-- 'st' security token to authenicate App Customer corresponds to cus_customer.st -->\n"];
    [xmlHeader appendString:@"<!-- 'act' indicates that redemption level is achieved (1) or not (0): checks if pt_balance=pt_target then '1' triggers Redemption event -->\n"];
    [xmlHeader appendString:@"<!-- 'name' is merge of cus_customer.FirstName + cus_customer.LastName -->\n"];
    [xmlHeader appendString:@"<!-- 'firstname' corresponds to cus_customer.FirstName -->\n"];
    [xmlHeader appendString:@"<!-- 'lastname' corresponds to cus_customer.LastName -->\n"];
    [xmlHeader appendString:@"<!-- 'email' corresponds to cus_customer.email -->\n"];
    [xmlHeader appendString:@"<!-- 'mobilephone' corresponds to cus_customer.mobilephone -->\n"];
    [xmlHeader appendString:@"<!-- 'addresscity' corresponds to cus_customer.addresscity -->\n"];
    [xmlHeader appendString:@"<!-- 'addresscountry' corresponds to cus_customer.addresscountry -->\n"];
    [xmlHeader appendString:@"<!-- 'lat' corresponds to cus_customer.lat for customers geolocation -->\n"];
    [xmlHeader appendString:@"<!-- 'lnd' corresponds to cus_customer.lng  for customers geolocation -->\n"];
    
    [xmlHeader appendString:@"<!-- 'program' elements and descriptions -->\n"];
    
    [xmlHeader appendString:@"<!-- 'id' corresponds to cus_customer.id -->\n"];
    [xmlHeader appendString:@"<!-- 'pid' Program GUID – corresponds to the GUID stored in PRG_Program.QRCodeID -->\n"];
    [xmlHeader appendString:@"<!-- 'act' indicates that redemption level is achieved (1) or not (0): checks if pt_balance=pt_target then '1' triggers Redemption event -->\n"];
    [xmlHeader appendString:@"<!-- 'name' program name (as it will be shown to customer), corresponds to prg_program.name -->\n"];
    [xmlHeader appendString:@"<!-- 'tagline' corresponds to cus_customer.FirstName -->\n"];
    [xmlHeader appendString:@"<!-- 'type' corresponds to prg_type.name, should be id really, unless we display in MobApp - 'Per Visit', 'Per Spent' -->\n"];
    [xmlHeader appendString:@"<!-- 'pt_balance' current balance of points DB: 'SUM(trn_rewards.rewardunits) WHERE trn_reards.used Is False AND CustomerID = user.uid AND ProgramID= program.id' -->\n"];
    [xmlHeader appendString:@"<!-- 'pt_target' target points to redemption DB: depending on program.type - prg_programpointsdetails.PointsToRedemption OR prg_programvisitdetails.PaidVisits-->\n"];
    [xmlHeader appendString:@"<!-- 'pic_logo' small logo that will be shown on list view of all programs in MobApp -->\n"];
    [xmlHeader appendString:@"<!-- 'pic_front' full mobile page picture = front of loyalty card -->\n"];
    [xmlHeader appendString:@"<!-- 'pic_back' full mobile page picture = back of loyalty card -->\n"];
    [xmlHeader appendString:@"<!-- 'com_name' corresponds to com_company.name -->\n"];
    [xmlHeader appendString:@"<!-- 'com_web' corresponds to com_company.WebSite and will be used to open Safari browser to company website -->\n"];
    [xmlHeader appendString:@"<!-- 'com_web1' corresponds to com_company.WebSite1 and will be used to open FB a 'like' Company or Program website -->\n"];
    [xmlHeader appendString:@"<!-- 'com_web2' corresponds to com_company.WebSite2 reserved -->\n"];
    [xmlHeader appendString:@"<!-- 'com_phone' corresponds to com_company.phone and willbe used to dial this number from within MobApp -->\n"];
    
    [xmlHeader appendString:@"<!-- 'base' elements and descriptions -->\n"];
    [xmlHeader appendString:@"<!-- 'id' corresponds to id of each mobile transaction, should have fixed values\n"];
    [xmlHeader appendString:@"(1=>webapp logic procedure url for customer registration,\n"];
    [xmlHeader appendString:@"2=>webapp logic procedure url for open app(sync) \n"];
    [xmlHeader appendString:@"3=>webapp logic procedure url for getting coupon no\n"];
    [xmlHeader appendString:@"4=>webapp logic procedure url for reward redemption --> \n"];
    [xmlHeader appendString:@"<!-- 'link' webapp logic procedure url -->\n"];
    [xmlHeader appendString:@"<!-- 'parameter' refers to string of element attributes combined with '&' as parameters to web app logic.  required format parameter=\"attr1=value1&attr2=value2&...\" -->\n"];
    
    [xmlHeader appendString:@"<!-- 'description' refers to description of the link element, should have fixed value\n"];
    [xmlHeader appendString:@"(1=>webapp logic procedure url for customer registration,\n"];
    [xmlHeader appendString:@"2=>webapp logic procedure url for open app(sync) \n"];
    [xmlHeader appendString:@"3=>webapp logic procedure url for getting coupon no\n"];
    [xmlHeader appendString:@"4=>webapp logic procedure url for reward redemption -->\n"];
    
    [xmlHeader appendString:@"<!-- 'source' refers to element in the localXML used to easily locate parameter, required format source=\"element1,element2,[...\"    -->	 \n" ];
    
    
    [xmlHeader appendString:@"<!ATTLIST program\n"];
    [xmlHeader appendString:@"id CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"pid CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"act CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"name CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"tagline CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"type CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"pt_balance CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"pt_target CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"pic_logo CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"pic_front CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"pic_back CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"com_name CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"com_web CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"com_web1 CDATA #IMPLIED\n"];
    [xmlHeader appendString:@"com_web2 CDATA #IMPLIED\n"];
    [xmlHeader appendString:@"com_phone CDATA #REQUIRED>\n"];
    
    
    [xmlHeader appendString:@"<!ATTLIST base\n"];
    [xmlHeader appendString:@"id CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"link CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"parameter CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"desc CDATA #REQUIRED\n"];
    [xmlHeader appendString:@"source CDATA #REQUIRED>\n"];
    [xmlHeader appendString:@"]>\n"];
 

    return xmlHeader;
}

+(NSString*)GetEmptySchema
{
    
    NSMutableString* xmlSchema = [[[NSMutableString alloc]init]autorelease];
    [xmlSchema appendString:@"<LoyalAZ sync=\"\">\n"];
    [xmlSchema appendString:@"<User uid=\"\" st=\"\" name=\"\" firstname=\"\" lastname=\"\" email=\"\" mobilephone=\"\" addressstreet=\"\" addresssuburb=\"\" addresscity=\"\" addresscountry=\"\" lat=\"\" lng=\"\" />\n"];
    [xmlSchema appendString:@"<programs>\n"];
//    [xmlSchema appendString:@"<Program id=\"\" pid=\"\" act=\"\" name=\"\" tagline=\"\" type=\"\" pt_balance=\"\" pt_target=\"\" pic_logo=\"\" pic_bkgrd=\"\" com_id=\"\" com_name=\"\" com_web=\"\" com_phone=\"\" coupon_no=\"\"/>\n"];
    [xmlSchema appendString:@"</programs>\n"];
    [xmlSchema appendString:@"<coupons>\n"];
    [xmlSchema appendString:@"</coupons>\n"];
//    [xmlSchema appendString:@"<moreprograms>\n"];
//    [xmlSchema appendString:@"<mprogram pid=\"\" act=\"\" name=\"\" tagline=\"\" type=\"\" pt_balance=\"\" pt_target=\"\" pic_base=\"\" pic_logo=\"\" pic_front=\"\" pic_back=\"\" com_name=\"\" com_web=\"\" com_web1=\"\" com_web2=\"\" com_phone=\"\"/>\n"];
//    [xmlSchema appendString:@"</moreprograms>\n"];
//    [xmlSchema appendString:@"<urls>\n"];
//    [xmlSchema appendString:@"<base id=\"1\" link=\"\" parameter=\"\" desc=\"\" source=\"\" />\n"];
//    [xmlSchema appendString:@"</urls>\n"];
    [xmlSchema appendString:@"</LoyalAZ>\n"];
    return xmlSchema;
}


+(NSString*)GetTestData
{
    
    NSMutableString* xmlSchema = [[[NSMutableString alloc]init]autorelease];
    [xmlSchema appendString:@"<LoyalAZ sync=\"\">\n"];
    [xmlSchema appendString:@"<User uid=\"15\" st=\"\" name=\"XXX\" firstname=\"AAA\" lastname=\"BBB\" email=\"test@gmail.com\" mobilephone=\"\" addressstreet=\"\" addresssuburb=\"\" addresscity=\"\" addresscountry=\"\" lat=\"\" lng=\"\" />\n"];
    [xmlSchema appendString:@"<programs>\n"];
    [xmlSchema appendString:@"<Program id=\"35\" pid=\"D8668D35-12B1-E576-B818-19BF05E9F07B\" act=\"0\" name=\"Birds all you can\" tagline=\"werewrewr\" type=\"2\" pt_balance=\"1\" pt_target=\"4\" pic_logo=\"\" pic_bkgrd=\"\" com_id=\"18\" com_name=\"Company1\" com_web=\"www.company1.com\" com_phone=\"\" coupon_no=\"\"/>\n"];
    [xmlSchema appendString:@"<Program id=\"36\" pid=\"D8668D35-12B1-E576-B818-19BF05E9F07B\" act=\"0\" name=\"XXXXXXXXXX Burgers\" tagline=\"yyyyyyy\" type=\"2\" pt_balance=\"2\" pt_target=\"9\" pic_logo=\"\" pic_bkgrd=\"\" com_id=\"18\" com_name=\"Company1\" com_web=\"www.company1.com\" com_phone=\"\" coupon_no=\"\"/>\n"];
    [xmlSchema appendString:@"</programs>\n"];
//    [xmlSchema appendString:@"<moreprograms>\n"];
//    [xmlSchema appendString:@"<mprogram pid=\"\" act=\"\" name=\"\" tagline=\"\" type=\"\" pt_balance=\"\" pt_target=\"\" pic_base=\"\" pic_logo=\"\" pic_front=\"\" pic_back=\"\" com_name=\"\" com_web=\"\" com_web1=\"\" com_web2=\"\" com_phone=\"\"/>\n"];
//    [xmlSchema appendString:@"</moreprograms>\n"];
//    [xmlSchema appendString:@"<urls>\n"];
//    [xmlSchema appendString:@"<base id=\"1\" link=\"\" parameter=\"\" desc=\"\" source=\"\" />\n"];
//    [xmlSchema appendString:@"</urls>\n"];
    [xmlSchema appendString:@"</LoyalAZ>\n"];
    
    return xmlSchema;
}

+(id)GetObjectFromDB
{
    id baseObject = nil;
    
    NSString *xmlString = [Helper GetFileContents:@"XMLDB.XML"];
    if(xmlString ==NULL)
    {
        xmlString = [Helper GetEmptySchema]; // GET THE EMPTY SCHEMA
        //xmlString = [Helper GetTestData]; // GET THE TEST SCHEMA
        [Helper SaveFile:xmlString nameOfFile:@"XMLDB.XML"];
    }
    baseObject = [XMLParser XmlToObject:xmlString];
    return baseObject;
}

+(BOOL)SaveObjectToDB:(id)objectToBeSaved
{
    NSString *xmlContents = [XMLParser ObjectToXml:objectToBeSaved];
    BOOL ok = [Helper SaveFile:xmlContents nameOfFile:@"XMLDB.XML"];
//    if(ok)
//        NSLog(@"DB Saved");
//    else
//        NSLog(@"DB Not saved");    
    
    return ok;
    
    
}


+(NSString *)GetDummyResponse
{
    NSMutableString *xmlResponse = [[[NSMutableString alloc]init]autorelease];
    
    [xmlResponse appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"];
    [xmlResponse appendString:@"<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"];
    [xmlResponse appendString:@"<SOAP-ENV:Body>\n"];
    [xmlResponse appendString:@"<ns1:register_userResponse xmlns:ns1=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"];
    [xmlResponse appendString:@"<return xsi:type=\"xsd:int\">14</return>\n"];
    [xmlResponse appendString:@"</ns1:register_userResponse>\n"];
    [xmlResponse appendString:@"</SOAP-ENV:Body>\n"];
    [xmlResponse appendString:@"</SOAP-ENV:Envelope>\n"];
    return xmlResponse;
}


+(void)SaveSettingsToFile:(id)settingsObject;
{

    [NSKeyedArchiver archiveRootObject:settingsObject toFile:[Helper GetStoragePath:@"settings.dat"]];
    
//    if(ret)
//        NSLog(@"Settings Saved");
//    else
//        NSLog(@"Settings Not saved");    

}


+(id)GetSettingsFromFile
{
    id settingsObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[Helper GetStoragePath:@"settings.dat"]];
    return settingsObject;
}

+(void)SaveImageFile:(UIImage *)imageData imageFileName:(NSString *)fileName fileExtension:(NSString *)ext
{
    //BOOL ret = [NSKeyedArchiver archiveRootObject:imageData toFile:[Helper GetStoragePath:fileName]];
    //NSLog(@"EXTENSION=%@",ext);
    BOOL ret;
    if([ext isEqualToString:@"png"])
        ret = [UIImagePNGRepresentation(imageData) writeToFile:[Helper GetStoragePath:fileName] atomically:YES];
    else  if([ext isEqualToString:@"jpg"])
        ret = [UIImageJPEGRepresentation(imageData, 1.0) writeToFile:[Helper GetStoragePath:fileName] atomically:YES];
    
//    if(ret)
//        NSLog(@"Image Saved=%@",fileName);
//    else
//        NSLog(@"Image Not saved");        
}

+(void)DeleteFile:(NSString *)fileName
{
    NSFileManager *fileManager = [[NSFileManager defaultManager]autorelease];
    [fileManager removeItemAtPath:[Helper GetStoragePath:fileName] error:NULL];
}

+(void)DeleteAllFiles
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:documentsDirectory error:&error]) {
        NSLog(@"DELETING FILE : %@",file);
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", documentsDirectory, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

+(NSString *)GetCountriesXML
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filepath =[mainBundle pathForResource:@"countries" ofType:@"xml"];
    NSString *countries = [[[NSString alloc]initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil]autorelease];
    return countries;
}

+(BOOL) IsInternetAvailable
{
    Reachability* hostReach;
    //hostReach = [[Reachability reachabilityWithHostName: @"www.loyalaz.com"] retain];
    hostReach = [[Reachability reachabilityForInternetConnection] retain];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    BOOL status = NO;
    if(netStatus==NotReachable)
    {
        //NSLog(@"Internet not available.");
        status = NO;
    }
    else
    {
        //NSLog(@"Internet is available.");
        status = YES;
    }
    
    return status;
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
