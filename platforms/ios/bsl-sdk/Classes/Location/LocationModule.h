//
//  LocationModule.h
//  mocha
//
//  Created by Justin Yip on 9/24/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BSLApplication.h"

@interface LocationModule : BSLModule<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;

@end
