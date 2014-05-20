//
//  DMHMSegmentedControl.m
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/14.
//  Copyright (c) 2014 Domob Ltd. All rights reserved.
//

//
//  DMHMSegmentedControl.m
//  DMHMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "DMHMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

#define segmentImageTextPadding 7

@interface DMHMScrollView : UIScrollView
@end

@interface DMHMSegmentedControl ()

@property (nonatomic, DM_STRONG) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, DM_STRONG) CALayer *selectionIndicatorBoxLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, readwrite) NSArray *segmentWidthsArray;
@property (nonatomic, DM_STRONG) DMHMScrollView *scrollView;

@end

@implementation DMHMScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@implementation DMHMSegmentedControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [self initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.sectionTitles = sectiontitles;
        self.type = DMHMSegmentedControlTypeText;
    }
    
    return self;
}

- (id)initWithSectionImages:(NSArray*)sectionImages sectionSelectedImages:(NSArray*)sectionSelectedImages {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
        self.type = DMHMSegmentedControlTypeImages;
    }
    
    return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages titlesForSections:(NSArray *)sectiontitles {
	self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
		
		if (sectionImages.count != sectiontitles.count)
			[NSException raise:NSRangeException format:@"***%s: Images bounds (%d) Dont match Title bounds (%d)", sel_getName(_cmd), sectionImages.count, sectiontitles.count];
		
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
		self.sectionTitles = sectiontitles;
        self.type = DMHMSegmentedControlTypeTextImages;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit {
    self.scrollView = DM_SAFE_ARC_AUTORELEASE([[DMHMScrollView alloc] init]);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f];
    self.textColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.selectionIndicatorHeight = 5.0f;
    self.selectionStyle = DMHMSegmentedControlSelectionStyleTextWidthStripe;
    self.selectionIndicatorLocation = DMHMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentWidthStyle = DMHMSegmentedControlSegmentWidthStyleFixed;
    self.userDraggable = YES;
    self.touchEnabled = YES;
    self.type = DMHMSegmentedControlTypeText;
    
    self.selectionIndicatorStripLayer = [CALayer layer];
    
    self.selectionIndicatorBoxLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer.opacity = 0.2;
    self.selectionIndicatorBoxLayer.borderWidth = 1.0f;
    
    self.contentMode = UIViewContentModeRedraw;
}

- (void)dealloc
{
    DM_SAFE_ARC_SUPER_DEALLOC();
    
    DM_SAFE_ARC_RELEASE(self.sectionTitles);
    DM_SAFE_ARC_RELEASE(self.sectionImages);
    DM_SAFE_ARC_RELEASE(self.sectionSelectedImages);
    DM_SAFE_ARC_RELEASE(self.font);
    DM_SAFE_ARC_RELEASE(self.textColor);
    DM_SAFE_ARC_RELEASE(self.selectedTextColor);
    DM_SAFE_ARC_RELEASE(self.backgroundColor);
    DM_SAFE_ARC_RELEASE(self.selectionIndicatorColor);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentsRects];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.type == DMHMSegmentedControlTypeText && self.sectionTitles) {
        [self updateSegmentsRects];
    } else if(self.type == DMHMSegmentedControlTypeImages && self.sectionImages) {
        [self updateSegmentsRects];
    } else if (self.type == DMHMSegmentedControlTypeTextImages && self.sectionImages && self.sectionTitles){
		[self updateSegmentsRects];
	}
    
    [self updateSegmentsRects];
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
    _sectionTitles = DM_SAFE_ARC_RETAIN(sectionTitles);
    
    [self setNeedsLayout];
}

- (void)setSectionImages:(NSArray *)sectionImages {
    _sectionImages = DM_SAFE_ARC_RETAIN(sectionImages);
    
    [self setNeedsLayout];
}

- (void)setSelectionIndicatorLocation:(DMHMSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation {
	
	_selectionIndicatorLocation = selectionIndicatorLocation;
	
	if (selectionIndicatorLocation == DMHMSegmentedControlSelectionIndicatorLocationNONE) {
		self.selectionIndicatorHeight = 0.0f;
	}
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);

    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorBoxLayer.borderColor = self.selectionIndicatorColor.CGColor;
    
    // Remove all sublayers to avoid drawing images over existing ones
    self.scrollView.layer.sublayers = nil;
    
    if (self.type == DMHMSegmentedControlTypeText) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            CGFloat stringHeight = roundf([titleString sizeWithFont:self.font].height);
            // Text inside the CATextLayer will appear blurry unless the rect values are rounded
            CGFloat y = roundf(((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2));
            CGRect rect;
            if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed)
                rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
            else if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                CGFloat xOffset = 0;
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i)
                        break;
                    xOffset = xOffset + [width floatValue];
                    i++;
                }
                
                rect = CGRectMake(xOffset, y, [[self.segmentWidthsArray objectAtIndex:idx] floatValue], stringHeight);
            }
            
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = rect;
            titleLayer.font = (__bridge CFTypeRef)(self.font.fontName);
            titleLayer.fontSize = self.font.pointSize;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = titleString;
            titleLayer.truncationMode = kCATruncationEnd;
            
            if (self.selectedSegmentIndex == idx) {
                titleLayer.foregroundColor = self.selectedTextColor.CGColor;
            } else {
                titleLayer.foregroundColor = self.textColor.CGColor;
            }
            
            titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
        }];
    } else if (self.type == DMHMSegmentedControlTypeImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
            CGFloat y = ((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - imageHeight / 2);
            CGFloat x = self.segmentWidth * idx + (self.segmentWidth - imageWidth)/2.0f;
            CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = rect;
                        
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
        }];
    } else if (self.type == DMHMSegmentedControlTypeTextImages){
		[self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            // When we have both an image and a title, we start with the image and use segmentImageTextPadding before drawing the text.
            // So the image will be left to the text, centered in the middle
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
			
			CGFloat stringHeight = roundf([self.sectionTitles[idx] sizeWithFont:self.font].height);
						
			CGFloat yOffset = roundf(((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) - (stringHeight / 2));
            
            CGFloat imageXOffset = self.segmentEdgeInset.left; // Start with edge inset
            if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed)
                imageXOffset = self.segmentWidth * idx;
            else if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i)
                        break;
                    imageXOffset = imageXOffset + [width floatValue];
                    i++;
                }
            }
            
            CGRect imageRect = CGRectMake(imageXOffset, yOffset, imageWidth, imageHeight);
			
            // Use the image offset and padding to calculate the text offset
            CGFloat textXOffset = imageXOffset + imageWidth + segmentImageTextPadding;
            
            // The text rect's width is the segment width without the image, image padding and insets
            CGRect textRect = CGRectMake(textXOffset, yOffset, [[self.segmentWidthsArray objectAtIndex:idx] floatValue]-imageWidth-segmentImageTextPadding-self.segmentEdgeInset.left-self.segmentEdgeInset.right, stringHeight);
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = textRect;
            titleLayer.font = (__bridge CFTypeRef)(self.font.fontName);
            titleLayer.fontSize = self.font.pointSize;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = self.sectionTitles[idx];
            titleLayer.truncationMode = kCATruncationEnd;
			
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = imageRect;
			
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
				titleLayer.foregroundColor = self.selectedTextColor.CGColor;
            } else {
                imageLayer.contents = (id)icon.CGImage;
				titleLayer.foregroundColor = self.textColor.CGColor;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
			titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
			
        }];
	}

    
    // Add the selection indicators
    if (self.selectedSegmentIndex != DMHMSegmentedControlNoSegment && !self.selectionIndicatorStripLayer.superlayer) {
        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
        
        if (self.selectionStyle == DMHMSegmentedControlSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
        }
    }
}

- (CGRect)frameForSelectionIndicator {
    CGFloat indicatorYOffset = 0.0f;
        
    if (self.selectionIndicatorLocation == DMHMSegmentedControlSelectionIndicatorLocationDown)
        indicatorYOffset = self.bounds.size.height - self.selectionIndicatorHeight;
    
    CGFloat sectionWidth = 0.0f;

    if (self.type == DMHMSegmentedControlTypeText) {
        CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedSegmentIndex] sizeWithFont:self.font].width;
        sectionWidth = stringWidth;
    } else if (self.type == DMHMSegmentedControlTypeImages) {
        UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedSegmentIndex];
        CGFloat imageWidth = sectionImage.size.width;
        sectionWidth = imageWidth;
    } else if (self.type == DMHMSegmentedControlTypeTextImages){
		CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedSegmentIndex] sizeWithFont:self.font].width;
		UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedSegmentIndex];
		CGFloat imageWidth = sectionImage.size.width;
        if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed)
            sectionWidth = MAX(stringWidth, imageWidth);
        else if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic)
            sectionWidth = imageWidth + segmentImageTextPadding + stringWidth;
	}
    
    if (self.selectionStyle == DMHMSegmentedControlSelectionStyleTextWidthStripe && sectionWidth <= self.segmentWidth) {
        CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
        CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
        
        CGFloat x = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) + (widthToStartOfSelectedIndex - sectionWidth / 2);
        return CGRectMake(x, indicatorYOffset, sectionWidth, self.selectionIndicatorHeight);
    } else {
        if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
            CGFloat selectedSegmentOffset = 0.0f;
            
            NSInteger i = 0;
            for (NSNumber *width in self.segmentWidthsArray) {
                if (self.selectedSegmentIndex == i)
                    break;
                selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
                i++;
            }
            
            return CGRectMake(selectedSegmentOffset, indicatorYOffset, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue], self.selectionIndicatorHeight);
        }
        
        return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, indicatorYOffset, self.segmentWidth, self.selectionIndicatorHeight);
    }
}

- (CGRect)frameForFillerSelectionIndicator {
    if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
        CGFloat selectedSegmentOffset = 0.0f;
        
        NSInteger i = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
            if (self.selectedSegmentIndex == i)
                break;
            i++;
        }
        
        return CGRectMake(selectedSegmentOffset, 0, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue], CGRectGetHeight(self.frame));
    }
    return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, 0, self.segmentWidth, CGRectGetHeight(self.frame));
}

- (void)updateSegmentsRects {
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

    // When `scrollEnabled` is set to YES, segment width will be automatically set to the width of the biggest segment's text or image,
    // otherwise it will be equal to the width of the control's frame divided by the number of segments.
    if ([self sectionCount] > 0) {
        self.segmentWidth = self.frame.size.width / [self sectionCount];
    }
    
    if (self.isScrollEnabled) {
        if (self.type == DMHMSegmentedControlTypeText && self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed) {
            for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
                CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#else
                CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#endif
                self.segmentWidth = MAX(stringWidth, self.segmentWidth);
            }
        } else if (self.type == DMHMSegmentedControlTypeText && self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
            NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
            
            for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
                CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#else
                CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#endif
                [mutableSegmentWidths addObject:[NSNumber numberWithFloat:stringWidth]];
            }
            self.segmentWidthsArray = [mutableSegmentWidths copy];
        } else if (self.type == DMHMSegmentedControlTypeImages) {
            for (UIImage *sectionImage in self.sectionImages) {
                CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
                self.segmentWidth = MAX(imageWidth, self.segmentWidth);
            }
        } else if (self.type == DMHMSegmentedControlTypeTextImages && DMHMSegmentedControlSegmentWidthStyleFixed){
			//lets just use the title.. we will assume it is wider then images...
            for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
                CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#else
                CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
#endif
                self.segmentWidth = MAX(stringWidth, self.segmentWidth);
            }
		} else if (self.type == DMHMSegmentedControlTypeTextImages && DMHMSegmentedControlSegmentWidthStyleDynamic) {
            NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
            
            int i = 0;
            for (NSString *titleString in self.sectionTitles) {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
                CGFloat stringWidth = [titleString sizeWithAttributes:@{NSFontAttributeName: self.font}].width + self.segmentEdgeInset.right;
#else
                CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.right;
#endif
                UIImage *sectionImage = [self.sectionImages objectAtIndex:i];
                CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left;
                
                CGFloat combinedWidth = imageWidth + segmentImageTextPadding + stringWidth;
                
                [mutableSegmentWidths addObject:[NSNumber numberWithFloat:combinedWidth]];
                
                i++;
            }
            self.segmentWidthsArray = [mutableSegmentWidths copy];
        }
    }
    
    if ([self segmentedControlNeedsScrolling]) {
        self.scrollView.scrollEnabled = self.isUserDraggable;
        self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
    } else {
		self.scrollView.scrollEnabled = NO;
        self.scrollView.contentSize = self.frame.size;
	}
}

- (NSUInteger)sectionCount {
    if (self.type == DMHMSegmentedControlTypeText) {
        return self.sectionTitles.count;
    } else if (self.type == DMHMSegmentedControlTypeImages ||
               self.type == DMHMSegmentedControlTypeTextImages) {
        return self.sectionImages.count;
    }
    
    return 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    if (self.sectionTitles || self.sectionImages) {
        [self updateSegmentsRects];
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = 0;
        if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed) {
            segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        }
        else if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
            // To know which segment the user touched, we need to loop over the widths and substract it from the x position.
            CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
            for (NSNumber *width in self.segmentWidthsArray) {
                widthLeft = widthLeft - [width floatValue];
                
                // When we don't have any width left to substract, we have the segment index.
                if (widthLeft <= 0)
                    break;
                
                segment++;
            }
        }
        
        if (segment != self.selectedSegmentIndex) {
            // Check if we have to do anything with the touch event
            if (self.isTouchEnabled)
                [self setSelectedSegmentIndex:segment animated:YES notify:YES];
        }
    }
}

#pragma mark - Scrolling

- (BOOL)segmentedControlNeedsScrolling {
    if ([self totalSegmentedControlWidth] > self.frame.size.width && self.isScrollEnabled) {
        return YES;
    }
    return NO;
}

- (CGFloat)totalSegmentedControlWidth {
    if (self.type == DMHMSegmentedControlTypeText && self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed) {
        return self.sectionTitles.count * self.segmentWidth;
    } else if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
        CGFloat totalWidth;
        for (NSNumber *width in self.segmentWidthsArray) {
            totalWidth = totalWidth + [width floatValue];
        }
        return totalWidth;
    } else {
        return self.sectionImages.count * self.segmentWidth;
    }
}

- (void)scrollToSelectedSegmentIndex {
    CGRect rectForSelectedIndex;
    CGFloat selectedSegmentOffset = 0;
    if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleFixed) {
        rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                                 0,
                                                 self.segmentWidth,
                                                 self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    } else if (self.segmentWidthStyle == DMHMSegmentedControlSegmentWidthStyleDynamic) {
        NSInteger i = 0;
        CGFloat offsetter = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == i)
                break;
            offsetter = offsetter + [width floatValue];
            i++;
        }
        
        rectForSelectedIndex = CGRectMake(offsetter,
                                          0,
                                          [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue],
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - ([[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] / 2);
    }
    
    
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:YES];
}

#pragma mark - Index change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedSegmentIndex = index;
    [self setNeedsDisplay];
    
    if (index == DMHMSegmentedControlNoSegment) {
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
    } else {
        [self scrollToSelectedSegmentIndex];
        
        if (animated) {
            // If the selected segment layer is not added to the super layer, that means no
            // index is currently selected, so add the layer then move it to the new
            // segment index without animating.
            if ([self.selectionIndicatorStripLayer superlayer] == nil) {
                [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                
                if (self.selectionStyle == DMHMSegmentedControlSelectionStyleBox && [self.selectionIndicatorBoxLayer superlayer] == nil)
                    [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                
                [self setSelectedSegmentIndex:index animated:NO notify:YES];
                return;
            }
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
            
            // Restore CALayer animations
            self.selectionIndicatorStripLayer.actions = nil;
            self.selectionIndicatorBoxLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [CATransaction commit];
        } else {
            // Disable CALayer animations
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.selectionIndicatorStripLayer.actions = newActions;
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            
            self.selectionIndicatorBoxLayer.actions = newActions;
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];

            DM_SAFE_ARC_AUTORELEASE(newActions);
        }
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

@end