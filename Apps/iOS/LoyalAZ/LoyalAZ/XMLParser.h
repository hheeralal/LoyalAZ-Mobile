//
//  XMLParser.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
//#import </usr/include/objc/objc-class.h>
//#import </usr/include/objc/objc-runtime.h>
//#import <objc/objc-class.h>
//#import <objc/objc-runtime.h>
#import <objc/runtime.h>
//#import <objc/objc-runtime.h>
#import "TouchXML.h"


@interface XMLParser : NSObject
{
    
}


+(NSMutableString *)ObjectToXml:(id)targetObject;
+(id)XmlToObject:(NSString *)xmlStringToParse;

+(void)GetObjectVariables:(id)targetObject;

+(void)GetChildNodes:(CXMLNode*)nodeToParse;

+(void)FillObject:(CXMLElement*)elementToParse;

+(NSString *)GetNodeValue:(NSString *)XMLSource nodePath:(NSString *)path;

@end
