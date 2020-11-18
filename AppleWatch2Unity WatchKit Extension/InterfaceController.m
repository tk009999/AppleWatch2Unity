//
//  InterfaceController.m
//  AppleWatch2Unity WatchKit Extension
//
//  Created by ible-tech.AceLee on 2020/11/12.
//

#import "InterfaceController.h"


@interface InterfaceController ()

@property CMAccelerometerData* returnedData;
@property CMMotionManager* motionManager;
@property CMGyroData* gyroData;
@property HKElectrocardiogram* hkeDiogram;
@property HKHealthStore *healthStore;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    // Configure interface objects here.
    
    if(WCSession.isSupported){
        self.i = 0;
        self.session = WCSession.defaultSession;
        self.session.delegate = self;
        [self.session activateSession];
    }
    
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    
    _healthStore = [[HKHealthStore alloc] init];

    _returnedData = [[CMAccelerometerData alloc] init];
    _motionManager = [[CMMotionManager alloc] init];
    
    _motionManager.deviceMotionUpdateInterval = 1.0/50;
    
    [_motionManager startDeviceMotionUpdatesToQueue:theQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        if (error != NULL) {
            return;
        }
        
        if (motion != NULL)        {
            [self processDeviceMotion: motion];
        }
    }];

//    [_motionManager startAccelerometerUpdatesToQueue:theQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//
//        self.returnedData = self.motionManager.accelerometerData;
//
//        int accX = self.returnedData.acceleration.x;
//        int accY = self.returnedData.acceleration.y;
//
//        NSLog(@"X: %i, Y: %i", accX, accY);
//
//        NSString *value = [NSString stringWithFormat:@"X: %i, Y: %i", accX, accY];
//
//        NSDictionary<NSString*, id> *data = @{@"watch":value};
//
//        [self.session sendMessage:data replyHandler:nil errorHandler:nil];
//    }];
    
//    if ([_motionManager isGyroAvailable] == YES) {
//
//        [_motionManager startGyroUpdatesToQueue:theQueue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
//
//            self.gyroData = self.motionManager.gyroData;
//
//            double gyroX = gyroData.rotationRate.x;
//            double gyroY = gyroData.rotationRate.y;
//            double gyroZ = gyroData.rotationRate.z;
//
//            NSLog(@"gyroX %f, gyroY %f, gyroZ %f,", gyroX, gyroY, gyroZ);
//
//            NSString *value = [NSString stringWithFormat:@"gyroX %f, gyroY %f, gyroZ %f,", gyroX, gyroY, gyroZ];
//
//            NSDictionary<NSString*, id> *data = @{@"watch":value};
//
//            [self.session sendMessage:data replyHandler:nil errorHandler:nil];
//        }];
//    }
}

-(void) processDeviceMotion:(CMDeviceMotion *)deviceMotion {
    double gyroX = deviceMotion.rotationRate.x;
    double gyroY = deviceMotion.rotationRate.y;
    double gyroZ = deviceMotion.rotationRate.z;
    
    NSLog(@"gyroX %f, gyroY %f, gyroZ %f,", gyroX, gyroY, gyroZ);
    
    NSString *value = [NSString stringWithFormat:@"gyroX %f, gyroY %f, gyroZ %f,", gyroX, gyroY, gyroZ];
    
    NSDictionary<NSString*, id> *data = @{@"watch":value};
    
    [self.session sendMessage:data replyHandler:nil errorHandler:nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

//@IBAction func tapSendToiPhone() {//**6
//    let data: [String: Any] = ["watch": "data from watch" as Any] //Create your dictionary as per uses
//    session.sendMessage(data, replyHandler: nil, errorHandler: nil) //**6.1
//  }
- (IBAction)tapSendToiPhone {
    
//    if (self.session != nil) {
//
//        if (self.session.isReachable) {
//
//            ++self.i;
//
//            NSString *value = [NSString stringWithFormat:@"Data from watch %d", self.i];
//
//            NSDictionary<NSString*, id> *data = @{@"watch":value};
//
//            [self.session sendMessage:data replyHandler:nil errorHandler:nil];
//        }
//    }
    
    HKElectrocardiogramType* ecgType = HKObjectType.electrocardiogramType;
    
    HKSampleQuery* ecgQuery = [[HKSampleQuery  alloc]
     initWithSampleType: ecgType predicate:nil limit: HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {

        if (results != NULL){
            
            for (HKElectrocardiogram* sample in  (NSArray<HKElectrocardiogram *> *)  results) {
                
                HKElectrocardiogramQuery* voltageQuery = [[HKElectrocardiogramQuery alloc] initWithElectrocardiogram: sample dataHandler:^(HKElectrocardiogramQuery * _Nonnull query, HKElectrocardiogramVoltageMeasurement * _Nullable voltageMeasurement, BOOL done, NSError * _Nullable error) {
                   
                    if (error != NULL) {
                        NSLog(@"%@", error);
                        return;
                    }
                    
                    if (done) {
                        return;;
                    }
                    
                    [self Procress:query voltageMeasurement:voltageMeasurement];
                    
                }];
                
                [self->_healthStore executeQuery: voltageQuery];
            }
        }

    }];
        
    [_healthStore executeQuery: ecgQuery];
}

-(void)Procress:(HKElectrocardiogramQuery * _Nonnull)query voltageMeasurement:(HKElectrocardiogramVoltageMeasurement * _Nullable)voltageMeasurement {
    
    HKQuantity* voltageQuantity = [voltageMeasurement quantityForLead: HKElectrocardiogramLeadAppleWatchSimilarToLeadI];
     
    NSLog(@"voltage %f", [voltageQuantity doubleValueForUnit: HKUnit.countUnit]);
}

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error {
    NSLog(@"activationState: %ld error: %@", (long)activationState, error);
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {

    NSLog(@"received message: %@", message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (message[@"iPhone"] != NULL) {
            self.label.text = message[@"iPhone"];
        }
    });
    
}


@end



