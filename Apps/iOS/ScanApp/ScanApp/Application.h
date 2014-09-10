//
//  Application.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "ScanApp.h"
#import "Helper.h"

@interface Application : NSObject
{
    ScanApp* scanapp;
}

@property (nonatomic,retain) ScanApp *scanapp;
@property (nonatomic,retain) NSString *SOAPURL;
@property (readwrite,assign) BOOL BaseURLSet;

+ (id)applicationManager;

@end
