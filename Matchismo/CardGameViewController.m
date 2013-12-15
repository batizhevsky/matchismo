//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Leonid Batizhevsky on 26.11.13.
//  Copyright (c) 2013 Leonid Batizhevsky. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLog;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfCardsSelector;
@end

@implementation CardGameViewController

- (IBAction)cardMarchMode:(UISegmentedControl *)sender {
    NSLog(@"selected segment %d", [sender selectedSegmentIndex]);
    [self resetNumberOfCards:sender];
}

- (void)resetNumberOfCards:(UISegmentedControl *)segmentControl{
    if ([segmentControl selectedSegmentIndex] == 0)
        self.game.numberOfCards = 2;
    else
        self.game.numberOfCards = 3;
}

- (IBAction)resetGame:(UIButton *)sender{
    [self setGame:[self createGame]];
    [self resetNumberOfCards:self.numberOfCardsSelector];
    [self.numberOfCardsSelector setEnabled:TRUE];
    [self updateUi];
}

- (CardMatchingGame *)createGame {
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
}


- (CardMatchingGame *)game {
    if (!_game) _game = [self createGame];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)startGameIfNot{
    if (![self.game isStarted]) {
        [self.game start];
        [self.numberOfCardsSelector setEnabled:FALSE];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    [self startGameIfNot];
    
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    self.actionLog.text = self.game.actionLog;

    [self updateUi];
}

- (void)updateUi {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}
- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
@end
