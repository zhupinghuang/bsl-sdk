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

@property (nonatomic, strong)NSMutableDictionary *moduleDictionary;
@property (nonatomic, strong)NSMutableDictionary *serviceDictionary;

@end

@implementation BSLApplication
@synthesize uiApplication;
@synthesize moduleDictionary;
@synthesize serviceDictionary;

#pragma mark Initialize

-(id)init
{
    //read config file into BSLModule instances
    self = [super init];
    if (self){
        
        self.moduleDictionary = [[NSMutableDictionary alloc] init];
        self.serviceDictionary = [[NSMutableDictionary alloc] init];
        
        // Do stuff
        NSURL *configURL = [[NSBundle mainBundle] URLForResource:@"bsl" withExtension:@"json"];
        NSData *configData = [NSData dataWithContentsOfURL:configURL];
        id configJSON = [configData objectFromJSONData];
        NSArray *modulesJSON = [configJSON arrayForKey:@"modules"];
        for (id moduleJSON in modulesJSON) {
            NSString *moduleName = [moduleJSON stringForKey:@"name"];
            Class moduleClass = NSClassFromString(moduleName);
            BSLModule *m = [[moduleClass alloc] init];
            if (m != nil) {
                m.identifier = [moduleJSON stringForKey:@"identifier"];
                [self.moduleDictionary setValue:m forKey:m.identifier];
            } else {
                NSLog(@"%@ not exists.", moduleName);
            }
            
        }
    }
    return self;
}

+(BSLApplication *)sharedManager
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
        [m application:self didFinishLaunchingWithOptions:launchOptions];
    }
    
    return YES;
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