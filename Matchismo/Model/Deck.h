//
//  Deck.h
//  Matchismo
//
//  Created by Leonid Batizhevsky on 27.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (NSMutableArray *)cards ;

@end
