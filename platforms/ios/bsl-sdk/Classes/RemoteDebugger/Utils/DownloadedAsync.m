//
//  DownloadedAsync.m
//  SVW_STAR
//
//  Created by fanty on 13-8-5.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "DownloadedAsync.h"
#import "ThreadTask.h"
#import "AFURLConnectionOperation.h"
#import "SSZipArchive.h"

@interface DownloadedAsync()

-(void)unZipOrFinish;
-(void)callHttp:(int)callIndex;
@end


@implementation DownloadedAsync
@synthesize delegate;
@synthesize downloadSize;
@synthesize totalsize;

-(void)dealloc{
    [self cancel];
}

-(void)start{
    //http 下载
    [self callHttp:0];
}

-(void)cancel{
    [threadTask cancel];
    threadTask=nil;
    [httpRequest cancel];
    httpRequest=nil;
    
}

-(void)close{
    httpRequest=nil;

}


-(void)callHttp:(int)callIndex{
    NSString* filename=[self.downloadPath stringByAppendingString:@".zip"];
    totalsize=100;
    downloadSize=0;
    if([self.delegate respondsToSelector:@selector(process:now:)])
        [self.delegate process:self now:YES];
    
    
    __block DownloadedAsync* async=self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];


    httpRequest=[[AFURLConnectionOperation alloc] initWithRequest:request];
    httpRequest.outputStream=[NSOutputStream outputStreamToFileAtPath:filename append:NO];

    
    [httpRequest setCompletionBlock:^{
        [async close];
        [async unZipOrFinish];

    }];
    
    [httpRequest setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        async.totalsize=totalBytesRead;
        async.downloadSize=totalBytesExpectedToRead;
        if([async.delegate respondsToSelector:@selector(process:now:)])
            [async.delegate process:async now:YES];
    }];
    
    [httpRequest start];

    
    
    
}

-(void)unZipOrFinish{
    if([self.delegate respondsToSelector:@selector(unzipBegin:)])
        [self.delegate unzipBegin:self];
    threadTask=[ThreadTask asyncStart:^{
        @autoreleasepool {
            NSString* zipFile=[self.downloadPath stringByAppendingString:@".zip"];
            [SSZipArchive unzipFileAtPath:zipFile toDestination:self.downloadPath];
            [[NSFileManager defaultManager] removeItemAtPath:zipFile error:nil];
        }
    } end:^{
        threadTask=nil;
        if([self.delegate respondsToSelector:@selector(finish:success:)])
            [self.delegate finish:self success:YES];
        
    }];
}



@end
