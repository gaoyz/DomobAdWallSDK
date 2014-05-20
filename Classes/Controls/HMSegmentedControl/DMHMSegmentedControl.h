//
//  DMHMSegmentedControl.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/14.
//  Copyright (c) 2014 Domob Ltd. All rights reserved.
//

#import "DMARCMacro.h"

//
//  DMHMSegmentedControl.h
//  DMHMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

typedef enum {
    DMHMSegmentedControlSelectionStyleTextWidthStripe, // Indicator width will only be as big as the text width
    DMHMSegmentedControlSelectionStyleFullWidthStripe, // Indicator width will fill the whole segment
    DMHMSegmentedControlSelectionStyleBox
} DMHMSegmentedControlSelectionStyle;

typedef enum {
    DMHMSegmentedControlSelectionIndicatorLocationUp,
    DMHMSegmentedControlSelectionIndicatorLocationDown,
	DMHMSegmentedControlSelectionIndicatorLocationNONE
} DMHMSegmentedControlSelectionIndicatorLocation;

typedef enum {
    DMHMSegmentedControlSegmentWidthStyleFixed, // Segment width is fixed
    DMHMSegmentedControlSegmentWidthStyleDynamic, // Segment width will only be as big as the text width (including inset)
} DMHMSegmentedControlSegmentWidthStyle;

enum {
    DMHMSegmentedControlNoSegment = -1   // segment index for no selected segment
};

typedef enum {
    DMHMSegmentedControlTypeText,
    DMHMSegmentedControlTypeImages,
	DMHMSegmentedControlTypeTextImages
} DMHMSegmentedControlType;

@interface DMHMSegmentedControl : UIControl

@property (nonatomic, DM_STRONG) NSArray *sectionTitles;
@property (nonatomic, DM_STRONG) NSArray *sectionImages;
@property (nonatomic, DM_STRONG) NSArray *sectionSelectedImages;

/*
 Provide a block to be executed when selected index is changed.
 
 Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/*
 Font for segments names when segmented control type is `DMHMSegmentedControlTypeText`
 
 Default is [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f]
 */
@property (nonatomic, DM_STRONG) UIFont *font;

/*
 Text color for segments names when segmented control type is `DMHMSegmentedControlTypeText`
 
 Default is [UIColor blackColor]
 */
@property (nonatomic, DM_STRONG) UIColor *textColor;

/* 
 Text color for selected segment name when segmented control type is `DMHMSegmentedControlTypeText`
 
 Default is [UIColor blackColor]
 */
@property (nonatomic, DM_STRONG) UIColor *selectedTextColor;

/*
 Segmented control background color.
 
 Default is [UIColor whiteColor]
 */
@property (nonatomic, DM_STRONG) UIColor *backgroundColor;

/*
 Color for the selection indicator stripe/box
 
 Default is R:52, G:181, B:229
 */
@property (nonatomic, DM_STRONG) UIColor *selectionIndicatorColor;

/*
 Specifies the style of the control
 
 Default is `DMHMSegmentedControlTypeText`
 */
@property (nonatomic, assign) DMHMSegmentedControlType type;

/*
 Specifies the style of the selection indicator.
 
 Default is `DMHMSegmentedControlSelectionStyleTextWidthStripe`
 */
@property (nonatomic, assign) DMHMSegmentedControlSelectionStyle selectionStyle;

/*
 Specifies the style of the segment's width.
 
 Default is `DMHMSegmentedControlSegmentWidthStyleFixed`
 */
@property (nonatomic, assign) DMHMSegmentedControlSegmentWidthStyle segmentWidthStyle;

/*
 Specifies the location of the selection indicator.
 
 Default is `DMHMSegmentedControlSelectionIndicatorLocationUp`
 */
@property (nonatomic, assign) DMHMSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;

/*
 Default is NO. Set to YES to allow for adding more tabs than the screen width could fit.
 
 When set to YES, segment width will be automatically set to the width of the biggest segment's text or image,
 otherwise it will be equal to the width of the control's frame divided by the number of segments.
 */
@property(nonatomic, getter = isScrollEnabled) BOOL scrollEnabled;

/*
 Default is YES. Set to NO to deny scrolling by dragging the scrollView by the user.
 */
@property(nonatomic, getter = isUserDraggable) BOOL userDraggable;

/*
 Default is YES. Set to NO to deny any touch events by the user.
 */
@property(nonatomic, getter = isTouchEnabled) BOOL touchEnabled;


/*
 Index of the currently selected segment.
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/*
 Height of the selection indicator. Only effective when `DMHMSegmentedControlSelectionStyle` is either `DMHMSegmentedControlSelectionStyleTextWidthStripe` or `DMHMSegmentedControlSelectionStyleFullWidthStripe`.
 
 Default is 5.0
 */
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;

/*
 Inset left and right edges of segments. Only effective when `scrollEnabled` is set to YES.
 
 Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (id)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages;
- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages titlesForSections:(NSArray *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;

@end
