//
//  CompanyDetailsVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import "CustomVC.h"
#import "Program.h"
#import "MProgram.h"
#import "ReferBusinessVC.h"
#import "FBCommunication.h"


@interface CompanyDetailsVC : CustomVC <UIAlertViewDelegate>
{
    Program *selProgram;
    MProgram *selMProgram;
    NSString *strPhoneNumber;
    
    BOOL flagMProgram;
}

@property (nonatomic,retain) Program *selProgram;
@property (nonatomic,retain) MProgram *selMProgram;
@property (nonatomic,assign) BOOL flagMProgram;

- (id)initWithNibNameAndProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(Program *)selectedProgram;

- (id)initWithNibNameAndMProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(MProgram *)selectedProgram;

-(void)ConfirmPhoneCall;

@end
