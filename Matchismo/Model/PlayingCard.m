//
//  PlayingCard.m
//  Matchismo
//
//  Created by Leonid Batizhevsky on 27.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int totatlScore = 0;
    
    for (PlayingCard *card in otherCards) {
        
        if (card.rank == self.rank) {
            totatlScore += 4;
        } else if ([card.suit isEqualToString:self.suit]) {
            totatlScore += 1;
        }
    }
    
    return totatlScore;
}



- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
}

- (NSString *)description {
    return self.contents;
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
