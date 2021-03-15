//
//  LocationManager.m
//  GBMapKit
//
//  Created by Vitaly Prosvetov on 15.03.2021.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LocationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _manager = [CLLocationManager new];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];
    }
    return self;
}

#pragma mark - Public

- (void)start {
    [self.manager startUpdatingLocation];
}

- (void)stop {
    [self.manager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.manager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Упс!" message:@"Не удалось определить текущий город!" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    
    if (!self.currentLocation) {
        self.currentLocation = [locations firstObject];
        [manager stopUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:self.currentLocation];
    }
}

@end
