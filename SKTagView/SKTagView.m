//
//  SKTagView.m
//
//  Created by Shaokang Zhao on 01/12/15.
//  Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTagView.h"
#import "SKTag.h"
#import "SKTagButton.h"
#import <Masonry/Masonry.h>

#define SAVE_C(c) [self.tagsContraints addObject:c]

@interface SKTagView ()
@property (nonatomic, strong) NSMutableArray *tagsConstraints;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic) BOOL didSetup;
@end

@implementation SKTagView

#pragma mark - Life circle
- (void)updateConstraints
{
    [self updateWrappingConstrains];
    [super updateConstraints];
}

-(CGSize)intrinsicContentSize
{
    NSArray *subviews = self.subviews;
    UIView *previewsView = nil;
    CGFloat leftOffset = self.padding.left;
    CGFloat bottomOffset = self.padding.bottom;
    CGFloat rightOffset = self.padding.right;
    CGFloat itemMargin = self.insets;
    CGFloat topPadding = self.padding.top;
    CGFloat itemVerticalMargin = self.lineSpace;
    CGFloat currentX = leftOffset;
    CGFloat intrinsicHeight = topPadding;
    CGFloat intrinsicWidth = leftOffset;
    
    
    if (!self.singleLine && self.preferredMaxLayoutWidth > 0)
    {
        NSInteger lineCount = 0;
        for (UIView *view in subviews)
        {
            CGSize size = view.intrinsicContentSize;
            if (previewsView)
            {
                CGFloat width = size.width;
                currentX += itemMargin;
                if (currentX + width + rightOffset <= self.preferredMaxLayoutWidth)
                {
                    currentX += size.width;
                }
                else
                {
                    //New line
                    lineCount ++;
                    
                    currentX = leftOffset + size.width;
                    intrinsicHeight += size.height;
                    
                }
            }
            else
            {
                //First one
                lineCount ++;
                
                intrinsicHeight += size.height;
                currentX += size.width;
            }
            previewsView = view;
            intrinsicWidth = MAX(intrinsicWidth, currentX + rightOffset);
        }
        
        intrinsicHeight += bottomOffset + itemVerticalMargin * (lineCount - 1);
    }
    else
    {
        for (UIView *view in subviews)
        {
            CGSize size = view.intrinsicContentSize;
            intrinsicWidth += size.width;
        }
        intrinsicWidth += itemMargin * (subviews.count - 1) + rightOffset;
        intrinsicHeight += ((UIView *)subviews.firstObject).intrinsicContentSize.height + bottomOffset;
    }
    
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)layoutSubviews
{
    if (!self.singleLine) {
        self.preferredMaxLayoutWidth = self.frame.size.width;
    }
    
    [super layoutSubviews];
}

#pragma mark - Public methods
- (void)addTag:(SKTag *)tag
{
    SKTagButton *btn = [SKTagButton buttonWithTag:tag];
    [self addSubview:btn];
    [self.tags addObject:tag];
    
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)removeTag:(SKTagButton*)tagBtn{
    [self.tags removeObject:tagBtn.mTag];
    [tagBtn removeFromSuperview];

    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Private methods
-(void)updateWrappingConstrains
{
    if (self.didSetup || !self.tags.count)
    {
        return;
    }
    
    //Remove old ones
    [self.tagsConstraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:MASConstraint.class])
        {
            [(MASConstraint *)obj uninstall];
        }
        else if([obj isKindOfClass:NSArray.class])
        {
            [(NSArray *)obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [(MASConstraint *)obj uninstall];
            }];
        }
        else
        {
            NSAssert(NO, @"Error:unknown class type:%@",obj);
        }
    }];
    [self.tagsConstraints removeAllObjects];
    
    //Reinstall
    NSArray *subviews = self.subviews;
    UIView *previewsView = nil;
    UIView *superView = self;
    CGFloat leftOffset = self.padding.left;
    CGFloat bottomOffset = self.padding.bottom;
    CGFloat rightOffset = self.padding.right;
    CGFloat itemMargin = self.insets;
    CGFloat topPadding = self.padding.top;
    CGFloat itemVerticalMargin = self.lineSpace;
    CGFloat currentX = leftOffset;
    
    if (!self.singleLine && self.preferredMaxLayoutWidth > 0)
    {
        for (UIView *view in subviews)
        {
            CGSize size = view.intrinsicContentSize;
            if (previewsView)
            {
                CGFloat width = size.width;
                currentX += itemMargin;
                if (currentX + width + rightOffset <= self.preferredMaxLayoutWidth)
                {
                    [view mas_makeConstraints:^(MASConstraintMaker *make)
                    {
                        SAVE_C(make.leading.equalTo(previewsView.mas_trailing).with.offset(itemMargin));
                        SAVE_C(make.centerY.equalTo(previewsView.mas_centerY));
                    }];
                    currentX += size.width;
                }
                else
                {
                    //换行
                    [view mas_makeConstraints:^(MASConstraintMaker *make)
                    {
                        SAVE_C(make.top.greaterThanOrEqualTo(previewsView.mas_bottom).with.offset(itemVerticalMargin));
                        SAVE_C(make.leading.equalTo(superView.mas_leading).with.offset(leftOffset));
                    }];
                    currentX = leftOffset + size.width;
                }
            }
            else
            {
                //first one
                [view mas_makeConstraints:^(MASConstraintMaker *make)
                {
                    SAVE_C(make.top.equalTo(superView.mas_top).with.offset(topPadding));
                    SAVE_C(make.leading.equalTo(superView.mas_leading).with.offset(leftOffset));
                }];
                currentX += size.width;
            }
            
            previewsView = view;
        }
    }
    else
    {
        for (UIView *view in subviews)
        {
            CGSize size = view.intrinsicContentSize;
            if (previewsView)
            {
                [view mas_makeConstraints:^(MASConstraintMaker *make)
                 {
                     SAVE_C(make.leading.equalTo(previewsView.mas_trailing).with.offset(itemMargin));
                     SAVE_C(make.centerY.equalTo(previewsView.mas_centerY));
                 }];
                currentX += size.width;
            }
            else
            {
                //第一次添加
                [view mas_makeConstraints:^(MASConstraintMaker *make)
                 {
                     SAVE_C(make.top.equalTo(superView.mas_top).with.offset(topPadding));
                     SAVE_C(make.leading.equalTo(superView.mas_leading).with.offset(leftOffset));
                 }];
                currentX += size.width;
            }
            
            previewsView = view;
        }
    }
    
    [previewsView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         SAVE_C(make.bottom.equalTo(superView.mas_bottom).with.offset(-bottomOffset));
     }];
    
    self.didSetup = YES;
}

- (NSMutableArray *)tags
{
    if(!_tags)
    {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (NSMutableArray *)tagsContraints
{
    if(!_tagsConstraints)
    {
        _tagsConstraints = [NSMutableArray array];
    }
    return _tagsConstraints;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth
{
    if (preferredMaxLayoutWidth != _preferredMaxLayoutWidth) {
        _didSetup = NO;
        _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
        [self setNeedsUpdateConstraints];
    }
}

@end
