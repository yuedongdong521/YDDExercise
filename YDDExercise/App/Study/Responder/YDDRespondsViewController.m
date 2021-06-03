//
//  YDDRespondsViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/5/8.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDRespondsViewController.h"

@interface YDDRespondView : UIView

@end

@implementation YDDRespondView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UITouch *touch = event.allTouches.anyObject;

    NSLog(@"%@， type ： %d, subType : %d", NSStringFromClass([self class]), touch.type, touch.phase);
    return [super hitTest:point withEvent:event];
}



@end


@interface YDDRespondSubView : UIView

@end


@implementation YDDRespondSubView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromClass([self class]));
    return [super hitTest:point withEvent:event];
}



@end


@interface YDDRespondsViewController ()

@end

@implementation YDDRespondsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    YDDRespondView *respondView = [[YDDRespondView alloc] init];
    respondView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:respondView];
    
    
    YDDRespondSubView *subView = [[YDDRespondSubView alloc] init];
    subView.backgroundColor = [UIColor redColor];
    [respondView addSubview:subView];
    
    YDDRespondView *thirdView = [[YDDRespondView alloc] init];
    thirdView.backgroundColor = [UIColor blueColor];
    [subView addSubview:thirdView];
    
    [respondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(300);
    }];
    
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [respondView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
//    [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subTapAction)]];
    
    UILabel *tapLable = [[UILabel alloc] init];
    tapLable.text = @"防抖动点击";
    tapLable.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:tapLable];
    tapLable.userInteractionEnabled = YES;
    [tapLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(respondView.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [tapLable addTapDebounce:0.3 action:^(UITapGestureRecognizer * _Nonnull tap) {
        NSLog(@"防抖动点击");
    }];
    
}

- (void)tapAction {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)subTapAction {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
