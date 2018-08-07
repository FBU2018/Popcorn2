//
//  myChatCell.m
//  Popcorn
//
//  Created by Ernest Omondi on 8/7/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "myChatCell.h"
#import "NSDate+DateTools.h"


@implementation myChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithChat:(Chat *)chat{
    self.myChatTextLabel.text = chat.message;
    // Set timestamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert string to date
    NSDate *date = [formatter dateFromString:chat.createdAtString];
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    // Covert Date to string and store in timestamp label
    self.timestampLabel.text = date.shortTimeAgoSinceNow;
    // Make the view a bubble
    self.bubbleView.layer.cornerRadius = 16;
    self.bubbleView.clipsToBounds = true;
}
@end
