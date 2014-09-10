//
//  ProgramCell.m
//  LoyalAZ
//

#import "ProgramCell.h"

@implementation ProgramCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    NSLog(@"Hello");
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imageViewLogo release];
    [_imageViewType release];
    [_labelProgramName release];
    [_labelProgramDetails release];
    [super dealloc];
}
@end
