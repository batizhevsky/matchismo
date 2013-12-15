//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Leonid Batizhevsky on 29.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer 
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)start;
@property (nonatomic) NSInteger numberOfCards;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSString *actionLog;
@property (nonatomic, getter = isStarted, readonly) BOOL started;
@end
