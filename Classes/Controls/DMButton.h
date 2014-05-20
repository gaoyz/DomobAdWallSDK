//
//  DMButton.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/17.
//  Copyright (c) 2014 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMARCMacro.h"

@interface DMButton : UIButton

@property (nonatomic, readwrite) BOOL hasIndicator;
@property (nonatomic, readwrite) CGFloat indicatorWidth;
@property (nonatomic, DM_STRONG) UIColor *indicatorColor;
@property (nonatomic, DM_STRONG) UIImage *image;
@property (nonatomic, DM_STRONG) UIImage *selectedImage;
@property (nonatomic, DM_STRONG) NSString *title;
@property (nonatomic, DM_STRONG) UIColor *titleColor;
@property (nonatomic, DM_STRONG) UIColor *selectedTitleColor;
@property (nonatomic, DM_STRONG) UIColor *buttonBackgroundColor;
@property (nonatomic, DM_STRONG) UIColor *selectedButtonBackgroundColor;

- (id) initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
- (id) initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage indicatorColor:(UIColor *)indicatorColor indicatorWidth:(CGFloat)indicatorWidth;
- (void) setButtonSelected:(NSNumber *)selected;

@end
