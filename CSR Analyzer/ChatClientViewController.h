//
//  ChatClientViewController.h
//  CSR Analyzer iOS
//
//  Created by Enzo La Rocca on 4/12/14.
//  Copyright (c) 2014 LA Hacks. All rights reserved.
//

#import "ViewController.h"

@interface ChatClientViewController: ViewController
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@end
