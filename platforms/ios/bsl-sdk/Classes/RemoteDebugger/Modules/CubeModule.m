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

@implementation CubeModule{
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
}

@end
