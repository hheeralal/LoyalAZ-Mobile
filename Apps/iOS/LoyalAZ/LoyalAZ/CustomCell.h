//
//  CustomCell.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

{
    IBOutlet UIImageView *imageLogo;
    IBOutlet UILabel *name;
    IBOutlet UILabel *description;
    IBOutlet UILabel *distance;
    IBOutlet UIImageView *imageCouponType;
}

@property (nonatomic,strong) IBOutlet UIImageView *imageLogo;
@property (nonatomic,strong)IBOutlet UILabel *name;
@property (nonatomic,strong)IBOutlet UILabel *description;
@property (nonatomic,strong)IBOutlet UILabel *distance;
@property (nonatomic,strong)IBOutlet UIImageView *imageCouponType;

@end
