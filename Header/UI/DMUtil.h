//
//  DMUtil.h
//  DMAppWall
//
//  Created by Domob Ltd on 2014-1-8.
//  Copyright (c) 2014年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneWidth ([[UIScreen mainScreen] bounds].size.width)
#define iPhoneHeight ([[UIScreen mainScreen] bounds].size.height)
#define DMDefaultStatusBarHeight (20)
#define DMDefaultNavBarHeight (44)
#define DMDefaultTabBarHeight (49)
#define DMDefaultTabHeight (49)
#define DMDefaultTabOffset (DMDefaultStatusBarHeight+DMDefaultNavBarHeight+DMDefaultTabBarHeight)

@interface DMUtil : NSObject

/**
 *  判断设备设备支持的ios版本
 *
 *  @param verson ver
 *
 *  @return BOOL
 */
+ (BOOL)supportiOSVerson:(float)verson;

/**
 *  获取bundle文件中图片
 *
 *  @param imageName imageName
 *
 *  @return image
 */
+ (UIImage *)getUIImageFromDMBundleWithImageName:(NSString *)imageName;

/**
 *  从 Game Center 的 bundle 文件中获取图片
 *
 *  @param imageName imageName
 *
 *  @return image
 */

+ (UIImage *)imageNamedFromGameCenterBundle:(NSString *)imageName;

@end

/**
 *  custom button
 */
@interface UIButton(DMButton)

+ (UIButton *)buttonWithTitle:(NSString *)title
              backgroundImage:(NSString *)image
               highlightImage:(NSString *)highlightImage
                       target:(id)target
                       action:(SEL)action
                       events:(UIControlEvents)controlEvent;



@end


/**
 *  custom barButton
 */

@interface UIBarButtonItem(DMBarButtonItem)

+ (UIBarButtonItem *)dmDefaultBackButton:(id)target
                                  action:(SEL)action;

@end



/**
 *  custom label
 */

@interface UILabel(DMLabel)

+ (UILabel *)labelWithRect:(CGRect)rect
                  fontSize:(CGFloat)size
                 textColor:(UIColor *)color;

@end


/**
 *  custom imageView
 */

@interface UIImageView(DMImageView)

+ (UIImageView *)imageView:(CGRect)frame
                 imageName:(NSString *)imageName;

@end


/**
 *  custom color
 */

@interface UIColor(DMColor)

+ (UIColor *) colorWithHexString: (NSString *)hexString
                           alpha:(float)alpha;

@end
