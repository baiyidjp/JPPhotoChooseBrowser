# JPPhotoChooseBrowserDemo
仿微信图片选择器

![1-相册列表和相片列表](https://raw.githubusercontent.com/baiyidjp/JPPhotoChooseBrowserDemo/master/JPPhotoChooseBrowserDemo/Image/1%E7%9B%B8%E5%86%8C%E5%88%97%E8%A1%A8%E5%92%8C%E7%9B%B8%E7%89%87%E5%88%97%E8%A1%A8.gif)

![2-相片的点击选择](https://raw.githubusercontent.com/baiyidjp/JPPhotoChooseBrowserDemo/master/JPPhotoChooseBrowserDemo/Image/2%E7%9B%B8%E7%89%87%E5%88%97%E8%A1%A8%E7%9A%84%E7%82%B9%E5%87%BB%E9%80%89%E6%8B%A9.giff)

![3-全屏预览](https://github.com/baiyidjp/JPPhotoChooseBrowserDemo/blob/master/JPPhotoChooseBrowserDemo/Image/3%E5%85%A8%E5%B1%8F%E9%A2%84%E8%A7%88.gif?raw=true)

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




