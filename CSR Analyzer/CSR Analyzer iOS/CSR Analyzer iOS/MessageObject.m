//
//  MessageObject.m
//  Zap
//
//  Created by Collin Yen on 9/6/13.
//
//

#import "MessageObject.h"


@implementation MessageObject
@synthesize m_message;
@synthesize m_sender;
@synthesize m_time_stamp;

-(id) initWithData:(NSDictionary *)data{
    self = [super init];
    
    if (self) {
        NSString* message = [data objectForKey:@"message"];
        NSString* sender = [data objectForKey:@"user"];
        NSString* time_stamp = [data objectForKey:@"time"];
        
        if (message == nil) {
            message = @"";
        }else{
            message = [message stringByReplacingOccurrencesOfString:@"\\'" withString:@"\'"];
            message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        }
        if (sender == nil) {
            sender = @"";
        }
        if (time_stamp == nil) {
            time_stamp = @"";
        }
        
        self.m_message = message;
        self.m_sender = sender;
        self.m_time_stamp = time_stamp;
        
    }
            
    return self;
}

-(id) initWithMessage: (NSString*) message Time: (NSString*) time_stamp Sender: (NSString*) sender
{
    self = [super init];
    
    if (self) {
        self.m_message = message;
        self.m_time_stamp = time_stamp;
        self.m_sender = sender;
    }
    
    return self;
}

@end
