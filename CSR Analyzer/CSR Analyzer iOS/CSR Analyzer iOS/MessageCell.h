//
//  MessageCell.h
//  Zap
//
//  Created by Collin Yen on 12/31/12.
//
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
