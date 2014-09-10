//
//  ProgramCell.h
//  LoyalAZ
//

#import <UIKit/UIKit.h>

@interface ProgramCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewType;
@property (retain, nonatomic) IBOutlet UILabel *labelProgramName;
@property (retain, nonatomic) IBOutlet UILabel *labelProgramDetails;


@end
