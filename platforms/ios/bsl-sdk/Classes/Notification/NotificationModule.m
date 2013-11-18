//
//  NotificationModule.m
//  bsl-sdk
//
//  Created by Fanty on 13-11-18.
//
//

#import "NotificationModule.h"
#import "NotificationMainViewController.h"

@implementation NotificationModule

-(BOOL)application:(BSLApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options{
    [super application:application didFinishLaunchingWithOptions:options];
    return YES;
}

-(UIViewController*)viewController{
    NotificationMainViewController* controller = [[NotificationMainViewController alloc] init];
    controller.title = @"Notification";
    
    return controller;
}


@end
