//
//  UnityWatchConnectivity.m
//  AppleWatch2Unity
//
//  Created by ible-tech.AceLee on 2020/11/16.
//

#import "UnityWatchConnectivity.h"

@implementation UnityWatchConnectivity

static UnityWatchConnectivity *connectivity = nil;
static WCSession *session = nil;

// Converts C style string to NSString
NSString* CreateNSString (const char* string)
{
    if (string)
        return [NSString stringWithUTF8String: string];
    else
        return [NSString stringWithUTF8String: ""];
}

extern "C" {

    void _SendMessage (const char* content)
    {
        if (connectivity == nil){
            connectivity = [[UnityWatchConnectivity alloc] init];
        }

        if(WCSession.isSupported){
            session = WCSession.defaultSession;
            session.delegate = connectivity;
            [session activateSession];
        }

        [session sendMessage:@{CreateNSString("json") : CreateNSString(content) } replyHandler:nil errorHandler:nil];
    }
    void _RecievedMessage (const char* content)
    {
        NSLog(@"_ReceivedMessage");
    }
}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    
}

- (void)sessionDidBecomeInactive:(nonnull WCSession *)session {

}

- (void)sessionDidDeactivate:(nonnull WCSession *)session {
    
}

@end
