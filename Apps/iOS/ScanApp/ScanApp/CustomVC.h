//
//  CustomVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>

@interface CustomVC : UIViewController
{
    UIView *loadingView;
    UIActivityIndicatorView *activityView;
}

- (void) ShowActivityView;
- (void) HideActivityView;

@end
