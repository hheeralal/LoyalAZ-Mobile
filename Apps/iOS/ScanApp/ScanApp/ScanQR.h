//
//  ScanQR.h
//  LoyalAZ
//

#import <Foundation/Foundation.h>
#import "zxing/iphone/ZXingWidget/Classes/ZXingWidgetController.h"

@class ScanQR;

@protocol ScanQRDelegate
- (void)ScanDidFinish:(NSString *)resultString;
- (void)ScanDidCancelled;
@end


@interface ScanQR : NSObject <ZXingDelegate> 
{
    //NSString *resultsToDisplay;
    UIViewController *controllerObject;
}

@property (assign, nonatomic) id <ScanQRDelegate> scandelegate;

//@property (nonatomic, copy) NSString *resultsToDisplay;


-(void)ScanCode:(UIViewController *)parentController;


@end
