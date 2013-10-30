//
//  RemoteDebugerModule.m
//  bsl-sdk
//
//  Created by Fanty on 13-10-30.
//
//

#import "RemoteDebugerModule.h"
#import "RemoteDebuggerViewController.h"

@interface RemoteDebugerModule()
@end

@implementation RemoteDebugerModule


-(BOOL)application:(BSLApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options{
    [super application:application didFinishLaunchingWithOptions:options];
    return YES;
}

-(UIViewController*)viewController{
    RemoteDebuggerViewController* remoteDebuggerViewController = [[RemoteDebuggerViewController alloc] init];
    remoteDebuggerViewController.title = @"RemoteDebugg";

    return remoteDebuggerViewController;
}


@end
