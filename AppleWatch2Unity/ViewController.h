//
//  ViewController.h
//  AppleWatch2Unity
//
//  Created by ible-tech.AceLee on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController : UIViewController<WCSessionDelegate>

@property (weak) WCSession *session;

@property (weak) IBOutlet UILabel *label;

@property int i;

@end

