//
//  DMLoadingView.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2013-10-23.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMUtil.h"

@protocol DMLoadingViewDelegate <NSObject>

- (void) reloadData;

@end

@interface DMLoadingView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<DMLoadingViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame;

- (void) showDataLoading;
- (void) removeDataLoading;
- (void) showNetworkUnreachable;

@end
