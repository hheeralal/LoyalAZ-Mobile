//
//  DataRecoveryVC.h
//  LoyalAZ
//

#import "CustomVC.h"
#import "BusinessLayer.h"

@protocol DataRecoveryVCDelegate
- (void)DataRecoveryVCDidFinish;
- (void)DataRecoveryVCDidCancelled;
@end

@interface DataRecoveryVC : CustomVC <BusinessLayerDelegate>
{
    IBOutlet UIButton *buttonDone;
    IBOutlet UITextField *textToken;
}



@property (assign,nonatomic) id <DataRecoveryVCDelegate> delegate;

-(IBAction)doneClicked;
-(IBAction)cancelClicked;
-(void)ValidateSecurityToken;

@end
