//
//  CustomVC.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"


@interface CustomVC : GAITrackedViewController
{
    UIView *loadingView;
    UIActivityIndicatorView *activityView;
}

- (void) ShowActivityView;
- (void) HideActivityView;

@end
