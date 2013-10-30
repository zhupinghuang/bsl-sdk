//
//  CubeModule.m
//  Cube
//
//  Created by Justin Yip on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CubeModule.h"
#import "NSFileManager+Extra.h"
#import "JSONKit.h"


@interface CubeModule()
-(void)processTimeEvent;
@end

@implementation CubeModule{
    NSTimer* processTimer;
}

@synthesize pushMsgLink;
@synthesize identifier;
@synthesize name;
@synthesize releaseNote;
@synthesize icon;
@synthesize url;
@synthesize bundle;
@synthesize package;
@synthesize version;
@synthesize build;
@synthesize local;
@synthesize localImageUrl;
@synthesize installed;
@synthesize isDownloading;
@synthesize downloadProgress;
@synthesize installType;
@synthesize hidden;

@synthesize discription;
@synthesize showPushMsgCount;
@synthesize isAutoShow;
@synthesize showIntervalTime;
@synthesize timeUnit;
@synthesize autoDownload;
@synthesize sortingWeight;
@synthesize busiDetail;
@synthesize moduleBadge;

-(id)init{
    self=[super init];
    self.moduleBadge = @"1";
    return self;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"Cube Module[%@|%@]: v%@ - build %d", name, identifier, version , build];
}

-(void)dealloc{
    [processTimer invalidate];
}

- (NSString*)identifierWithBuild{
    //    return [NSString stringWithFormat:@"%@-%d", self.identifier, self.build];
    return self.identifier;
}


- (NSURL*)runtimeURL{
    return [[NSFileManager wwwRuntimeDirectory]
            URLByAppendingPathComponent:[self identifierWithBuild]];
}


-(void)update{
    installType = @"update";
    [self install];
}

-(void)processTimeEvent{
    [processTimer invalidate];
    processTimer=nil;
}


-(BOOL)moduleFileIsExit{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self runtimeURL] path]]) {
        
        return  YES;
    }
    
    return NO;
}

-(BOOL)moduleIsInstalled{
    if([[NSFileManager defaultManager] fileExistsAtPath:[[self runtimeURL] path]]){
        return YES;
    }
    return NO;
}

-(BOOL)uninstall{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self runtimeURL] path]]) {
         [[NSFileManager defaultManager] removeItemAtPath:[[self runtimeURL] path] error:nil];
        return YES;
    }
    return  YES;
}

#pragma mark - Serialization

+(CubeModule*)moduleFromJSONObject:(id)jsonObject{
    CubeModule *module = [[CubeModule alloc] init];
    NSNumber* downNum =   [jsonObject objectForKey:@"autoDownload"];
    module.autoDownload =  [downNum boolValue];
    module.identifier = [jsonObject objectForKey:@"identifier"];
    module.name = [jsonObject objectForKey:@"name"];
    module.releaseNote = [jsonObject objectForKey:@"releaseNote"];
    module.local = [jsonObject objectForKey:@"local"];
    if ([module.local length]>0) {
        module.icon = [NSString stringWithFormat:@"local:%@.png",module.local];
    }else{
        module.icon = [jsonObject objectForKey:@"icon"];
    }
    
    module.bundle = [jsonObject objectForKey:@"bundle"];
    module.package = [jsonObject objectForKey:@"package"];
    module.version = [jsonObject objectForKey:@"version"];
    module.build = [[jsonObject objectForKey:@"build"] integerValue];
    module.installed = [[jsonObject objectForKey:@"installed"] boolValue];
    module.url = [jsonObject objectForKey:@"url"];
    module.localImageUrl = [jsonObject objectForKey:@"localImageUrl"];
    module.category = [jsonObject objectForKey:@"category"];
    module.privileges = [jsonObject objectForKey:@"privileges"];
    
    module.pushMsgLink = [jsonObject objectForKey:@"pushMsgLink"];
    module.discription = [jsonObject objectForKey:@"discription"];
    module.sortingWeight = [[jsonObject objectForKey:@"sortingWeight"] intValue];
    module.isAutoShow = [[jsonObject objectForKey:@"isAutoShow"]boolValue];
    module.busiDetail = [[jsonObject objectForKey:@"busiDetail"]boolValue];
    module.moduleBadge = [jsonObject objectForKey:@"moduleBadge"];
    module.showPushMsgCount = [[jsonObject objectForKey:@"showPushMsgCount"]integerValue];
    module.showIntervalTime = [[jsonObject valueForKey:@"showIntervalTime"] isEqual:[NSNull null] ] ? 0 : [[jsonObject valueForKey:@"showIntervalTime"] integerValue];
    
    module.timeUnit =  [[jsonObject valueForKey:@"timeUnit"] isEqual:[NSNull null] ] ? @"" : [jsonObject valueForKey:@"timeUnit"] ;
    //是否隐藏
    module.hidden =  [[jsonObject objectForKey:@"hidden"] boolValue];
    return module;
}

-(NSMutableDictionary*)dictionary{
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setValue:[NSNumber numberWithBool:self.autoDownload] forKey:@"autoDownload"];
    if([self.identifier length]>0)
        [json setValue:self.identifier forKey:@"identifier"];
    if([self.name length]>0)
        [json setValue:self.name forKey:@"name"];
    if([self.releaseNote length]>0)
        [json setValue:self.releaseNote forKey:@"releaseNote"];
    if([self.icon length]>0)
        [json setValue:self.icon forKey:@"icon"];
    if([self.url length]>0)
        [json setValue:self.url forKey:@"url"];
    if([self.bundle length]>0)
        [json setValue:self.bundle forKey:@"bundle"];
    if([self.bundle length]>0)
        [json setValue:self.package forKey:@"package"];
    if([self.version length]>0)
        [json setValue:self.version forKey:@"version"];
    if([self.category length]>0)
        [json setValue:self.category forKey:@"category"];
    if([self.localImageUrl length]>0)
        [json setValue:self.localImageUrl forKey:@"localImageUrl"];
    [json setValue:[NSNumber numberWithInteger:self.sortingWeight] forKey:@"sortingWeight"];
    [json setValue:[NSNumber numberWithInteger:self.build] forKey:@"build"];
    [json setValue:[NSNumber numberWithBool:self.installed] forKey:@"installed"];
    if([self.local length]>0)
        [json setValue:self.local forKey:@"local"];
    if([self.privileges count]>0)
        [json setValue:self.privileges forKey:@"privileges"];
    if([self.pushMsgLink length]>0)
        [json setValue:self.pushMsgLink forKey:@"pushMsgLink"];
    
    [json setValue:[NSNumber numberWithBool:self.isAutoShow ]forKey:@"isAutoShow"];
    [json setValue:[NSNumber numberWithBool:self.busiDetail ]forKey:@"busiDetail"];
    [json setValue:self.moduleBadge forKey:@"moduleBadge"];
    
    
    
    
    [json setValue:[NSNumber numberWithBool:self.showPushMsgCount] forKey:@"showPushMsgCount"];
    
    //是否隐藏
    [json setValue:[NSNumber numberWithBool:self.hidden] forKey:@"hidden"];
    return json;
}

-(NSURL*)moduleDataDirectory{
    NSURL *mdd = [[NSFileManager applicationDocumentsDirectory] URLByAppendingPathComponent:self.identifier isDirectory:YES];
    BOOL isDir = NO;
    BOOL exists = [FS fileExistsAtPath:[mdd path] isDirectory:&isDir];
    if (!exists || !isDir) {
        NSError *error = nil;
        BOOL success = [FS createDirectoryAtURL:mdd withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) NSLog(@"创建模块[%@]数据目录失败,%@", self.identifier, error);
    }
    return mdd;
}



@end
