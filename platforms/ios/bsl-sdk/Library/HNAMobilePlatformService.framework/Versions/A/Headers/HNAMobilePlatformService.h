//
//  HNAMobilePlatformService.h
//  HNAMobilePlatform
//
//  Created by guolu on 13-7-30.
//  Copyright (c) 2013年 guolu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef enum _systemLanguage{
    
    EKCHN = 1,
    EKENG = 2
    
}EKSystemLanguage;

@protocol HNAMobilePlatformServiceDelegate <NSObject>
@optional

-(void)getDataOnSuccess:(NSString*)xmlString;
-(void)getDataOnFailed:(NSError*)error;
-(void)returnRequestStatus:(NSString*)message;
-(void)getLoginReturnData:(NSDictionary*)data;
-(void)getUserInfoReturnData:(NSDictionary*)data;

//2013-09-10
//在此代理方法中使应用退到登录页面
-(void)loginCheckFailed;

@end

@interface HNAMobilePlatformService : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate>{
    
    id<HNAMobilePlatformServiceDelegate>delegate;
    NSInteger langTag;           //1:中文;2:英文及其它语言
    NSString *_deviceToken;      //用于推送的device token值
}

@property(nonatomic,assign)id<HNAMobilePlatformServiceDelegate>delegate;
@property(nonatomic,assign)NSInteger langTag;
@property(nonatomic,retain)NSString *_deviceToken;
@property(nonatomic,retain)NSString *ekLatitude;   //纬度
@property(nonatomic,retain)NSString *ekLongitude;  //经度
@property(nonatomic,retain)NSString *ekDeviceId;
@property(nonatomic,assign)NSInteger activeTag;



+(void)initializeWithLanguage:(EKSystemLanguage)tag;
+(void)checkInfoWhenAppBecomeActive;
+(void)whenAppResignActive;

//同步请求数据
+(void)requestWSDataBySychronous:(NSString*)routeName Account:(NSString*)account AppID:(NSString*)appID AppVer:(NSString*)appVer Parameters:(NSString*)param delegate:(id)delegate;


//异步请求数据
+(void)requestWSDataByAsychronous:(NSString *)routeName Account:(NSString*)account AppID:(NSString*)appID AppVer:(NSString*)appVer Parameters:(NSString *)param delegate:(id)delegate;

//登录处理
//同步网络调用登录方法
+(void)userLoginBySychronous:(NSString*)userAccount withPassword:(NSString*)password delegate:(id)delegate;

//异步网络调用登录方法
+(void)userLoginByAsychronous:(NSString*)userAccount withPassword:(NSString*)password delegate:(id)delegate;

//2013-09-10
//添加新的登陆处理模式：受管控app登录完成后，返回其登陆结果给管控服务器，并接收和处理管控服务器返回结果
//异步网络调用模式
+(void)feedBackLoginResultToServer:(NSString*)userAccount Passed:(BOOL)pass delegate:(id)delegate;

//获取用户详细人事信息
//同步网络调用方法
+(void)getUserDatailInfoBySychronous:(NSString*)userAccount delegate:(id)delegate;
//异步网络调用方法
+(void)getUserDatailInfoByAsychronous:(NSString*)userAccount delegate:(id)delegate;

//登录结果回传,成功LoginCode为0，失败LoginCode为1
+(void)sendLoginResultToWebService:(NSString*)userAccount LoginCode:(NSInteger)loginCode LoginResult:(NSString*)loginResult;

//更新上传设备token值
//异步调用方式
+(void)updateDeviceTokenForPushNotificationByAsychronous:(NSString*)token withLanguage:(NSString*)language;

//系统语言版本更换
+(void)setSystemLanguage:(EKSystemLanguage)tag;  //CN代表中文；EN代表英文

//获取纬度值
+(NSString*)getLatitude;
//获取经度值
+(NSString*)getLongitude;

//添加信息到通讯录
+(void)addPersonInfoToContacts:(NSString*)name MainPhoneNo:(NSString*)mainNo MobilePhoneNo:(NSString*)mobileNo Email:(NSString*)email PersonImage:(UIImage*)image;



@end
