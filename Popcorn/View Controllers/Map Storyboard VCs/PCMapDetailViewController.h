//
//  PCMapDetailViewController.h
//  Popcorn
//
//  Created by Rucha Patki on 8/2/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCMapDetailViewController : UIViewController

@property (strong, nonatomic) NSArray *moviesPlaying;
@property (strong, nonatomic) NSDictionary *theatreInfo;
@property (nonatomic, copy) NSString *theatreTitle;
@property (strong, nonatomic) NSString *rating;

@end
