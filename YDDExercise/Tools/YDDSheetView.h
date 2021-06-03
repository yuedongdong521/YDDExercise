//
//  KXLiveSheetView.h
//  KXLive
//
//  Created by ydd on 2021/5/18.
//  Copyright © 2021 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDSheetModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL hasLine;

@property (nonatomic, assign) BOOL isFooter;

@property (nonatomic, assign) CGFloat height;

@end


@interface YDDSheetView : UIView

+ (YDDSheetView *)showWithItems:(NSArray<YDDSheetModel*>*)items selected:(void(^)(YDDSheetModel *model))selected;


@end

NS_ASSUME_NONNULL_END
