//
//  MessageCell.m
//  Zap
//
//  Created by Collin Yen on 12/31/12.
//
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize nameLabel;

@synthesize messageLabel;

@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
