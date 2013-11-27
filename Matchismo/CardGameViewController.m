//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Leonid Batizhevsky on 26.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@end

@implementation CardGameViewController

- (IBAction)touchCardButton:(UIButton *)sender {
    [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                      forState:UIControlStateNormal];
    [sender setTitle:@"" forState:UIControlStateNormal];
}

@end
