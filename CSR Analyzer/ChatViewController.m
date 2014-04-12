//
//  ChatViewController.m
//  CSR Analyzer iOS
//
//  Created by Enzo La Rocca on 4/12/14.
//  Copyright (c) 2014 LA Hacks. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
@end

@implementation ChatViewController

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField == self.inputNameField)
        [theTextField resignFirstResponder];
    
    return YES;
}

- (IBAction)joinChat:(id)sender {
    
    
    NSLog(@"%@",[NSString stringWithFormat:self.inputNameField.text]);
    
    NSString *response  = [NSString stringWithFormat:@"iam:%@", _inputNameField.text];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
     
}

- (IBAction)sendMessage:(id)sender {
   /*
    NSString *response  = [NSString stringWithFormat:@"msg:%@", inputMessageField.text];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
    */
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"54.215.161.84", 23313, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

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
    [self initNetworkCommunication];
   // self.inputNameField.delegate=self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
