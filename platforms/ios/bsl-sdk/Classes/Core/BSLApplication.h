//
//  BSLModule.h
//  mocha
//
//  Created by Justin Yip on 8/22/13.
//
//

#import <Foundation/Foundation.h>

@class BSLModule;

//
// BSL Application
//
//
@interface BSLApplication : NSObject<UIApplicationDelegate>
@property(nonatomic, weak)UIApplication *uiApplication;

+(BSLApplication *)sharedManager;
//register a service instance
-(void)registerService:(id)service WithIdentifier:(NSString*)identifier;
//obtain a service
-(id)serviceForIdentifier:(NSString*)identifier;
//obtain a module
-(BSLModule*)moduleForIdentifier:(NSString*)identifier;

@end



#pragma mark - Module

//
// BSL Module, Devide iOS App into modules.
// BSLModule is awared of the full application life cycle
//
@interface BSLModule : NSObject<UIApplicationDelegate>

//module infomation
@property(nonatomic, strong)NSString *identifier;
@property(nonatomic, strong)NSString *name;

//obtain the ViewController represent for this Module, can be nil
@property(nonatomic, readonly)UIViewController *viewController;

#pragma mark - Module Lifecycle
//this method will be called when the application finish launch, the module should initialize itself
- (BOOL)application:(BSLApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;

@end