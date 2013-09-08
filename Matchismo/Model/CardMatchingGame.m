//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by DaZzz on 07.09.13.
//  Copyright (c) 2013 DaZzz inc. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; ++i) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            }
            else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MATCH_PENALTY 2
#define FLIP_COST 1
- (NSString *)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *state = [NSString stringWithFormat:@"Flipped down %@", card.contents];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            state = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        state = [NSString stringWithFormat:@"Matched %@ with %@ for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }
                    else {
                        state = [NSString stringWithFormat:@"%@ & %@ don't match %d points penalty!", card.contents, otherCard.contents, MATCH_PENALTY];
                        otherCard.faceUp = NO;
                        self.score -= MATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
    return state;
}
@end
