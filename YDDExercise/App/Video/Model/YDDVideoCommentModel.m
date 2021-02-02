//
//  YDDVideoCommentModel.m
//  YDDExercise
//
//  Created by ydd on 2020/6/22.
//  Copyright © 2020 ibobei. All rights reserved.
//

#import "YDDVideoCommentModel.h"
#import "YDDVideoCommentTableViewCell.h"
#import "PPStickerDataManager.h"

@implementation YDDVideoCommentModel


- (NSAttributedString *)contentAtt
{
    if (!self.content) {
        return nil;
    }
    if (_contentAtt.length > 0) {
        return _contentAtt;
    }
    
    NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc] initWithString:self.content];
    // 匹配表情 根据表情描述
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:mutAtt font:kFontPF(14)];
    
    [mutAtt addAttributes:@{NSFontAttributeName : kFontPF(14), NSForegroundColorAttributeName :UIColorLightAndDark(UIColorHexRGBA(0x333333, 1), UIColorHexRGBA(0xFFFFFF, 0.9))} range:NSMakeRange(0, mutAtt.length)];
    
    if ([self.type isEqualToString:@"REPLY"]) { //回复

        NSMutableAttributedString *replyArr = [[NSMutableAttributedString alloc] initWithString:@"回复 "];
        [replyArr addAttributes:@{NSFontAttributeName : kFontPF(14), NSForegroundColorAttributeName : UIColorLightAndDark(UIColorHexRGBA(0x333333, 1), UIColorHexRGBA(0xFFFFFF, 0.9))} range:NSMakeRange(0, replyArr.length)];
        NSString *name = [NSString stringWithFormat:@"%@ ", self.targetNickName];
        NSMutableAttributedString *attStrName = [[NSMutableAttributedString alloc] initWithString:name];
        [attStrName addAttributes:@{NSFontAttributeName : kFontPF(14), NSForegroundColorAttributeName :UIColorLightAndDark(UIColorHexRGBA(0x333333, 1), UIColorHexRGBA(0xFFFFFF, 0.9))} range:NSMakeRange(0,attStrName.length)];
        [replyArr appendAttributedString:attStrName];
       [mutAtt insertAttributedString:replyArr atIndex:0];
    }
    
    if (self.timestamp.length > 0) {
        long long time = [self.timestamp longLongValue];
        NSString *timeStr = [self getFormattedDateTimeStrWith:time];
        
        NSAttributedString *timeAtt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", timeStr] attributes:@{NSFontAttributeName : kFontPF(12), NSForegroundColorAttributeName :UIColorLightAndDark(UIColorHexRGBA(0x888888, 1), UIColorHexRGBA(0x888888, 0.9))}];
        [mutAtt appendAttributedString:timeAtt];
    }
    
    return mutAtt;
}

- (CGFloat)contentHeight
{
    if (_contentHeight > 0) {
        return _contentHeight;
    }
    
    _contentHeight = ceil([self.contentAtt boundingRectWithSize:CGSizeMake([YDDVideoCommentTableViewCell contentMaxWidth], 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height);
    if (_contentHeight < 20) {
        _contentHeight = 20;
    }
    return _contentHeight;
}

- (NSString *)getFormattedDateTimeStrWith:(long long)timeInterval{
    
    long long timeStamp = timeInterval;
    if (timeInterval > 9999999999) {
        timeStamp = timeInterval/1000.0;
    }
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    NSString *dateString = @"";
    
    if ([timeDate isToday]) {
        [timeFormatter setDateFormat:@"HH:mm"];
        dateString = [timeFormatter stringFromDate:timeDate];
    } else {
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"yyyy-"];
        NSString *currentYear = [todayFormatter stringFromDate:todayDate];
        
        [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateString = [timeFormatter stringFromDate:timeDate];
        if ([dateString containsString:currentYear]) { // 今年
            dateString = [dateString stringByReplacingOccurrencesOfString:currentYear withString:@""];
        }else{ //不是今年
            
        }
    }
    return dateString;
}


@end


@implementation KXVideoCommentListModel



@end
