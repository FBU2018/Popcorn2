//
//  ShelfPickerCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ShelfPickerCell.h"

@implementation ShelfPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void) configureCell:(NSDictionary *)selectedShelf{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView = backgroundView;
    
    self.shelfLabel.text = selectedShelf[@"name"];
}
@end
