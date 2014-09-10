//
//  MoreProgramDetailsVC.h
//  LoyalAZ
//

#import "CustomVC.h"
#import "MProgram.h"
#import "BusinessLayer.h"
#import "ProgramsVC.h"
#import "CompanyDetailsVC.h"
#import "Application.h"
#import "Program.h"
#import "ReferBusinessVC.h"
#import "RequestQueue.h"

@interface MoreProgramDetailsVC : CustomVC <UIAlertViewDelegate,PasscodeVCDelegate>
{
    MProgram *selProgram;
    //UIImageView *programImage;
    BOOL flag;
    
    UIImageView *frontImage;
    UIImageView *backImage;
    
    Program *savingProgram;
    
    UIView *containerView;
    
}
//@property (nonatomic,retain) IBOutlet UIImageView *programImage;
@property (nonatomic,retain) IBOutlet UIImageView *frontImage;
@property (nonatomic,retain) IBOutlet UIImageView *backImage;

- (id)initWithNibNameAndProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(MProgram *)selectedProgram;


-(void) InfoClicked;
-(void) AddClicked;
-(void) BackClicked;

- (void) LoadProgramImage;

@end
