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
@property (strong, nonatomic) NSMutableArray *otherCards; // of Card
@property (nonatomic) NSUInteger mode;
@end

@implementation CardMatchingGame

- (NSMutableArray *)otherCards {
    if (!_otherCards) _otherCards = [[NSMutableArray alloc] init];
    return _otherCards;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMode:(NSUInteger)mode
{
    self = [super init];
    if (self) {
        self.mode = mode;
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
- (NSString *)flipCardAtIndex:(NSUInteger)index {
    Card* card = [self cardAtIndex:index];
    NSString *state = [NSString stringWithFormat:@"Flipped down %@", card.contents];
    if (!card.isUnplayable) {
        if (!card.faceUp) {
            state = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            card.faceUp = YES;
            self.score -= FLIP_COST;
            if ([self.otherCards count]  == self.mode - 1 ) {
                int matchScore = [card match:self.otherCards];
                if (matchScore > 0) {
                    state = [NSString stringWithFormat:@"Matched %@ & %@ for %d points!",
                             card.contents, [[self.otherCards valueForKeyPath:@"contents"] componentsJoinedByString:@" & "],
                             matchScore * MATCH_BONUS];
                    card.unplayable = YES;
                    for (Card *otherCard in self.otherCards) {
                        otherCard.unplayable = YES;
                    }
                    [self.otherCards removeAllObjects];
                    self.score += matchScore * MATCH_BONUS;
                }
                else if (matchScore < 0) {
                    state = [NSString stringWithFormat:@"%@ & %@ don't match! %d points penalty!",
                             card.contents, [[self.otherCards valueForKeyPath:@"contents"] componentsJoinedByString:@" & "],
                             matchScore * MATCH_PENALTY];
                    for (Card *otherCard in self.otherCards) {
                        otherCard.faceUp = NO;
                    }
                    [self.otherCards removeAllObjects];
                    [self.otherCards addObject:card];
                    self.score += matchScore * MATCH_PENALTY;
                }
            }
            else {
                [self.otherCards addObject:card];
            }
        }
        else {
            card.faceUp = NO;
            [self.otherCards removeObjectIdenticalTo:card];
        }
    }
    return state;
}

@end
