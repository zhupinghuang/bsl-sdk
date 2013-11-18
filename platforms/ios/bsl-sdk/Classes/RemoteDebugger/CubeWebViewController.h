//
//  ModularCDVViewController.h
//  MobileBrick
//
//  Created by Justin Yip on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
typedef void (^DidFinishPreloadBlock)(void);
typedef void (^DidErrorPreloadBlock)(void);
@interface CubeWebViewController : CDVViewController <UIAlertViewDelegate>

- (void)loadWebPageWithUrl:(NSString *)fileUrl didFinishBlock:(DidFinishPreloadBlock)didFinishBlock didErrorBlock:(DidErrorPreloadBlock)didErrorBolock;

@end

@interface CubeCommandDelegate : CDVCommandDelegateImpl
@property(nonatomic, weak)CDVViewController* viewController;
@end
