//
//  ChatViewController.h
//  CSR Analyzer iOS
//
//  Created by Enzo La Rocca on 4/12/14.
//  Copyright (c) 2014 LA Hacks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController <NSStreamDelegate,UITextFieldDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableArray * messages;
}
@end
