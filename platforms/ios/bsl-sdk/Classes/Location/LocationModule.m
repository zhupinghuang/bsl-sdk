//
//  LocationModule.m
//  mocha
//
//  Created by Justin Yip on 9/24/13.
//
//

#import "LocationModule.h"


@implementation LocationModule
@synthesize locationManager;

-(BOOL)application:(BSLApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options
{
    [super application:application didFinishLaunchingWithOptions:options];
    
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    
//    [application registerService:self.locationManager WithIdentifier:@"locationManager"];
//    
//    [self.locationManager startUpdatingLocation];
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location update: %@", locations);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location fail. %@", error);
}

@end
