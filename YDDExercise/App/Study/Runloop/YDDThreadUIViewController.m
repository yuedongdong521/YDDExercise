//
//  YDDThreadUIViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/4/1.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDThreadUIViewController.h"

@interface YDDRunLoopView : UIView<CALayerDelegate>

@end

@implementation YDDRunLoopView

- (void)displayLayer:(CALayer *)layer
{
    NSLog(@" displayer : %@ ", layer);
    UIImage *image = [UIImage imageNamed:@"BigImage.jpg"];
    layer.contents = (__bridge id)image.CGImage;
}

@end



@interface YDDThreadUIViewController ()

@end

@implementation YDDThreadUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navBarView.leftBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    YDDRunLoopView *runloopView = [[YDDRunLoopView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    runloopView.backgroundColor = [UIColor redColor];
    [self.view addSubview:runloopView];
    [runloopView.layer displayIfNeeded];
    
    
    
    
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
