//
//  DMUtil.m
//  DMAppWall
//
//  Created by Domob Ltd on 2014-1-8.
//  Copyright (c) 2014年 domob. All rights reserved.
//

#import "DMARCMacro.h"
#import "DMUtil.h"

@implementation DMUtil

+ (BOOL)supportiOSVerson:(float)verson {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= verson) {
        
        return YES;
    }else{
        
        return NO;
    }
}

+ (UIImage *)getUIImageFromDMBundleWithImageName:(NSString *)imageName {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"DMAdWallBundle" ofType:@"bundle"];
    NSBundle *domobBundle = [[NSBundle alloc] initWithPath:bundlePath];
    UIImage *tmpImage = DM_SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithContentsOfFile:[domobBundle pathForResource:imageName ofType:@"png"]]);
    return tmpImage;
}

+ (UIImage *)imageNamedFromGameCenterBundle:(NSString *)imageName
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"DMAppWallGameCenter" ofType:@"bundle"];
    NSBundle *domobBundle = [[NSBundle alloc] initWithPath:bundlePath];
    UIImage *tmpImage = DM_SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithContentsOfFile:[domobBundle pathForResource:imageName ofType:@"png"]]);
    return tmpImage;
}

@end

// custom button
@implementation UIButton(DMButton)

+ (UIButton *)buttonWithTitle:(NSString *)title
              backgroundImage:(NSString *)image
               highlightImage:(NSString *)highlightImage
                       target:(id)target
                       action:(SEL)action
                       events:(UIControlEvents)controlEvent {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:title forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
	[button addTarget:target action:action forControlEvents:controlEvent];
	return button;
}

@end


// custom barButton
@implementation UIBarButtonItem(DMBarButtonItem)

+ (UIBarButtonItem *)dmDefaultBackButton:(id)target
                                  action:(SEL)action {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[leftButton setImage:[DMUtil getUIImageFromDMBundleWithImageName:@"dm_NavBtn_close"] forState:UIControlStateNormal];
	[leftButton setImage:[DMUtil getUIImageFromDMBundleWithImageName:@"dm_NavBtn_close"] forState:UIControlStateHighlighted];
	[leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    float width = 15;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7) {
        width = 30;
    }
	leftButton.frame = CGRectMake(0, 0, width, 15);
	UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	return leftbarButton;
}

@end



// custom label
@implementation UILabel(DMLabel)

+ (UILabel *)labelWithRect:(CGRect)rect
                  fontSize:(CGFloat)size
                 textColor:(UIColor *)color {
    
    UILabel *label = DM_SAFE_ARC_AUTORELEASE([[UILabel alloc] initWithFrame:rect]);
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:size];
	label.textColor = color;
	return label;
}

@end



// custom imageView
@implementation UIImageView(DMImageView)

+ (UIImageView *)imageView:(CGRect)frame
                 imageName:(NSString *)imageName {
    
    UIImageView *imageView = DM_SAFE_ARC_AUTORELEASE([[UIImageView alloc] initWithFrame:frame]);
	imageView.image = [UIImage imageNamed:imageName];
	
	return imageView;
}
@end



// custom color
@implementation UIColor(DMColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return nil;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
