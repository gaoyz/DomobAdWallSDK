//
//  DMLoadingView.m
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2013-10-23.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import "DMARCMacro.h"
#import "DMLoadingView.h"

#define DMDefaultActivityIndicatorSize 17

@interface DMLoadingView() {
    UIActivityIndicatorView *loadingIndicator;
    UILabel *loadingLabel;
    UILabel *unreachableLabel;
    UILabel *reloadingLabel;
}

@end

@implementation DMLoadingView

#pragma mark - CycleLife

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
    }
    
    return self;
}

- (void)dealloc
{
    DM_SAFE_ARC_SUPER_DEALLOC();

    [loadingIndicator stopAnimating];
    DM_SAFE_ARC_RELEASE(loadingIndicator);
    DM_SAFE_ARC_RELEASE(loadingLabel);
    DM_SAFE_ARC_RELEASE(unreachableLabel);
    DM_SAFE_ARC_RELEASE(reloadingLabel);
}

#pragma mark - Instance Method

- (void) showDataLoading
{
    [self removeDataLoading];
    [self removeNetworkUnreachable];

    NSString *label = @"加载中...";
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGSize size = CGSizeZero;
    
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    size = [label sizeWithAttributes:@{NSFontAttributeName:font}];
#else
    size = [label sizeWithFont:font];
#endif

    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [loadingIndicator setFrame:CGRectMake((self.frame.size.width-DMDefaultActivityIndicatorSize-size.width)/2, (self.frame.size.height-DMDefaultActivityIndicatorSize)/2, DMDefaultActivityIndicatorSize, DMDefaultActivityIndicatorSize)];
    [self addSubview:loadingIndicator];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadingIndicator.frame.origin.x+loadingIndicator.frame.size.width+8, loadingIndicator.frame.origin.y, size.width, size.height)];
    [loadingLabel setFont:font];
    [loadingLabel setTextColor:[UIColor colorWithHexString:@"#606060" alpha:1.0f]];
    [loadingLabel setText:label];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:loadingLabel];

    [loadingIndicator startAnimating];
    
    [self setHidden:NO];
    [self setNeedsDisplay];
}

- (void) removeDataLoading
{
    [loadingIndicator stopAnimating];
    [loadingIndicator removeFromSuperview];
    DM_SAFE_ARC_RELEASE(loadingIndicator);
    loadingIndicator = nil;

    [loadingLabel removeFromSuperview];
    DM_SAFE_ARC_RELEASE(loadingLabel);
    loadingLabel = nil;
    
    [self setNeedsDisplay];
    [self setHidden:YES];
}

- (void) removeNetworkUnreachable
{
    [reloadingLabel removeFromSuperview];
    DM_SAFE_ARC_RELEASE(reloadingLabel);
    reloadingLabel = nil;
    
    [unreachableLabel removeFromSuperview];
    DM_SAFE_ARC_RELEASE(unreachableLabel);
    unreachableLabel = nil;
    
    [self setNeedsDisplay];
    [self setHidden:YES];
}

- (void) showNetworkUnreachable
{
    [self removeDataLoading];
    [self removeNetworkUnreachable];

    NSString *label = @"网络不太好哦～";
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGSize size = CGSizeZero;
    
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    size = [label sizeWithAttributes:@{NSFontAttributeName:font}];
#else
    size = [label sizeWithFont:font];
#endif
    
    unreachableLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-size.width)/2, (self.frame.size.height-size.height*2-10)/2, size.width, size.height)];
    [unreachableLabel setFont:font];
    [unreachableLabel setTextColor:[UIColor colorWithHexString:@"#606060" alpha:1.0f]];
    [unreachableLabel setText:label];
    [unreachableLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:unreachableLabel];

    label = @"(点击屏幕重新加载)";
    
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    size = [label sizeWithAttributes:@{NSFontAttributeName:font}];
#else
    size = [label sizeWithFont:font];
#endif
    
    reloadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-size.width)/2, unreachableLabel.frame.origin.y+unreachableLabel.frame.size.height, size.width, size.height)];
    [reloadingLabel setFont:font];
    [reloadingLabel setTextColor:[UIColor colorWithHexString:@"#606060" alpha:1.0f]];
    [reloadingLabel setText:label];
    [reloadingLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:reloadingLabel];

    //add gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [tapGestureRecognizer setDelegate:self];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    DM_SAFE_ARC_RELEASE(tapGestureRecognizer);
    
    [self setHidden:NO];
    [self setNeedsDisplay];
}

- (void) handleTapGesture:(UIGestureRecognizer *)gesture
{
    id delegate = self.delegate;
    
    if (delegate && [delegate respondsToSelector:@selector(reloadData)]) {
        [delegate reloadData];
    }
}

@end
