//
//  YDDVideoCommentInputView.m
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCommentInputView.h"
#import "PPTextBackedString.h"
#import "NSAttributedString+PPAddition.h"
#import "PPStickerDataManager.h"


@interface YDDVideoCommentInputView ()<UITextViewDelegate,PPStickerKeyboardDelegate>

/// 输入视图原始高
@property (nonatomic, assign) CGFloat inputViewHeight;

/// 输入框背景
@property (nonatomic, strong) UIView            *bgView;
/// 输入框
@property (nonatomic, strong) UITextView        *textView;
/// 输入切换按钮
@property (nonatomic, strong) UIButton          *emojiButton;
/// 发送按钮
@property (nonatomic, strong) UIButton          *sendButton;
/// 表情键盘
@property (nonatomic, strong) PPStickerKeyboard *emotionKeyboard;
/// 占位文字
@property (nonatomic, strong) UILabel           *placeLabel;
/// 遮盖按钮,点击判断等级是否满足
@property (nonatomic, strong) UIButton          *levelButton;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation YDDVideoCommentInputView


- (instancetype)init
{
    self = [super init];
    if (self) {
        _inputViewHeight = 64;
        [self configUI];
    }
    return self;
}

- (instancetype)initWithInputViewHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        _inputViewHeight = height;
        [self configUI];
    }
    return self;
}


#pragma mark - 初始化界面
- (void)configUI
{
    
    self.backgroundColor = [UIColor clearColor];
    _keyBoardHeight = _inputViewHeight;
    _bottomDistance = kSafeBottom;
    [self emotionKeyboard];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.emojiButton];
    [self.bgView addSubview:self.sendButton];
    [self.bgView addSubview:self.placeLabel];
    [self addSubview:self.levelButton];
    
    self.bgView.backgroundColor = UIColorLightAndDark([UIColor colorWithWhite:1 alpha:1], [UIColor colorWithWhite:0 alpha:1]);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.sendButton.backgroundColor = [UIColor clearColor];
    self.sendButton.layer.cornerRadius = 0;
    self.sendButton.titleLabel.font = kFontPFMedium(15);
    [self.sendButton setTitleColor:UIColorHex(0x09E1D5) forState:UIControlStateNormal];
    [self.sendButton setTitleColor:UIColorLightAndDark(UIColorHex(0xBBBBBB), UIColorHexRGBA(0x888888, 0.5))
                          forState:UIControlStateDisabled];
    
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).mas_offset(-6);
        make.bottom.equalTo(self.bgView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(49);
    }];
    
    [self.emojiButton setImage:[UIImage imageNamed:@"comment_emoji_white_icon"] forState:UIControlStateNormal];
    [self.emojiButton setImage:[UIImage imageNamed:@"comment_keyboard_white_icon"] forState:UIControlStateSelected];
    
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sendButton);
        make.width.height.mas_equalTo(40);
        make.right.equalTo(self.sendButton.mas_left);
    }];
    
    
    
    self.textView.textColor = UIColorLightAndDark(UIColorHex(0x555555), UIColorHexRGBA(0xffffff, 0.9));
    self.textView.font = kFontPFMedium(15);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).mas_offset(9);
        make.left.equalTo(self.bgView).mas_offset(16);
        make.right.equalTo(self.emojiButton.mas_left).mas_offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    self.placeLabel.textColor = UIColorHexRGBA(0x888888, 0.4);
    self.placeLabel.font = kFontPF(15);
    self.placeLabel.text = @"添加评论，说点儿好听的呗～";
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView);
        make.left.equalTo(self.textView).mas_offset(5);
        make.right.equalTo(self.emojiButton.mas_left).mas_offset(-12);
        make.height.mas_equalTo(30);
    }];
    
    [self uploadSendButtonStatus:NO];
    
    [self.levelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_textView addGestureRecognizer:tapGes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    [self uploadSendButtonStatus:NO];
    /// 更新判断用户等级的按钮,的状态
    [self uploadKeyBoardStatus];
    
}


#pragma mark - 点击事件
- (void)levelButtonClick{
    if (self.checkUserLevelBlock) {
        self.checkUserLevelBlock();
    }
}

/// 点击回复
- (void)tapAction{
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
    self.emojiButton.selected = NO;
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - 公开方法
- (void)uploadKeyBoardStatus{
    
    
    self.levelButton.hidden = YES;
}


/// 切换键盘
- (void)emojiButtonClick:(UIButton *)button{
    
    self.emojiButton.selected = !self.emojiButton.selected;
    if (self.emojiButton.selected) {
        //嵌入第三方
        self.textView.inputView = self.emotionKeyboard;
        [self.textView reloadInputViews];
    } else {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
    }
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
    
}
/// 发送
- (void)sendButtonClick:(UIButton *)button{
    
//    [self.textView resignFirstResponder];
//    if (self.sendTextBlock) {
//        self.sendTextBlock(self.plainText);
//    }
//    [self moveInputContentViewWithBottomDistance:kSafeBottom andKeyBoardHeight:_inputViewHeight animationDuration:0.25];
    
    [self sendText:self.plainText];
    
}

- (void)sendText:(NSString *)text
{
    if (self.sendTextBlock) {
        self.sendTextBlock(self.plainText);
    }
    self.textView.attributedText = nil;
    self.textView.text = @"";
    
    [self textViewDidChange:self.textView];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
}

// 键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat bottomDis = screenHeight - keyboardFrame.origin.y; //减去键盘开始的地方
    _bottomDistance = bottomDis;
    [self moveInputContentViewWithBottomDistance:bottomDis andKeyBoardHeight:self.keyBoardHeight animationDuration:duration];
    
    if (self.textView.attributedText.length > 0) {
        CGFloat textViewW = self.textView.frame.size.width - self.textView.textContainerInset.left - self.textView.textContainerInset.right - 2;
        CGFloat h = [self.textView.text ydd_textSize:CGSizeMake(textViewW, 140) font:kFontPFMedium(15)].height;
        if (h < 30) {
            h = 30;
        }
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.textView.attributedText.length > 0) {
        _isHaveText = YES;

    }else{
        _isHaveText = NO;
        [self setupKeyBoardPlaceholderContent:@"有爱的评论会被优先展示哦~"];
    }
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _bottomDistance = kSafeBottom;
    [self moveInputContentViewWithBottomDistance:kSafeBottom andKeyBoardHeight:_inputViewHeight animationDuration:duration];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - 公开方法
- (void)showKeyBoard{
    [self.textView becomeFirstResponder];
}
- (void)hideKeyBoard{
    [self.textView resignFirstResponder];
}
- (void)setupKeyBoardPlaceholderContent:(NSString *)text{
    self.placeLabel.text = text;
}
- (void)clearTextAndReturnInitState {
    CGFloat keyBoardHeight = self.keyBoardHeight;
    if (!self.isShowKeyBoard) {
        keyBoardHeight = _inputViewHeight;
    }
    [self moveInputContentViewWithBottomDistance:_bottomDistance andKeyBoardHeight:keyBoardHeight animationDuration:0.25];
    self.textView.attributedText = nil;
    self.textView.text = @"";
    _isHaveText = NO;
    _keyBoardHeight = _inputViewHeight;
    _bottomDistance = kSafeBottom;
    [self textViewDidChange:self.textView];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
    
    [self setupKeyBoardPlaceholderContent:@"添加评论，说点儿好听的呗～"];
}

#pragma mark – Private Methods
- (void)uploadSendButtonStatus:(BOOL)enabled{
    if (enabled) {
        self.sendButton.enabled = YES;
    } else {
        self.sendButton.enabled = NO;
    }
}
// 键盘位置改变
- (void)moveInputContentViewWithBottomDistance:(CGFloat)bottomDistance andKeyBoardHeight:(CGFloat)KeyBoardHeight animationDuration:(NSTimeInterval)duration{

    if (self.keyBoardChangeBlock) {
        self.keyBoardChangeBlock(bottomDistance, KeyBoardHeight, duration);
    }
 
    if (self.textView.attributedText.length > 5) {
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.markedTextRange == nil) {
        NSString *text = [self plainText];
        if (text.length > 0) {
            if (text.length > 100) {
                NSRange range = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 100)];
                NSString *tempStr = [text substringWithRange:range];
                textView.text = tempStr;
            }
            [self uploadSendButtonStatus:YES];
        }else{
            [self uploadSendButtonStatus:NO];
        }
    }
    if (textView.text.length > 0) {
        self.placeLabel.hidden = YES;
        _isHaveText = YES;
    }else{
        self.placeLabel.hidden = NO;
        _isHaveText = NO;
    }
    // 刷新UI
    [self refreshTextUI];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.markedTextRange == nil) {
        if (range.location>= 100) {
            [MBProgressHUD cus_showMessage:@"评论内容超过字数上限"];
            return NO;
        }
    }
    if ([self plainText].length > 100) {
        [MBProgressHUD cus_showMessage:@"评论内容超过字数上限"];
        return NO;
    }
    return YES;
}

#pragma mark - PPStickerKeyboardDelegate
//点击了表情面板上的表情
- (void)stickerKeyboard:(PPStickerKeyboard *)stickerKeyboard didClickEmoji:(PPEmoji *)emoji
{
    if (!emoji) {
        return;
    }
    if ([self plainText].length + emoji.emojiDescription.length > 100) {
        [MBProgressHUD cus_showMessage:@"评论内容超过字数上限"];
        return;
    }
    
    _isHaveText = YES;
    self.placeLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:emoji.imageName];
    UIImage *emojiImage = image;
    if (!emojiImage) {
        return;
    }
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location > (100-1)) {
        return;
    }
    NSString *emojiString = emoji.emojiDescription;
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];
    [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.textView.attributedText = attributedText;
    self.textView.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);
    [self textViewDidChange:self.textView];
}

//把表情描述 转换成表情图标
- (void)refreshTextUI
{
    if (!self.textView.text.length) {
        return;
    }
    UITextRange *markedTextRange = [self.textView markedTextRange];
    UITextPosition *position = [self.textView positionFromPosition:markedTextRange.start offset:0];
    if (position) {
        return;     // 正处于输入拼音还未点确定的中间状态
    }
    UIFont *textFont = kFontPFMedium(15);
    UIColor *textColor = UIColorLightAndDark(UIColorHexRGBA(0x555555, 1), UIColorHexRGBA(0xffffff, 0.9));
    NSRange selectedRange = self.textView.selectedRange;
    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:self.plainText attributes:@{ NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor}];
    // 匹配表情 根据表情描述
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attributedComment font:textFont];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];
    NSUInteger offset = self.textView.attributedText.length - attributedComment.length;
    self.textView.attributedText = attributedComment;
    self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
    
    CGFloat textViewW = self.textView.frame.size.width - self.textView.textContainerInset.left - self.textView.textContainerInset.right - 2;
    CGFloat h = ceilf([attributedComment.string ydd_textSize:CGSizeMake(textViewW, 1000) font:textFont].height);
    h = h > 30 ? h : 30;

    if (h > 132) {
        h = 132;
    }

    h += (self.inputViewHeight - 30);
    if (fabs(h - self.keyBoardHeight) >= 1 ) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h - (self.inputViewHeight - 30));
        }];
        self.keyBoardHeight = h;
        [self moveInputContentViewWithBottomDistance:_bottomDistance andKeyBoardHeight:self.keyBoardHeight animationDuration:0.25];
    }
}

/// 暂时不用
- (void)stickerKeyboardDidClickSendButton:(PPStickerKeyboard *)stickerKeyboard{
    
}

- (NSString *)plainText
{
    //表情算一个字符 以富文本形式统计
    return [self.textView.attributedText pp_plainTextForRange:NSMakeRange(0, self.textView.attributedText.length)];
}

//点击表情键盘上的删除按钮
- (void)stickerKeyboardDidClickDeleteButton:(PPStickerKeyboard *)stickerKeyboard
{
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        NSUInteger deleteCharactersCount = 1;
        
        // 下面这段正则匹配是用来匹配文本中的所有系统自带的 emoji 表情，以确认删除按钮将要删除的是否是 emoji。这个正则匹配可以匹配绝大部分的 emoji，得到该 emoji 的正确的 length 值；不过会将某些 combined emoji（如 👨‍👩‍👧‍👦 👨‍👩‍👧‍👦 👨‍👨‍👧‍👧），这种几个 emoji 拼在一起的 combined emoji 则会被匹配成几个个体，删除时会把 combine emoji 拆成个体。瑕不掩瑜，大部分情况下表现正确，至少也不会出现删除 emoji 时崩溃的问题了。
        NSString *emojiPattern1 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900-\\U0001F9FF]";
        NSString *emojiPattern2 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF]\\uFE0F";
        NSString *emojiPattern3 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF][\\U0001F3FB-\\U0001F3FF]";
        NSString *emojiPattern4 = @"[\\rU0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]";
        NSString *pattern = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@", emojiPattern4, emojiPattern3, emojiPattern2, emojiPattern1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:attributedText.string options:kNilOptions range:NSMakeRange(0, attributedText.string.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.range.location + match.range.length == selectedRange.location) {
                deleteCharactersCount = match.range.length;
                break;
            }
        }
        
        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - deleteCharactersCount, deleteCharactersCount)];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
    }
    
    [self textViewDidChange:self.textView];
}

#pragma mark - lazy
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#151416"];
        _bgView.layer.masksToBounds = YES;
//        _bgView.layer.shadowColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
//        _bgView.layer.shadowOffset = CGSizeMake(0,-1);
//        _bgView.layer.shadowOpacity = 1;
//        _bgView.layer.shadowRadius = 0;
    }
    return _bgView;
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.bounces = NO;
        _textView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (UILabel *)placeLabel{
    if (_placeLabel == nil) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.text = @"添加评论，说点儿好听的呗～";
        _placeLabel.font = kFontPF(15);
    }
    return _placeLabel;
}

- (UIButton *)emojiButton{
    if (_emojiButton == nil) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = kFontPF(15);
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 4;
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
//表情键盘
- (PPStickerKeyboard *)emotionKeyboard {
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[PPStickerKeyboard alloc] init];
        _emotionKeyboard.frame = CGRectMake(0,0, CGRectGetWidth([UIScreen mainScreen].bounds), [_emotionKeyboard heightThatFits]+kSafeBottom);
        _emotionKeyboard.delegate = self;
    }
    
    return _emotionKeyboard;
}

- (UIButton *)levelButton{
    if (_levelButton == nil) {
        _levelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_levelButton addTarget:self action:@selector(levelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _levelButton;
}

- (BOOL)isShowKeyBoard{
   return self.textView.isFirstResponder;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHexRGBA(0x888888, 0.1);
    }
    return _lineView;
}

@end
