//
//  ChatViewController.h
//  CSR Analyzer iOS
//
//  Created by Enzo La Rocca on 4/12/14.
//  Copyright (c) 2014 LA Hacks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController <NSStreamDelegate,UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableArray * messages;
    NSMutableArray* messageArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *sendMessage;

- (IBAction)sendMessageFunction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *message_box_view;

@end
