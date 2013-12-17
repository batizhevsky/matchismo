//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Leonid Batizhevsky on 29.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import "CardMatchingGame.h"
@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) BOOL started;
@property (nonatomic, readwrite) NSString *actionLog;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (NSInteger)numberOfCards{
    if (!_numberOfCards) _numberOfCards = 2;
    return _numberOfCards;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (void)start {
    self.started = YES;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.started = FALSE;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_OF_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    self.actionLog = [[NSString alloc] initWithFormat:@"Log: %@", card];

    
    if (card.isChosen) {
        card.chosen = NO;
    } else {
        NSMutableArray *matchCards = [[NSMutableArray alloc] init];
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.isMatched) {
                 [matchCards addObject:otherCard];
            }
            
            if ([matchCards count] == (self.numberOfCards - 1)){
                [self scoreCalculator:card matchedCards:matchCards];
                break;
            }
        }
        self.score -= COST_OF_CHOOSE;
        card.chosen = YES;
    }

}

- (void)scoreCalculator:(Card *)currentCard matchedCards:(NSArray *)matchedCards{
    int matchScore = [currentCard match:matchedCards];
    NSArray *allCards = [matchedCards arrayByAddingObject:currentCard];
    if (matchScore) {
        int points = matchScore * MATCH_BONUS;
        self.score +=points;
        
        for (Card *card in matchedCards) {
            card.matched = YES;
        }
        
        currentCard.matched = YES;
        self.actionLog = [[NSString alloc] initWithFormat:@"Log: Matched %@ for %d points.", [allCards componentsJoinedByString:@" & "], points];
    } else {
        self.score -= MISMATCH_PENALTY;
        for (Card *card in matchedCards) {
            card.chosen = NO;
        }
        self.actionLog = [[NSString alloc] initWithFormat:@"Log: %@ don’t match! %d point penalty!", [allCards componentsJoinedByString:@" & "], MISMATCH_PENALTY];
    }
}

@end
