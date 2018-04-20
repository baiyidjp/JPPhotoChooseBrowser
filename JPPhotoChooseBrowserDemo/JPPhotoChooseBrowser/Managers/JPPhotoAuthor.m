//
//  JPPhotoAuthor.m
//  JPPhotoChooseBrowserDemo
//
//  Created by baiyi on 2018/4/20.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "JPPhotoAuthor.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@implementation JPPhotoAuthor

+ (BOOL)isCameraDenied
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isCameraNotDetermined
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (author == AVAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumDenied
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumNotDetermined
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}

+ (void)checkPhotoAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 第一次安装App,还未确定权限,调用这里
        if ([JPPhotoAuthor isPhotoAlbumNotDetermined]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                // 该API从iOS8.0开始支持 // 系统弹出授权对话框
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                            // 用户拒绝,跳转到自定义提示页面
                            NSLog(@"用户拒绝");
                            if (failure) {
                                failure(@"用户拒绝访问相册");
                            }
                        } else if (status == PHAuthorizationStatusAuthorized) {
                            // 用户授权,弹出相册对话框
                            
                            if (success) {
                                success();
                            }
                            
                        } });
                    
                }];
                
            } else {
                // 以上requestAuthorization接口只支持8.0以上,如果App支持7.0及以下,就只能调用这里。
                NSLog(@"iOS 8以下不支持");
                if (failure) {
                    failure(@"iOS 8以下不支持");
                }

            }
            
        } else if ([JPPhotoAuthor isPhotoAlbumDenied]) {
            // 如果已经拒绝,则弹出对话框
            NSLog(@"拒绝访问相册,可去设置隐私里开启");
            if (failure) {
                failure(@"拒绝访问相册,可去设置隐私里开启");
            }

        } else {
            // 已经授权,跳转到相册页面
            NSLog(@"已经授权");
            if (success) {
                success();
            }

        }
        
    } else {
        // 当前设备不支持打开相册
        NSLog(@"当前设备不支持相册");
        if (failure) {
            failure(@"当前设备不支持相册");
        }

    }

}

+ (void)checkCameraAuthorSuccess:(CheckSuccess)success Failure:(CheckFailure)failure {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 第一次安装App,还未确定权限,调用这里
        if ([JPPhotoAuthor isPhotoAlbumNotDetermined]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                // 该API从iOS8.0开始支持 // 系统弹出授权对话框
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                            // 用户拒绝,跳转到自定义提示页面
                            NSLog(@"用户拒绝");
                            if (failure) {
                                failure(@"用户拒绝访问相机");
                            }
                        } else if (status == PHAuthorizationStatusAuthorized) {
                            // 用户授权,弹出相机
                            
                            if (success) {
                                success();
                            }
                            
                        } });
                    
                }];
                
            } else {
                // 以上requestAuthorization接口只支持8.0以上,如果App支持7.0及以下,就只能调用这里。
                NSLog(@"iOS 8以下不支持");
                if (failure) {
                    failure(@"iOS 8以下不支持");
                }
                
            }
            
        } else if ([JPPhotoAuthor isPhotoAlbumDenied]) {
            // 如果已经拒绝,则弹出对话框
            NSLog(@"拒绝访问相机,可去设置隐私里开启");
            if (failure) {
                failure(@"拒绝访问相机,可去设置隐私里开启");
            }
            
        } else {
            // 已经授权
            NSLog(@"已经授权");
            if (success) {
                success();
            }
            
        }
        
    } else {
        // 当前设备不支持打开相机
        NSLog(@"当前设备不支持相机");
        if (failure) {
            failure(@"当前设备不支持相机");
        }
        
    }

    
}

@end
