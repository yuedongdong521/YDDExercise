//
//  YDDVideoCommentView.m
//  YDDExercise
//
//  Created by ydd on 2020/8/6.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCommentView.h"

#import "YDDVideoCommentInputView.h"
#import "YDDVideoCommentTableViewCell.h"


#import <YYModel/YYModel.h>


@interface YDDVideoCommentView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>


@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YDDVideoCommentInputView *inputView;

@property (nonatomic, strong) NSMutableArray <YDDVideoCommentModel *>* commentMutArr;

@property (nonatomic, strong) NSIndexPath *replyIndexPath;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger commentsTotal;


@property (nonatomic, strong) UIImage *snipImage;

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@property (nonatomic, assign) CGFloat contentOriginY;

@property (nonatomic, assign) BOOL resetAnimation;

@property (nonatomic, assign) BOOL didDismiss;

@property (nonatomic, assign) BOOL decelerate;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *emptyBgView;





@end

@implementation YDDVideoCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



+ (YDDVideoCommentView *)presnetWithVideoModel:(YDDVideoShowModel *)videoModel
                                      superVC:(nonnull UIViewController *)superVC
                         callBackCommentTotal:(nonnull void (^)(NSInteger total))callBackCommentTotal
{
    if (!superVC) {
        return nil;
    }
    YDDVideoCommentView *commentView = [[YDDVideoCommentView alloc] init];
    commentView.superVC = superVC;
    [superVC.view addSubview:commentView];
    commentView.callBackCommentTotal = callBackCommentTotal;
    commentView.videoModel = videoModel;
    [commentView showWithAnimation:YES];
    return commentView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
        
        self.commentsTotal = 0;
    }
    return self;
}

- (void)setVideoModel:(YDDVideoShowModel *)videoModel
{
    _videoModel = videoModel;
    [self commentsListRequest:YES];
}

- (void)showWithAnimation:(BOOL)animation
{
    CGRect frame = self.superVC.view.bounds;
    if (animation) {
        CGRect animationRect = frame;
        animationRect.origin.y = frame.size.height;
        self.frame = animationRect;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            if (!finished) {
                self.frame = frame;
            }
        }];
    } else {
        self.frame = frame;
    }
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if (self.inputView.isShowKeyBoard) {
        [self.inputView hideKeyBoard];
    }
    if (animation) {
        CGRect animationRect = self.frame;
        animationRect.origin.y = animationRect.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = animationRect;
        } completion:^(BOOL finished) {
            if (!finished) {
                self.frame = animationRect;
            }
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}



- (void)initUI
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.emptyBgView];
    [self.contentView addSubview:self.tableView];
   
    
    if (IS_iPhoneX) {
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kSafeBottom + 49);
        }];
    }
     [self.contentView addSubview:self.inputView];
    
    CGFloat contentTop = kHeightIPHONE6(192) + kSafeTop;
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight - contentTop) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    maskLayer.path = path.CGPath;
    maskLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - contentTop);
    self.contentView.layer.mask = maskLayer;
    

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"video_commet_close_icon"] forState:UIControlStateNormal];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    
    self.contentOriginY = contentTop;
    self.contentView.frame = CGRectMake(0, self.contentOriginY, ScreenWidth, ScreenHeight - contentTop);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.emptyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49 - kSafeBottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49 - kSafeBottom);
    }];
    
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kSafeBottom);
        make.height.mas_equalTo(49);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(-4);
    }];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGes.delegate = self;
    [self addGestureRecognizer:self.panGes];
    
    [tap requireGestureRecognizerToFail:self.panGes];
    
}



- (void)setCommentsTotal:(NSInteger)commentsTotal
{
    _commentsTotal = commentsTotal;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld条评论", (long)_commentsTotal];
}



// 评论列表请求
// 第一次进入详情拉取列表,不需要滚动
- (void)commentsListRequest:(BOOL)isRefresh {}

/// 评论点赞
- (void)likeComment:(YDDVideoCommentModel *)model completed:(void(^)(YDDVideoCommentModel *commentModel, BOOL success))completed
{}


/// 判断用户是否可以评论或者回复
- (BOOL)judgeUserIsCanCommens { return true;}

/// 发布评论,回复评论
- (void)commentReplyRequest:(NSString *)text{}

- (void)deleteCommentWithCommentModel:(YDDVideoCommentModel *)model indexPath:(NSIndexPath *)indexPath {}


- (void)longActionWithCommentModel:(YDDVideoCommentModel *)model indexPath:(NSIndexPath *)indexPath
{}


- (void)showReportViewWithCommentModel:(YDDVideoCommentModel *)model
{}


- (void)tapAction
{
    if (self.inputView.isShowKeyBoard) {
        [self.inputView hideKeyBoard];
    } else {
        [self closeBtnAction];
    }
}

- (void)closeBtnAction
{
    self.didDismiss = YES;
    if (self.callBackCommentTotal) {
        self.callBackCommentTotal(self.commentsTotal);
    }
    
    if ([self.delegate respondsToSelector:@selector(closeCommentView)]) {
        [self.delegate closeCommentView];
        return;
    }
    
    [self dismissWithAnimation:YES];
}

- (void)pushUserInfoWithCommentModel:(YDDVideoCommentModel *)model
{
    if ([self.delegate respondsToSelector:@selector(openUserInfoWithCommentModel:)]) {
        [self.delegate openUserInfoWithCommentModel:model];
        return;
    }
}

- (void)replyContentModel:(YDDVideoCommentModel *)model indexPath:(NSIndexPath *)indexPath
{
    if (self.inputView.isShowKeyBoard) {
        [self.inputView hideKeyBoard];
    } else {
        if (![self judgeUserIsCanCommens]) {
            return;
        }
        if (self.commentMutArr.count > indexPath.item) {
            self.replyIndexPath = indexPath;
            NSString *tips = [NSString stringWithFormat:@"回复 %@:",model.nickName];
            [self.inputView setupKeyBoardPlaceholderContent:tips];
            [self.inputView showKeyBoard];
        }
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGes) {
        if (self.inputView.isShowKeyBoard) {
            return NO;
        }
        
        if (self.contentView.frame.origin.x > 0) {
            return YES;
        }
        
        if (self.contentView.frame.origin.y > self.contentOriginY) {
            return NO;
        }
        
        CGPoint p = [self.panGes translationInView:self];;
        
        if (fabs(p.x) < fabs(p.y)) {
            return NO;
        } else {
            return YES;
        }
    }
    
    CGPoint p = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, p)) {
        return NO;
    }
    return YES;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)ges
{
    CGPoint p = [ges translationInView:self];
    
    CGPoint v = [ges velocityInView:self];
    
    CGRect frame = self.contentView.frame;
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            
            frame.origin.x = p.x < 0 ? 0 : p.x > ScreenWidth ? ScreenWidth : p.x;
            
            self.contentView.frame = frame;
            break;
            
        default:
            
            if (frame.origin.x > ScreenWidth * 0.5 || v.x > 100) {
                frame.origin.x = ScreenWidth;
            } else {
                frame.origin.x = 0;
            }
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.contentView.frame = frame;
            } completion:^(BOOL finished) {
                if (!finished) {
                    self.contentView.frame = frame;
                }
                if (frame.origin.x > 0) {
                    [self closeBtnAction];
                }
            }];
            
            break;
    }
}




- (void)keyboardChangeWithBottom:(CGFloat)bottom keyBoardHeight:(CGFloat)keyHeight animationDuration:(NSTimeInterval)duration
{
    
    if (keyHeight == 49 && bottom == kSafeBottom && !self.inputView.isHaveText) {
        self.replyIndexPath = nil;
    }
    NSLog(@"keyHeight = %f", keyHeight);
        
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:duration animations:^{
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-bottom);
            make.height.mas_equalTo(keyHeight);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-bottom -keyHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!finished) {
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-bottom);
                make.height.mas_equalTo(keyHeight);
            }];
            
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-bottom -keyHeight);
            }];
        }
        if (self.replyIndexPath && [self.tableView numberOfRowsInSection:self.replyIndexPath.section] > self.replyIndexPath.item) {
            [self.tableView scrollToRowAtIndexPath:self.replyIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
    
}

- (void)sendText:(NSString *)text
{
    if (text.length <= 0) {
        self.replyIndexPath = nil;
        return;
    }
    
    [self.inputView clearTextAndReturnInitState];
    
    [self commentReplyRequest:text];
    
}

- (void)resetAnimationAction
{
    if (self.didDismiss) {
        return;
    }
    
    CGRect frame = self.contentView.frame;
    if (frame.origin.y == self.contentOriginY) {
        return;
    }
    self.resetAnimation = YES;
    frame.origin.y = self.contentOriginY;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (!finished) {
            self.contentView.frame = frame;
        }
        self.resetAnimation = NO;
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.decelerate = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.decelerate) {
        return;
    }
    if (self.resetAnimation) {
        self.tableView.contentOffset = CGPointZero;
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect frame = self.contentView.frame;
    if (offsetY <= 0 || self.contentView.frame.origin.y > self.contentOriginY) {
        frame.origin.y -= offsetY;
        if (frame.origin.y < self.contentOriginY) {
            frame.origin.y = self.contentOriginY;
        }
        self.contentView.frame = frame;
        self.tableView.contentOffset = CGPointZero;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"&&&&&&&&&&&& : %@, decelerate = %d", NSStringFromSelector(_cmd), decelerate);
    self.decelerate = decelerate;
    if (!decelerate) {
        [self resetAnimationAction];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"&&&&&&&&&&&& : %@", NSStringFromSelector(_cmd));
    [self resetAnimationAction];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"&&&&&&&&&&&& : %@", NSStringFromSelector(_cmd));
    if (self.contentView.frame.origin.y > self.contentOriginY) {
        if (velocity.y < -0.5) {
            [self closeBtnAction];
            return;
        }
    }
}



#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDDVideoCommentModel *model = self.commentMutArr[indexPath.row];
    
    if (indexPath.row == 0) {
        return [KXVideoCommentFirstCell cellHeight] + model.contentHeight;
    }
    
    return [YDDVideoCommentTableViewCell cellHeight] + model.contentHeight;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    YDDVideoCommentTableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KXVideoCommentFirstCell class])];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDDVideoCommentTableViewCell class])];
    }
    if (!cell) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
    if (self.commentMutArr.count > indexPath.row) {
        YDDVideoCommentModel *commentModel = self.commentMutArr[indexPath.row];
        BOOL isAuthor = [commentModel.fromUserId integerValue] == self.videoModel.userId;
        [cell updateCommentModel:self.commentMutArr[indexPath.row] indexPath:indexPath isAuthor:isAuthor];
    }
    
    @weakify(self);
    cell.likeBlock = ^(YDDVideoCommentModel * _Nonnull commentModel, void (^ _Nonnull completed)(YDDVideoCommentModel * _Nonnull, BOOL)) {
        @strongify(self);
        [self likeComment:commentModel completed:completed];
    };
    
    cell.userBlock = ^(YDDVideoCommentModel * _Nonnull commentModel) {
        @strongify(self);
        [self pushUserInfoWithCommentModel:commentModel];
    };
    
    cell.contentBlock = ^(YDDVideoCommentModel * _Nonnull commentModel, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self replyContentModel:commentModel indexPath:indexPath];
    };
    
    cell.longBlock = ^(YDDVideoCommentModel * _Nonnull commentModel, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self longActionWithCommentModel:commentModel indexPath:indexPath];
    };
    
    return cell;
}


- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColorLightAndDark(UIColorHexRGBA(0xfafafa, 0.99), UIColorHexRGBA(0x151416, 0.96));
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontPFMedium(12);
        _titleLabel.textColor = UIColorLightAndDark(UIColorHexRGBA(0x333333, 0.8), UIColorHexRGBA(0xffffff, 0.8));
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[YDDVideoCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([YDDVideoCommentTableViewCell class])];
        
        [_tableView registerClass:[KXVideoCommentFirstCell class] forCellReuseIdentifier:NSStringFromClass([KXVideoCommentFirstCell class])];
    }
    return _tableView;
}

- (YDDVideoCommentInputView *)inputView
{
    if (!_inputView) {
        _inputView = [[YDDVideoCommentInputView alloc] initWithInputViewHeight:49];
        @weakify(self);
        _inputView.checkUserLevelBlock = ^{
            @strongify(self);
             [self judgeUserIsCanCommens];
        };
        _inputView.sendTextBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self sendText:text];
        };
        _inputView.keyBoardChangeBlock = ^(CGFloat bottom, CGFloat height, CGFloat duration) {
            @strongify(self);
            [self keyboardChangeWithBottom:bottom keyBoardHeight:height animationDuration:duration];
        };
    }
    return _inputView;
}

- (NSMutableArray<YDDVideoCommentModel *> *)commentMutArr
{
    if (!_commentMutArr) {
        _commentMutArr = [NSMutableArray array];
    }
    return _commentMutArr;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColorLightAndDark([UIColor whiteColor], [UIColor colorWithWhite:0 alpha:1]);
    }
    return _bottomView;
}

- (UIView *)emptyBgView
{
    if (!_emptyBgView) {
        _emptyBgView = [[UIView alloc] init];
        _emptyBgView.backgroundColor = [UIColor clearColor];
    }
    return _emptyBgView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end

