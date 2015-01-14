//
//  SKTagView.h
//
//  Created by Shaokang Zhao on 01/12/15.
//  Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTag;
@interface SKTagView : UIView
@property (nonatomic, assign) UIEdgeInsets padding;
@property (nonatomic, assign) int lineSpace;
@property (nonatomic, assign) CGFloat insets;
@property (nonatomic) CGFloat preferredMaxLayoutWidth;
@property (nonatomic) BOOL singleLine;

- (void)addTag:(SKTag *)tag;
- (void)removeTag:(SKTag*)tag;
@end

