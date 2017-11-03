# JPPhotoChooseBrowserDemo
仿微信图片选择器

![image](https://github.com/baiyidjp/JPPhotoChooseBrowserDemo/blob/master/JPPhotoChooseBrowserDemo/Image/choosephoto.gif)

![image](https://github.com/baiyidjp/JPPhotoChooseBrowserDemo/blob/master/JPPhotoChooseBrowserDemo/Image/choosephoto1.gif)

### 如何使用?

- 将此文件夹  'JPPhotoChooseBrowser' 整个拖入工程
- 将 'Assets.xcassets' 中的 images 内包含的图片拖入当前项目的 'Assets.xcassets'下
- 在需要使用的控制器中引入头文件  #import "JPPhoto.h"  代理 JPPhotoManagerDelegate
### 方法介绍

```
/**
 单例 使用单例调用启动方法
 @return 单例
 */
+ (JPPhotoManager *)sharedPhotoManager;
```
```
/**
 启动图片选择器 默认最多选择9个
 @param viewController 当前所在的控制器
 */
- (void)openPhotoListWithController:(UIViewController *)viewController;
```
```
/**
 启动图片选择器
 @param viewController 当前所在的控制器
 @param maxImageCount 最大图片选择数(默认可不传,使用上面接口 设为9)
 */
- (void)openPhotoListWithController:(UIViewController *)viewController MaxImageCount:(NSInteger)maxImageCount;
```
### 具体调用


```

//启动图片选择器
[[JPPhotoManager sharedPhotoManager] openPhotoListWithController:self.superViewController MaxImageCount:6];
//设置代理
[JPPhotoManager sharedPhotoManager].delegate = self;

```

### 代理回调 

```
/**
 取消选择图片
 */
- (void)imagePickerControllerDidCancel;

/**
 完成选择图片

 @param thumbImages 缩略图
 @param originalImages 原图
 */
- (void)imagePickerControllerDidFinishPickingMediaWithThumbImages:(NSArray *)thumbImages originalImages:(NSArray *)originalImages;
```




