//
//  YDDTextureViewController.m
//  YDDExercise
//
//  Created by ydd on 2021/1/18.
//  Copyright © 2021 ydd. All rights reserved.
//

#import "YDDTextureViewController.h"
#import <YYCategories/YYCategoriesMacro.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "YDDTabNodeViewController.h"

@interface YDDTextureViewController ()<ASTextNodeDelegate>

@end

@implementation YDDTextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    [self testASDisplayNode];
    
    [self testASDisplayButton];
    
    [self testTextNode];
    
    [self testImageNode];
    
    [self testScrollNode];
}

- (void)setupNav
{
    [self.navBarView setTitle:@"Texture"];
    @weakify(self);
    [self.navBarView setLeftBlock:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)testASDisplayNode
{
    ASDisplayNode *displayNode = [[ASDisplayNode alloc] init];
    displayNode.frame = CGRectMake(20, 100, 100, 100);
    [self.view addSubview:displayNode.view];
    displayNode.backgroundColor = [UIColor greenColor];
    displayNode.cornerRoundingType = ASCornerRoundingTypeDefaultSlowCALayer;
    displayNode.cornerRadius = 10;
    displayNode.borderColor = [UIColor cyanColor].CGColor;
    displayNode.borderWidth = 1;
    
    ASDisplayNode *customDis = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        
        UILabel *custView = [[UILabel alloc] init];
        custView.backgroundColor = [UIColor blueColor];
        custView.text = @"自定义view";
        return custView;
    }];
    
    [self.view addSubview:customDis.view];
    customDis.frame = CGRectMake(130, 100, 100, 100);
}

- (void)testASDisplayButton
{
    ASButtonNode *buttonNode = [[ASButtonNode alloc] init];
    [buttonNode setTitle:@"buttonNode" withFont:kFontPFMedium(14) withColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.view addSubview:buttonNode.view];
    [buttonNode addTarget:self action:@selector(buttonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
    [buttonNode setBackgroundImage:[UIImage as_resizableRoundedImageWithCornerRadius:10 cornerColor:[UIColor redColor] fillColor:[UIColor greenColor] traitCollection:ASPrimitiveTraitCollectionMakeDefault()] forState:UIControlStateNormal];
    
    [buttonNode setBackgroundImage:[UIImage as_resizableRoundedImageWithCornerRadius:10 cornerColor:[UIColor greenColor] fillColor:[UIColor redColor] traitCollection:ASPrimitiveTraitCollectionMakeDefault()] forState:UIControlStateSelected];
    
    buttonNode.contentVerticalAlignment = ASVerticalAlignmentTop;
    buttonNode.contentHorizontalAlignment = ASHorizontalAlignmentLeft;
    buttonNode.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    buttonNode.frame = CGRectMake(240, 100, 100, 100);
    
}
- (void)buttonNode:(ASButtonNode *)node
{
    NSLog(@"buttonNode");
    node.selected = !node.selected;
    
    if (node.selected) {
        node.contentVerticalAlignment = ASVerticalAlignmentTop;
        node.contentHorizontalAlignment = ASHorizontalAlignmentLeft;
    } else {
        node.contentVerticalAlignment = ASVerticalAlignmentCenter;
        node.contentHorizontalAlignment = ASHorizontalAlignmentMiddle;
    }
    
    YDDTabNodeViewController *tab = [[YDDTabNodeViewController alloc] init];
    
    [self.navigationController pushViewController:tab animated:YES];
}

- (void)testTextNode
{
    ASTextNode *textNode = [[ASTextNode alloc] init];
    [self.view addSubview:textNode.view];
    
    textNode.frame = CGRectMake(20, 210, ScreenWidth - 40, 50);
    
    textNode.attributedText = [[NSAttributedString alloc] initWithString:@"文本UILabel，如今我对你来说，也不过只是个陌生人" attributes:@{NSFontAttributeName : kFontPFMedium(14), NSForegroundColorAttributeName : [UIColor purpleColor]}];
    
    
    textNode.linkAttributeNames = @[ NSLinkAttributeName ];

    NSString *blurb = @"文本UILabel，如今我对你来说，也不过只是个陌生人 baidu.com \U0001F638";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:blurb];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, blurb.length)];
    [string addAttributes:@{
        NSLinkAttributeName: [NSURL URLWithString:@"http://baidu.com/"],
                          NSForegroundColorAttributeName: [UIColor grayColor],
                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternDot),
                          }
                  range:[blurb rangeOfString:@"baidu.com"]];
    textNode.attributedText = string;
    textNode.userInteractionEnabled = YES;
    textNode.delegate = self;
    
}

/// ASTextNodeDelegate
- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    NSLog(@"ASTextNodeDelegate: attr: %@, value: %@, point: %@, textRange: %@", attribute, value, NSStringFromCGPoint(point), NSStringFromRange(textRange));
    if ([value isKindOfClass:[NSURL class]]) {
        NSURL *url = (NSURL*)value;
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
    
- (void)testImageNode
{
    ASImageNode *imageNode = [[ASImageNode alloc] init];
    imageNode.image = [UIImage imageNamed:@"defaultIcon"];
    imageNode.frame = CGRectMake(20, 270, 100, 100);
    [self.view addSubnode:imageNode];
    
    imageNode.contentMode = UIViewContentModeScaleAspectFill;
    
    imageNode.cropRect = CGRectMake(0.2, 0.2, 0.6, 0.6);
    
    
    ASNetworkImageNode *netImageNode = [[ASNetworkImageNode alloc] init];
    netImageNode.frame = CGRectMake(130, 270, 100, 100);
    [self.view addSubnode:netImageNode];
    netImageNode.contentMode = UIViewContentModeScaleAspectFill;
    
    [netImageNode setURL:[NSURL URLWithString:@"http://pic1.win4000.com/pic/2/06/df957155c4_200_150.jpg"]];
    netImageNode.defaultImage = [UIImage imageNamed:@"defaultIcon"];
    
}
    
- (void)testScrollNode
{
    ASScrollNode *scrollNode = [[ASScrollNode alloc] init];
    [self.view addSubnode:scrollNode];
    scrollNode.frame = CGRectMake(20, 380, 200, 100);
    
    scrollNode.automaticallyManagesSubnodes = YES;
    scrollNode.automaticallyManagesContentSize = YES;
    
    scrollNode.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        ASStackLayoutSpec *stack = [ASStackLayoutSpec verticalStackLayoutSpec];
        return stack;
    };
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
