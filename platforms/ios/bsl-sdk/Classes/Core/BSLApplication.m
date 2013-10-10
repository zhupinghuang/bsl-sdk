//
//  BSLModule.m
//  mocha
//
//  Created by Justin Yip on 9/24/13.
//
//

#import "BSLApplication.h"
#import <JSONKit/JSONKit.h>

#pragma mark - Application

@interface BSLApplication ()

@property (nonatomic, strong)NSMutableArray *moduleArray;
@property (nonatomic, strong)NSMutableDictionary *moduleDictionary;
@property (nonatomic, strong)NSMutableDictionary *serviceDictionary;

@end

@implementation BSLApplication
@synthesize uiApplication;
@synthesize moduleArray;
@synthesize moduleDictionary;
@synthesize serviceDictionary;

#pragma mark Initialize

-(id)init
{
    //read config file into BSLModule instances
    self = [super init];
    if (self){
        
        self.moduleArray = [[NSMutableArray alloc] init];
        self.moduleDictionary = [[NSMutableDictionary alloc] init];
        self.serviceDictionary = [[NSMutableDictionary alloc] init];
        
        // Do stuff
        NSURL *configURL = [[NSBundle mainBundle] URLForResource:@"bsl" withExtension:@"json"];
        NSData *configData = [NSData dataWithContentsOfURL:configURL];
        id configJSON = [configData objectFromJSONData];
        NSArray *modulesJSON = [configJSON objectForKey:@"modules"];
        for (id moduleJSON in modulesJSON) {
            NSString *moduleName = [moduleJSON objectForKey:@"name"];
            Class moduleClass = NSClassFromString(moduleName);
            BSLModule *m = [[moduleClass alloc] init];
            if (m != nil) {
                m.name = [moduleJSON objectForKey:@"name"];
                m.identifier = [moduleJSON objectForKey:@"identifier"];
                [self.moduleArray addObject:m];
                [self.moduleDictionary setValue:m forKey:m.identifier];
            } else {
                NSLog(@"%@ not exists.", moduleName);
            }
            
        }
    }
    return self;
}

+(BSLApplication *)sharedApplication
{
    static BSLApplication *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BSLApplication alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.uiApplication = application;
    
    NSArray *allModules = [self.moduleDictionary allValues];
    for (BSLModule *m in allModules) {
        if ([m respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [m application:self didFinishLaunchingWithOptions:launchOptions];
        }
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSArray *allModules = [self.moduleDictionary allValues];
    for (BSLModule *m in allModules) {
        if ([m respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [m applicationDidBecomeActive:application];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSArray *allModules = [self.moduleDictionary allValues];
    for (BSLModule *m in allModules) {
        if ([m respondsToSelector:@selector(applicationWillResignActive:)]) {
            [m applicationWillResignActive:application];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSArray *allModules = [self.moduleDictionary allValues];
    for (BSLModule *m in allModules) {
        if ([m respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [m applicationDidEnterBackground:application];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSArray *allModules = [self.moduleDictionary allValues];
    for (BSLModule *m in allModules) {
        if ([m respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [m applicationWillEnterForeground:application];
        }
    }
}



#pragma mark - Provider methods

-(void)registerService:(id)service WithIdentifier:(NSString*)identifier
{
    [serviceDictionary setObject:service forKey:identifier];
}

-(id)serviceForIdentifier:(NSString*)identifier
{
    return [serviceDictionary objectForKey:identifier];
}

-(BSLModule*)moduleForIdentifier:(NSString*)identifier
{
    return [moduleDictionary objectForKey:identifier];
}

-(NSArray*)modules
{
    return self.moduleArray;
}

@end

#pragma mark - Module

@implementation BSLModule
@synthesize identifier, name;
@synthesize viewController;

- (BOOL)application:(BSLApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
{
    NSLog(@"%@ launched.", [[self class] description]);
    return YES;
}

@end