//
//  ModularCDVViewController.m
//  MobileBrick
//
//  Created by Justin Yip on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CubeWebViewController.h"
#import "NSFileManager+Extra.h"
#import "JSONKit.h"

@interface CubeWebViewController (){
    CubeWebViewController *cubeWebViewController;
}

@property (weak,nonatomic) UIAlertView *alertViewLink;

@property (nonatomic, copy) DidFinishPreloadBlock didFinishPreloadBlock;
@property (nonatomic, copy) DidErrorPreloadBlock didErrorPreloadBlock;

@end

@implementation CubeWebViewController

- (id)init{
    self = [super init];
    if (self) {
        
        // Uncomment to override the CDVCommandDelegateImpl used
        _commandDelegate = [[CubeCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [self.alertViewLink dismissWithClickedButtonIndex:0 animated:NO];
    self.alertViewLink=nil;
    [cubeWebViewController.view removeFromSuperview];
    cubeWebViewController=nil;
}


- (void)dealloc{
    [self.alertViewLink dismissWithClickedButtonIndex:0 animated:NO];
    self.alertViewLink=nil;

    [cubeWebViewController.view removeFromSuperview];
    cubeWebViewController=nil;
    if([_commandDelegate respondsToSelector:@selector(setViewController:)])
        [_commandDelegate performSelector:@selector(setViewController:) withObject:nil];
    //[_commandDelegate release];
}

- (void)loadWebPageWithModuleIdentifier:(NSString *)moduleIdentifier didFinishBlock:(DidFinishPreloadBlock)didFinishBlock didErrorBlock:(DidErrorPreloadBlock)didErrorBolock;
{
    
    //NSString* startFilePath = [self.commandDelegate pathForResource:self.startPage];
    
    //startFilePath = [startFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // self.startPage = [NSString stringWithFormat:@"file://%@#%@/",startFilePath,moduleIdentifier];
    
    self.didFinishPreloadBlock = didFinishBlock;
    self.didErrorPreloadBlock = didErrorBolock;
    
    if (!self.webView) {
        
        self.webView.delegate = self;
        
        [self createGapView];
        
    }
}
- (void)loadRequest:(NSURLRequest*)request withFrame:(CGRect)frame didFinishBlock:(DidFinishPreloadBlock)didFinishBlock didErrorBlock:(DidErrorPreloadBlock)didErrorBolock{
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    if (!self.webView) {
        //        self.webView = [self newCordovaViewWithFrame:frame];
        //        self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        //        [self.view addSubview:self.webView];
        //        [self.view sendSubviewToBack:self.webView];
        
        self.webView.delegate = self;
        
        [self createGapView];
    }
    
    self.didFinishPreloadBlock = didFinishBlock;
    self.didErrorPreloadBlock  = didErrorBolock;
    
    [self.webView loadRequest:request];
}

- (void)loadRequest:(NSURLRequest*)request withFrame:(CGRect)frame didFinishBlock:(DidFinishPreloadBlock)didFinishBlock;
{
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];

    if (!self.webView) {
        //        self.webView = [self newCordovaViewWithFrame:frame];
        //        self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        //        [self.view addSubview:self.webView];
        //        [self.view sendSubviewToBack:self.webView];
        
        self.webView.delegate = self;
        
        [self createGapView];
    }
    
    self.didFinishPreloadBlock = didFinishBlock;
    
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL* url = [request URL];

    NSLog(@"请求页面: %@", url);
    if ([@"cube://exit" isEqualToString:[url absoluteString]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

        return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    if ([[url absoluteString] rangeOfString:@"cube-action"].location != NSNotFound) {
        
        NSRange range = [[url absoluteString] rangeOfString:@"cube-action"];
        NSString *tempaction = [[url absoluteString] substringFromIndex:range.location + range.length + 1];
        NSRange sharp = [tempaction rangeOfString:@"#"];
        NSString *action = tempaction;
        if(sharp.length != 0){
            action = [tempaction substringToIndex:sharp.location];
        }
        
        
        if ([@"pop" isEqualToString:action]) {
            if([self.navigationController.viewControllers count]>2){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_DISMISS_VIEW" object:nil];
            }
        } else if([@"push" isEqualToString:action]) {
            
            //remove ?cube-action
            url = [NSURL URLWithString:
                   [[url absoluteString] stringByReplacingOccurrencesOfString:@"?cube-action=push" withString:@""]];
            
            NSString *path = url.path;
            NSRange range = [path rangeOfString:@"www/"];
            if(range.location != NSNotFound){
                path = [path substringFromIndex:range.location + range.length];
                NSRange range2 = [path rangeOfString:@"/"];;
                path = [path substringToIndex:range2.location];
                //dispatch_async(dispatch_get_main_queue(), ^{
                //});
            }
            
            NSURLRequest *newRequest = [NSURLRequest requestWithURL:url cachePolicy:[request cachePolicy] timeoutInterval:[request timeoutInterval]];
            
            [cubeWebViewController.view removeFromSuperview];
            cubeWebViewController=nil;
            cubeWebViewController  = [[CubeWebViewController alloc] init];
            
            cubeWebViewController.webView.scrollView.bounces=NO;
            
            [cubeWebViewController loadWebPageWithUrl: [newRequest.URL absoluteString] didFinishBlock: ^(){
                NSLog(@"加载完毕: %@", [[newRequest URL] absoluteString]);
                
                [self.navigationController pushViewController:cubeWebViewController animated:YES];
                cubeWebViewController=nil;
            }didErrorBlock:^(){
                cubeWebViewController=nil;
            }];
        }
        return NO;
    }
     #if MOBILE_BSL
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ){
        NSString* requestUrlStr  = [[request URL]  absoluteString];
        NSRange range = [requestUrlStr rangeOfString:returnHomeStr];
        
        if([requestUrlStr length] == range.location+range.length){
            closeButton.hidden = YES;
        }else{
            closeButton.hidden = NO;
        }
    }
    #endif
    
    
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}
- (void)loadWebPageWithUrl:(NSString *)fileUrl didFinishBlock:(DidFinishPreloadBlock)didFinishBlock didErrorBlock:(DidErrorPreloadBlock)didErrorBolock;
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    if (fileUrl != nil) {
        self.startPage = fileUrl;
    }
    
    self.didFinishPreloadBlock = didFinishBlock;
    self.didErrorPreloadBlock = didErrorBolock;
    
    if (!self.webView) {
        self.webView.delegate = self;
        [self createGapView];
    }
}

//覆盖默认行为，页面加载完毕后，回调完成方法，用于平滑push
- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    [super webViewDidFinishLoad:theWebView];
    
    if (self.didFinishPreloadBlock) {
        self.didFinishPreloadBlock();
        self.didErrorPreloadBlock = nil;
        self.didFinishPreloadBlock = nil;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [super webView:webView didFailLoadWithError:error];
    if (self.didErrorPreloadBlock) {
        self.didErrorPreloadBlock();
        self.didErrorPreloadBlock = nil;
        self.didFinishPreloadBlock = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
}



-(void)showExitDialog:(id)ignore{
    if(self.alertViewLink == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"是否要退出模块"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
        self.alertViewLink = alertView;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

//        [self.navigationController popToViewController:self.navigationController.topViewController animated:YES];
    }
    self.alertViewLink = nil;
}

@end

@implementation CubeCommandDelegate
@synthesize viewController;

- (id)initWithViewController:(CDVViewController*)vc
{
    self = [super initWithViewController:vc];
    if (self != nil) {
        self.viewController = vc;
    }
    return self;
}


/* To override the methods, uncomment the line in the init function(s)
 in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

/*
 NOTE: this will only inspect execute calls coming explicitly from native plugins,
 not the commandQueue (from JavaScript). To see execute calls from JavaScript, see
 MainCommandQueue below
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

- (NSString*)pathForResource:(NSString*)resourcepath;
{
    return [[[[NSFileManager applicationDocumentsDirectory]
              URLByAppendingPathComponent:self.viewController.wwwFolderName isDirectory:YES]
             URLByAppendingPathComponent:resourcepath] relativePath];
}

@end