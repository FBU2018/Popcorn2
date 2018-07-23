//
//  PCSafariLoginViewController.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/23/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCSafariLoginViewController.h"
#import <SafariServices/SafariServices.h>

@interface PCSafariLoginViewController () <SFSafariViewControllerDelegate>

@end

@implementation PCSafariLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *testUrl = [NSURL URLWithString:@"https://www.facebook.com"];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:testUrl];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
}

// Method that is called when the Safari VC needs to be dismissed
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
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
