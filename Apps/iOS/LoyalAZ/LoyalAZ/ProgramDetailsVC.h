//
//  ProgramDetailsVC.h
//  LoyalAZ

#import <UIKit/UIKit.h>
#import "CustomVC.h"
#import "Program.h"
#import "CompanyDetailsVC.h"
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>

@interface ProgramDetailsVC : CustomVC
{
    Program *program;
    BOOL flag;
    
    UIImageView *frontImage;
    UIImageView *backImage;
    
    UIView *containerView;

}

@property (nonatomic,retain) IBOutlet UIImageView *frontImage;
@property (nonatomic,retain) IBOutlet UIImageView *backImage;


- (id)initWithNibNameAndProgram:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProgram:(Program *)selectedProgram;

-(void) InfoClicked;

-(void) BackClicked;

- (void) LoadProgramImage;

//- (IBAction)ImageViewTapped:(id)sender;

@end


