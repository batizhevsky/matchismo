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
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *actionHistory;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfCardsSelector;
@end

@implementation CardGameViewController

- (IBAction)historySliderChanged:(UISlider *)sender {
    if ([self.actionHistory count]) {
        int currentPostition = floor(sender.value);
        self.actionLog.text = [self.actionHistory objectAtIndex:currentPostition-1];
        if (currentPostition == [self.actionHistory count])
            self.actionLog.alpha = 1.0;
        else
            self.actionLog.alpha = 0.3;
        NSLog(@"%d of %d", currentPostition, [self.actionHistory count]);
    }
}

- (NSMutableArray *)actionHistory {
    if (!_actionHistory) _actionHistory = [[NSMutableArray alloc] init];
    return _actionHistory;
}

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
    [self addToLog:self.game.actionLog];

    [self updateUi];
}

- (void)addToLog:(NSString *)actionLog{
    self.actionLog.text = actionLog;
    [self.actionHistory addObject:actionLog];
    NSLog(@"%@", self.actionHistory);
    [self.historySlider setMaximumValue:[self.actionHistory count]];
    [self.historySlider setValue:[self.actionHistory count]];
    self.actionLog.alpha = 1.0;
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
