//
//  GameInfoController.h
//  AppleWatch2Unity WatchKit Extension
//
//  Created by ible-tech.AceLee on 2020/11/16.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameInfoController : WKInterfaceController<WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *GuidLabel;

@end

NS_ASSUME_NONNULL_END
