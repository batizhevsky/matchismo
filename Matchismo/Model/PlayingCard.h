//
//  PlayingCard.h
//  Matchismo
//
//  Created by Leonid Batizhevsky on 27.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import "Card.h"
@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
@end
