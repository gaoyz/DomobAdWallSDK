//
//  DMButton.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/17.
//  Copyright (c) 2014 Domob Ltd. All rights reserved.
//

#import "DMUtil.h"
#import "DMButton.h"

#define DMDefaultLargeButtonWidth 144
#define DMDefaultButtonWidth 124
#define DMDefaultButtonHeight 50
#define DMDefaultImageLeftMargin 36
#define DMDefaultTitleLeftMargin 73
#define DMDefaultTitleFontSize 16.0f
#define DMDefaultImageLabelSeparatorSize 15.0f
#define DMDefaultIndicatorWidth 3.0f

@interface DMButton()

@property (nonatomic, DM_STRONG) UILabel *internalTitleLabel;
@property (nonatomic, DM_STRONG) UIImageView *internalImageView;
@property (nonatomic, DM_STRONG) UIView *indicator;
@property (nonatomic, DM_STRONG) UIView *separator;

@end

@implementation DMButton

#pragma mark - CycleLife

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setIndicatorWidth:DMDefaultIndicatorWidth];
        [self setIndicatorColor:[UIColor colorWithHexString:@"#5db620" alpha:1.0f]];
        [self setButtonBackgroundColor:[UIColor clearColor]];
        [self setSelectedButtonBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
        [self setTitleColor:[UIColor colorWithHexString:@"#d0d0d0" alpha:1.0f]];
        [self setSelectedTitleColor:self.indicatorColor];
    }

    return self;
}

- (id) initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    if (iPhone5) {
        self = [self initWithFrame:CGRectMake(0, 0, DMDefaultLargeButtonWidth, DMDefaultButtonHeight)];
    }
    else {
        self = [self initWithFrame:CGRectMake(0, 0, DMDefaultButtonWidth, DMDefaultButtonHeight)];
    }
    
    if (self) {
        [self setTitle:title];
        [self setImage:image];
        [self setSelectedImage:selectedImage];
 
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DMDefaultImageLeftMargin, (self.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        [imageView setImage:image];
        [self addSubview:imageView];
        [self setInternalImageView:imageView];
        DM_SAFE_ARC_RELEASE(imageView);
        
        UIFont *font = [UIFont systemFontOfSize:DMDefaultTitleFontSize];
        CGSize size = CGSizeZero;
        
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
#else
        size = [title sizeWithFont:font];
#endif

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDefaultTitleLeftMargin, (self.frame.size.height-size.height)/2, size.width, size.height)];
        [titleLabel setText:title];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"#d0d0d0" alpha:1.0f]];
        [titleLabel setFont:font];
        [self addSubview:titleLabel];
        [self setInternalTitleLabel:titleLabel];
        DM_SAFE_ARC_RELEASE(titleLabel);
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1.0f)];
        [separator setBackgroundColor:[UIColor colorWithHexString:@"#3f3f3f" alpha:1.0f]];
        [self addSubview:separator];
        [self setSeparator:separator];
        DM_SAFE_ARC_RELEASE(separator);
        
        [self.internalImageView setFrame:CGRectMake((self.frame.size.width-image.size.width-size.width-DMDefaultImageLabelSeparatorSize-DMDefaultIndicatorWidth)/2, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
        [self.internalTitleLabel setFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+DMDefaultImageLabelSeparatorSize, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    }
    
    return self;
}

- (id) initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage indicatorColor:(UIColor *)indicatorColor indicatorWidth:(CGFloat)indicatorWidth
{
    if (iPhone5) {
        self = [self initWithFrame:CGRectMake(0, 0, DMDefaultLargeButtonWidth, DMDefaultButtonHeight)];
    }
    else {
        self = [self initWithFrame:CGRectMake(0, 0, DMDefaultButtonWidth, DMDefaultButtonHeight)];
    }
    
    if (self) {
        [self setTitle:title];
        [self setImage:image];
        [self setSelectedImage:selectedImage];
        [self setIndicatorColor:indicatorColor];
        [self setIndicatorWidth:indicatorWidth];
        
        [self setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
        
        UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.indicatorWidth, self.frame.size.height)];
        [indicator setBackgroundColor:self.indicatorColor];
        [self addSubview:indicator];
        [self setIndicator:indicator];
        DM_SAFE_ARC_RELEASE(indicator);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DMDefaultImageLeftMargin, (self.frame.size.height-selectedImage.size.height)/2, selectedImage.size.width, selectedImage.size.height)];
        [imageView setImage:selectedImage];
        [self addSubview:imageView];
        [self setInternalImageView:imageView];
        DM_SAFE_ARC_RELEASE(imageView);
        
        UIFont *font = [UIFont systemFontOfSize:DMDefaultTitleFontSize];
        CGSize size = CGSizeZero;
        
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
#else
        size = [title sizeWithFont:font];
#endif

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDefaultTitleLeftMargin, (self.frame.size.height-size.height)/2, size.width, size.height)];
        [titleLabel setText:title];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:self.indicatorColor];
        [titleLabel setFont:font];
        [self addSubview:titleLabel];
        [self setInternalTitleLabel:titleLabel];
        DM_SAFE_ARC_RELEASE(titleLabel);

        [self.internalImageView setFrame:CGRectMake((self.frame.size.width-image.size.width-size.width-DMDefaultImageLabelSeparatorSize-indicatorWidth)/2, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
        [self.internalTitleLabel setFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+DMDefaultImageLabelSeparatorSize, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    }
    
    return self;
}

- (void)dealloc
{
    DM_SAFE_ARC_SUPER_DEALLOC();

    DM_SAFE_ARC_RELEASE(self.indicatorColor);
    DM_SAFE_ARC_RELEASE(self.image);
    DM_SAFE_ARC_RELEASE(self.selectedImage);
    DM_SAFE_ARC_RELEASE(self.title);
    DM_SAFE_ARC_RELEASE(self.titleColor);
    DM_SAFE_ARC_RELEASE(self.selectedTitleColor);
    DM_SAFE_ARC_RELEASE(self.buttonBackgroundColor);
    DM_SAFE_ARC_RELEASE(self.selectedButtonBackgroundColor);
    DM_SAFE_ARC_RELEASE(self.internalTitleLabel);
    DM_SAFE_ARC_RELEASE(self.internalImageView);
    DM_SAFE_ARC_RELEASE(self.indicator);
    DM_SAFE_ARC_RELEASE(self.separator);
}

#pragma mark - Instance Method

- (void) setButtonSelected:(NSNumber *)selected
{
    [self setSelected:[selected boolValue]];
}

- (void) setSelected:(BOOL)selected
{
    if (self.selected != selected) {
        if (self.selected) {
            [self setBackgroundColor:self.buttonBackgroundColor];

            [self.internalImageView setImage:self.image];
            [self.internalTitleLabel setTextColor:self.titleColor];
            [self.indicator removeFromSuperview];
            DM_SAFE_ARC_RELEASE(self.indicator);
            [self setIndicator:nil];
            [self.separator removeFromSuperview];
            DM_SAFE_ARC_RELEASE(self.separator);
            [self setSeparator:nil];
        }
        else {
            [self setBackgroundColor:self.selectedButtonBackgroundColor];
            
            UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.indicatorWidth, self.frame.size.height)];
            [indicator setBackgroundColor:self.indicatorColor];
            [self addSubview:indicator];
            [self setIndicator:indicator];
            DM_SAFE_ARC_RELEASE(indicator);
            
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1.0f)];
            [separator setBackgroundColor:[UIColor colorWithHexString:@"#3f3f3f" alpha:1.0f]];
            [self addSubview:separator];
            [self setSeparator:separator];
            DM_SAFE_ARC_RELEASE(separator);

            [self.internalImageView setImage:self.selectedImage];
            [self.internalTitleLabel setTextColor:self.selectedTitleColor];
        }
        
        [super setSelected:selected];
    }
}

@end
