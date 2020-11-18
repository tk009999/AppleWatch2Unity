//
//  ViewController.m
//  AppleWatch2Unity
//
//  Created by ible-tech.AceLee on 2020/11/12.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureWatchKitSesstion];
    // Do any additional setup after loading the view.
}

- (void)configureWatchKitSesstion {
    
    if (WCSession.isSupported) {
        self.session = WCSession.defaultSession;
        self.session.delegate = self;
        [self.session activateSession];
    }
}

-(IBAction)tapSendDataToWatch:(id)sender {
    
    if (self.session != nil) {
        
        if (self.session.isReachable) {
            
            ++self.i;
            
            NSString *value = [NSString stringWithFormat:@"Data from iPhone %d", self.i];
            
            NSDictionary<NSString*, id> *data = @{@"iPhone":value};
            
            [self.session sendMessage:data replyHandler:nil errorHandler:nil];
        }
    }
}

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error {
    NSLog(@"activationState: %ld error: %@", (long)activationState, error);
}

-(void)sessionDidBecomeInactive:(WCSession *)session {
    
}

-(void)sessionDidDeactivate:(WCSession *)session {
    
}

-(void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    
    NSLog(@"received message: %@", message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (message[@"watch"] != NULL) {
            self.label.text = message[@"watch"];
        }
    });
}

@end
