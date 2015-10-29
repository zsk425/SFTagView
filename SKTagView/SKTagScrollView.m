//
//  SKTagScrollView.m
//  SKTagView
//
//  Created by LIYINGPENG on 15/10/29.
//  Copyright © 2015年 shiweifu. All rights reserved.
//

#import "SKTagScrollView.h"
#import "SKTagView.h"
#import <Masonry/Masonry.h>

@interface SKTagScrollView ()
@property (nonatomic, strong, readwrite) SKTagView *tagView;
@end

@implementation SKTagScrollView
- (instancetype) initWithTagView:(SKTagView*) tagView{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _tagView = tagView;
        [self addSubview:tagView];
        typeof(self) __weak weakSelf = self;
        [_tagView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1 forAxis:UILayoutConstraintAxisVertical];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf);
            if (weakSelf.tagView.singleLine) {
                
                make.width.greaterThanOrEqualTo(weakSelf);
                make.height.equalTo(weakSelf).priority(MASLayoutPriorityDefaultHigh);
            }else{
                
                make.width.equalTo(weakSelf).priority(MASLayoutPriorityDefaultHigh);
                make.height.greaterThanOrEqualTo(weakSelf);
            }
        }];
    }
    return self;
}

- (instancetype) init{
    
    return [self initWithTagView:[[SKTagView alloc] init]];
}
@end
