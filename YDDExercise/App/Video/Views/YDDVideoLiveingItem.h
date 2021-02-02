//
//  YDDVideoLiveingItem.h
//  YDDExercise
//
//  Created by ydd on 2020/6/19.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDDVideoLiveingItem : UIView

@property (nonatomic, assign) NSInteger unreadCount;

@property (nonatomic, assign) BOOL hasLiveing;

- (void)clearLiveItem;

@end

NS_ASSUME_NONNULL_END
