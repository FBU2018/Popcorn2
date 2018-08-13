//
//  ShelfPickerCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShelfPickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shelfLabel;
-(void) configureCell: (NSDictionary *)selectedShelf;

@end
