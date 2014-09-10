//
//  ScanQR.m
//  LoyalAZ
//

#import "ScanQR.h"
#import "zxing/iphone/ZXingWidget/Classes/QRCodeReader.h"

@implementation ScanQR

@synthesize scandelegate = _scandelegate;

-(void)ScanCode:(UIViewController *)parentController
{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"caf"] isDirectory:NO];
    //[self presentModalViewController:widController animated:YES];
    [parentController presentViewController:widController animated:YES completion:nil];
    [widController release];
    controllerObject = parentController;
}


#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result 
{
    //NSLog(@"Scan completed.");    
    //NSLog(@"QR_STRING_READ=%@",result);
        
    [controllerObject dismissViewControllerAnimated:NO completion:nil];
    [_scandelegate ScanDidFinish:result];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    //NSLog(@"Scan cancelled.");
    [controllerObject dismissViewControllerAnimated:YES completion:nil];
    [_scandelegate ScanDidCancelled];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end
