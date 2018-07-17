//
//  LibraryViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCLibraryViewController.h"
#import "APIManager.h"

@interface PCLibraryViewController ()

@end

@implementation PCLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapCreate:(id)sender {
    [[APIManager shared] createList:@"Shelves" completion:^(NSError *error) {
        if(error){
            NSLog(@"Error creating list: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully created list");
        }
    }];
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
