//
//  GameInfoController.m
//  AppleWatch2Unity WatchKit Extension
//
//  Created by ible-tech.AceLee on 2020/11/16.
//

#import "GameInfoController.h"

@interface GameInfoController ()

@end

@implementation GameInfoController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
    }
}

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message {
    
    if(message){
        NSString *contents = [message objectForKey:@"json"];
        NSLog(@"%@",contents);
        
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[contents dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        NSLog(@"%@", json);
    }
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler
{
    
    if(message){
        NSDictionary* response = @{@"response" : [NSString stringWithFormat:@"Message received."]} ;
        
        
        if (replyHandler != nil) replyHandler(response);
        
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


@end



