//
//  ViewController.h
//  ScanApp
//

#import <UIKit/UIKit.h>
#import "BusinessLayer.h"
#import "CustomVC.h"
#import "HomeVC.h"

@interface ViewController : CustomVC <BusinessLayerDelegate>

{
    
}

@property (nonatomic,strong) IBOutlet UITextField *textUsername;
@property (nonatomic,strong) IBOutlet UITextField *textPassword;

-(IBAction)AuthenticateUser;

@end
