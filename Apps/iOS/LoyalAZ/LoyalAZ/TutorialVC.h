//
//  TutorialVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import "Application.h"
#import "RegisterUserVC.h"
#import "GAITrackedViewController.h"
@interface TutorialVC : GAITrackedViewController
{
    int stepIndex;
}

@property (nonatomic,strong) IBOutlet UIButton *buttonNext;
@property (nonatomic,strong) IBOutlet UIButton *buttonBack;
@property (nonatomic,strong) IBOutlet UIButton *buttonSkip;
@property (nonatomic,strong) IBOutlet UIButton *buttonGetStarted;

@property (nonatomic,strong) IBOutlet UIImageView *imageViewStep;

@property (nonatomic,strong) IBOutlet UIImageView *imageViewFindPrograms;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewFindCoupons;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewScan;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewMyPrograms;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewMyCoupons;
@property (nonatomic,strong) IBOutlet UIImageView *imageViewSetup;

@property (nonatomic,strong) IBOutlet UIImageView *imageViewButton;


-(IBAction)ShowNext:(id)sender;
-(IBAction)ShowBack:(id)sender;
-(IBAction)GetStarted:(id)sender;

-(IBAction)SkipTutorial;
-(void)ShowStep;

@end
