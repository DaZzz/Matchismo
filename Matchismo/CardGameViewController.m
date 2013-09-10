//
//  CardGameViewController.m
//  Matchismo
//
//  Created by DaZzz on 05.09.13.
//  Copyright (c) 2013 DaZzz inc. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic) int mode;

@end

@implementation CardGameViewController

#define TWO_MATCH_MODE 2
#define THREE_MATCH_MODE 3

-(int)mode
{
    if (!_mode) _mode = TWO_MATCH_MODE;
    return _mode;
}


- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]
                                                            andMode:self.mode];
    return _game;
}

- (IBAction)modeChanged:(UISegmentedControl *)sender {
    self.mode = [sender selectedSegmentIndex] == 0 ? TWO_MATCH_MODE : THREE_MATCH_MODE;
    
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[[PlayingCardDeck alloc] init]
                                                andMode:self.mode];
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.stateLabel.text = [self.game flipCardAtIndex: [self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)redealCards:(UIButton *)sender
{
    self.game = nil;
    self.stateLabel.text = @"Cards were re-dealed!";
    self.flipCount = 0;
    [self updateUI];
    
}

@end
