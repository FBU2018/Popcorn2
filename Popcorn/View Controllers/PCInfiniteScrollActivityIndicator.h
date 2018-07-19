//
//  PCInfiniteScrollActivityIndicator.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/18/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCInfiniteScrollActivityIndicator : UIView
@property (class, nonatomic, readonly) CGFloat defaultHeight;
- (void)startAnimating;
- (void)stopAnimating;
@end
