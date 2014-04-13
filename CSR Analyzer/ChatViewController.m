//
//  ChatViewController.m
//  CSR Analyzer iOS
//
//  Created by Enzo La Rocca on 4/12/14.
//  Copyright (c) 2014 LA Hacks. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "MessageObject.h"


// Constants for dynamic message cells
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f
#define NAME_LABEL_HEIGHT 12.0f
#define kOFFSET_FOR_KEYBOARD 50

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
@end

@implementation ChatViewController

@synthesize tableview;
@synthesize textView;
@synthesize sendMessage;
@synthesize message_box_view;

bool keyboard_showing = false;

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
    
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    
    messageArray = [[NSMutableArray alloc] init];
    
    MessageObject* message = [[MessageObject alloc] initWithMessage:@"Hello" Time:@"2013-03-15 12:11:33" Sender:@"Collin"];
    [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
        [messageArray addObject:message];
    

    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableview setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableview reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    keyboard_showing = false;
    
    // Register for keyboard notifications: Used for creating a new message
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessageFunction:(id)sender {
     MessageObject* message = [[MessageObject alloc] initWithMessage:@"Hello" Time:@"2013-03-15 12:11:33" Sender:@"Collin"];
    [messageArray addObject:message];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[messageArray count]-1 inSection:0];
    [tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    keyboard_showing = false;
    [self scroll_down];
    
   [self performSelector:@selector(set_keyboard_showing) withObject:nil afterDelay:0.5];
    self.textView.text = @"";

}

#pragma mark - TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [messageArray count];
}

// Adjusts the height of the cell to the height of the chat message
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MessageObject* message_object = [messageArray objectAtIndex:indexPath.row];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGRect textRect = [message_object.m_message
                       boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17]}
                                         context:nil];
    
    CGSize size = textRect.size;
    
    CGFloat height = MAX(size.height + NAME_LABEL_HEIGHT + 3, 25.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if(cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Message label setup
    
    UIColor* mainColor = [UIColor colorWithRed:50.0/255 green:102.0/255 blue:147.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    UIColor* lightColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    NSString* fontName = @"Optima-Regular";
    NSString* boldFontName = @"Optima-ExtraBlack";
    
    cell.nameLabel.textColor =  mainColor;
    cell.nameLabel.font =  [UIFont fontWithName:boldFontName size:16.0f];
    
    cell.dateLabel.textColor = lightColor;
    cell.dateLabel.font = [UIFont fontWithName:fontName size:14.0f];
    
    cell.messageLabel.textColor = neutralColor;
    cell.messageLabel.font = [UIFont fontWithName:fontName size:FONT_SIZE];
    
    [cell.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.messageLabel setMinimumFontSize:FONT_SIZE];
    [cell.messageLabel setNumberOfLines:0];
    [cell.messageLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [cell.messageLabel setTag:1];
    
    MessageObject* message = [messageArray objectAtIndex:indexPath.row];
    
    // Dynamicallyr resize message label to text size
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGRect textRect = [message.m_message
                       boundingRectWithSize:constraint
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17]}
                       context:nil];
    
    CGSize size = textRect.size;
    
    cell.messageLabel.text = message.m_message;
    [cell.messageLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + NAME_LABEL_HEIGHT, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 25.0f))];
    
    // Conversion of timezone for date and time stamp
    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *utcDate = [df_utc dateFromString:message.m_time_stamp];
    
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *time = [[NSCalendar currentCalendar]
                              components:NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit
                              fromDate:utcDate];
    
    NSDate *now = [[NSDate alloc] init];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit
                                       fromDate:now];
    
    if (([time year]==[nowComponents year])&&([time month]==[nowComponents month])&&([nowComponents day]-[time day]<7)){
        [df_local setDateFormat:@"EEE, h:mm a"];
    }else{
        [df_local setDateFormat:@"MMM d, YYYY"];
        
    }
    NSString* ts_local_string = [df_local stringFromDate:utcDate];
    
    cell.nameLabel.text = message.m_sender;
    cell.dateLabel.text = ts_local_string;
    
    return cell;
}

-(void) set_keyboard_showing
{
    keyboard_showing = true;
}

-(void) scroll_down
{
    // Scroll down the messages
    if (messageArray.count > 0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: messageArray.count-1 inSection: 0];
        [tableview scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

// Method to move the view up/down when the keyboard is shown/dismissed
-(void) setViewMovedUp: (BOOL) movedUp Notification: (NSNotification*) n
{
    
    NSDictionary* userInfo = [n userInfo];
    CGSize size = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    CGRect rect = self.tableview.frame;
    CGRect text_view = self.message_box_view.frame;
    CGFloat offset = size.height - kOFFSET_FOR_KEYBOARD+50;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (movedUp)
    {
        rect.size.height -= offset;
        text_view.origin.y -= offset;
    }
    else
    {
        rect.size.height += offset;
        text_view.origin.y += offset;
        keyboard_showing = false;
    }
    
    self.tableview.frame = rect;
    self.message_box_view.frame = text_view;
    
    [UIView commitAnimations];
    [self scroll_down];
    
    if (movedUp) {
        [self performSelector:@selector(set_keyboard_showing) withObject:nil afterDelay:0.5];
    }
}

-(void)keyboardWillShow: (NSNotification*) n {
    [self setViewMovedUp:YES Notification:n];
}

-(void)keyboardWillHide: (NSNotification*) n {
    [self setViewMovedUp:NO Notification:n];
}

// If user scrolls down when writing a message we want to minimize the text box
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (keyboard_showing == true && scrollView == tableview) {
        NSInteger current_offset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        // If scrolled down then resign the keyboard
        if (maximumOffset - current_offset >= -1000){
            [textView resignFirstResponder];
        }
    }
}
@end
