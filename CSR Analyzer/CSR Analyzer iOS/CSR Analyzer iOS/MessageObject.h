//
//  MessageObject.h
//  Zap
//
//  Created by Collin Yen on 9/6/13.
//
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

-(id) initWithData: (NSDictionary*) data;
-(id) initWithMessage: (NSString*) message Time: (NSString*) time_stamp Sender: (NSString*) sender;

@property (nonatomic, retain) NSString* m_message;
@property (nonatomic, retain) NSString* m_time_stamp;
@property (nonatomic, retain) NSString* m_sender;

@end
