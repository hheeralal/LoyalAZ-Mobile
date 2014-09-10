//
//  Helper.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"
#import "Reachability.h"

@interface Helper : NSObject
{
    
}


+(NSString*)GetXMLHeader;

+(NSString *)GetStoragePath:(NSString*)fileName;

+(BOOL)SaveFile:(NSString *)fileContents nameOfFile:(NSString*)fileName;

+(NSString*)GetFileContents:(NSString*)fileName;

+(NSString*)GetEmptySchema;

+(NSString*)GetTestData;

+(id)GetObjectFromDB;

+(BOOL)SaveObjectToDB:(id)objectToBeSaved;


+(NSString *)GetDummyResponse;

+(void)SaveSettingsToFile:(id)settingsObject;

+(id)GetSettingsFromFile;

+(NSString *)GetCountriesXML;

+(void)SaveImageFile:(UIImage *)imageData imageFileName: (NSString *)fileName fileExtension:(NSString *)ext;

+(void)DeleteFile:(NSString *)fileName;

+(BOOL) IsInternetAvailable;

+(void)DeleteAllFiles;

+ (UIColor *)colorFromHexString:(NSString *)hexString;



@end
