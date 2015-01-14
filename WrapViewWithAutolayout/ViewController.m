//
//  ViewController.m
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "ViewController.h"
#import "SKTag.h"
#import "SKTagView.h"
#import <Masonry/Masonry.h>
#import <HexColors/HexColor.h>

@interface ViewController ()
@property (strong, nonatomic) SKTagView *tagView;
@property (nonatomic, strong) NSArray *colorPool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorPool = @[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"];
    
    [self setupTagView];
}

- (void)setupTagView
{
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = UIColor.whiteColor;
        view.padding    = UIEdgeInsetsMake(12, 12, 12, 12);
        view.insets    = 15;
        view.lineSpace = 10;
        view;
    });
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = self.view;
        make.centerY.equalTo(superView.mas_centerY).with.offset(0);
        make.leading.equalTo(superView.mas_leading).with.offset(0);
        make.trailing.equalTo(superView.mas_trailing);
    }];
    
    //添加Tags
    [@[@"Python", @"Javascript", @"HTML", @"Go", @"Objective-C",@"C", @"PHP"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
         tag.bgColor = [UIColor colorWithHexString:self.colorPool[idx % self.colorPool.count]];
         tag.target = self;
         tag.action = @selector(handleBtn:);
         tag.cornerRadius = 5;
         
         [self.tagView addTag:tag];
     }];
}

- (void)handleBtn:(UIButton *)btn
{
    NSLog(@"%@", btn.titleLabel.text);

    // remove tag on tap
     [self.tagView removeTag:(SKTag*)btn];
}

#pragma mark - User interactions
- (IBAction)onAdd:(id)sender
{
    SKTag *tag = [SKTag tagWithText:@"New Lang"];
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.bgColor = [UIColor colorWithHexString:self.colorPool[arc4random() % self.colorPool.count]];
    tag.target = self;
    tag.action = @selector(handleBtn:);
    tag.cornerRadius = 5;
    
    [self.tagView addTag:tag];
}


@end
