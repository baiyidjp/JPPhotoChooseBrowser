
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//获取屏幕 宽度、高度
#define JP_SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define JP_SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define JP_KMARGIN 10//默认间距
#define JP_FONTSIZE(x)  [UIFont systemFontOfSize:x]//设置字体大小
#define JP_WEAK_SELF(value) __weak typeof(self) value = self
// 判断是否是iPhone X
#define JP_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define JP_STATUS_BAR_HEIGHT (JP_iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define JP_KNAVHEIGHT (JP_iPhoneX ? 88.f : 64.f)
// tabBar高度
#define JP_TAB_BAR_HEIGHT (JP_iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define JP_HOME_INDICATOR_HEIGHT (JP_iPhoneX ? 34.f : 0.f)


