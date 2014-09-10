//
//  PasscodeVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import "Program.h"
#import "BusinessLayer.h"

@protocol PasscodeVCDelegate
- (void)PasscodeVerified:(Program *)prg;
- (void)PasscodeDidCancelled;
@end


@interface PasscodeVC : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
{
    int count;
    NSMutableString *passcode;
    NSMutableString *pins;
}

@property (nonatomic,strong) IBOutlet UIImageView *image1;
@property (nonatomic,strong) IBOutlet UIImageView *image2;
@property (nonatomic,strong) IBOutlet UIImageView *image3;
@property (nonatomic,strong) IBOutlet UIImageView *image4;

@property (nonatomic,strong) IBOutlet UITextField *textPass;
@property (nonatomic,strong) Program *program;
    @property (assign,nonatomic) id <PasscodeVCDelegate> delegate;
- (IBAction)confirmPasscode:(id)sender;
- (IBAction)cancelPasscode:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(Program *)prg;

@end
