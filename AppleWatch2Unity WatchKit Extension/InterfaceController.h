//
//  InterfaceController.h
//  AppleWatch2Unity WatchKit Extension
//
//  Created by ible-tech.AceLee on 2020/11/12.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreMotion/CoreMotion.h>
#import <HealthKit/HealthKit.h>

@interface InterfaceController : WKInterfaceController<WCSessionDelegate>

//@IBOutlet weak var label: WKInterfaceLabel!//**2
//let session = WCSession.default//**3

@property (weak) IBOutlet WKInterfaceLabel* label;

@property int i;

@property WCSession *session;

@end
