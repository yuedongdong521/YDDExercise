//
//  YDDPhotoGroupView.h
//  Yddworkspace
//
//  Created by ydd on 2019/6/27.
//  Copyright © 2019 QH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDDPhotoGroupView;

NS_ASSUME_NONNULL_BEGIN


@protocol YDDPhotoGroupViewDelegate <NSObject>
@optional
- (UIView *)YDDPhotoGroupView:(YDDPhotoGroupView*)YDDPhotoGroupView getThumbViewWithPage:(NSInteger)page;
- (UIImage *)YDDPhotoGroupView:(YDDPhotoGroupView*)YDDPhotoGroupView getImageWithPage:(NSInteger)page;

- (void)YDDPhotoGroupView:(YDDPhotoGroupView*)YDDPhotoGroupView rightActionWithPage:(NSInteger)page;


@end

/// Single picture's info.
@interface PhotoGroupItem : NSObject
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, assign) NSInteger index;
@end

/// Used to show a group of images.
/// One-shot.
@interface YDDPhotoGroupView : UIView
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES
@property (nonatomic, weak) id <YDDPhotoGroupViewDelegate>delegate;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)deletePhotoWithPage:(NSInteger)page;
- (void)updateGroupItems:(NSArray <PhotoGroupItem *>*)groupItems;

- (void)presentFromCurItem:(NSInteger)curItem
                  fromView:(UIView *)fromView
               toContainer:(UIView *)toContainer
                  animated:(BOOL)animated
                 ompletion:(void (^)(void))completion;
- (void)presentFromCurItem:(NSInteger)curItem
               toContainer:(UIView *)toContainer
                  animated:(BOOL)animated
                 ompletion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;

- (void)hiddenPageControl:(BOOL)isHidden;

- (void)hiddenTitle:(BOOL)isHidden;

- (void)hiddenRightBtn:(BOOL)isHidden;

@end


NS_ASSUME_NONNULL_END
