//
//  ChatClientViewController.m
//  CSR Analyzer iOS
//
//  Created by Enzo La Rocca on 4/12/14.
//  Copyright (c) 2014 LA Hacks. All rights reserved.
//

#import "ChatClientViewController.h"

@interface ChatClientViewController ()


//@property (weak, nonatomic) IBOutlet UITextField *inputNameField;

@end

@implementation ChatClientViewController

/*
- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    
    [inputStream setDelegate: self];
    [outputStream setDelegate:self];
}


- (IBAction)joinChat:(id)sender {
    
    NSLog(@"%s","test");
 
	NSString *response  = [NSString stringWithFormat:@"iam:%@", textField.text];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
 
    
}
 
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self initNetworkCommunication];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
