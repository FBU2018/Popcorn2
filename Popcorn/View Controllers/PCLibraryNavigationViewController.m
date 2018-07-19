//
//  PCLibraryNavigationViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCLibraryNavigationViewController.h"

@interface PCLibraryNavigationViewController ()

@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarItem;


@end

@implementation PCLibraryNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize imageSize = CGSizeMake(30, 30);
    UIImage *resizedImage = [self imageWithImage:[UIImage imageNamed:@"shelf"] convertToSize:imageSize];
    self.tabBarItem.image = resizedImage;

}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
