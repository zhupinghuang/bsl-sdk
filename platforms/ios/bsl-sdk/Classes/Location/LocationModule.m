//
//  LocationModule.m
//  mocha
//
//  Created by Justin Yip on 9/24/13.
//
//

#import "LocationModule.h"
#import "LocationViewController.h"

@interface LocationModule ()
@property (nonatomic, strong)LocationViewController *locationViewController;

@end


@implementation LocationModule
@synthesize locationManager;
@synthesize locationViewController;

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
    
    self.locationViewController = [[LocationViewController alloc] init];
    self.locationViewController.title = @"Location";
    self.viewController = self.locationViewController;
    
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
