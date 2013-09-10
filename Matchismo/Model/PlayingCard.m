//
//  PlayingCard.m
//  Matchismo
//
//  Created by DaZzz on 05.09.13.
//  Copyright (c) 2013 DaZzz inc. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString: self.suit]) {
            score = 1;
        }
        else if (otherCard.rank == self.rank) {
            score = 4;
        }
        else {
            score = -1;
        }            
    }
    else if ([otherCards count] == 2) {
        int ranksMatched = [PlayingCard ranksMatched:[otherCards arrayByAddingObject:self]];
        int suitsMatched = [PlayingCard suitsMatched:[otherCards arrayByAddingObject:self]];
        
        if (ranksMatched == 3) {
            score = 10;
        } else if (ranksMatched == 2 && suitsMatched == 2) {
            score = 8;
        } else if (ranksMatched == 2) {
            score = 3;
        } else if (suitsMatched == 3) {
            score = 6;
        } else if (suitsMatched == 2) {
            score = 1;
        } else {
            score = -1;
        }
    }
    
    return score; 
}

+ (int)ranksMatched:(NSArray *)cards
{
    NSCountedSet *ranks = [NSCountedSet setWithArray:[cards valueForKeyPath:@"rank"]];
    
    NSNumber *maxRank = nil;
    NSUInteger maxCount = 0;
    
    for (NSNumber *rank in ranks) {
        NSUInteger rankCount = [ranks countForObject:rank];
        if (rankCount > maxCount) {
            maxRank = rank;
            maxCount = rankCount;
        }
    }
    
    return maxCount;
}

+ (int)suitsMatched:(NSArray *)cards
{
    NSCountedSet *suits = [NSCountedSet setWithArray:[cards valueForKeyPath:@"suit"]];
    
    NSString *maxSuit = nil;
    NSUInteger maxCount = 0;
    
    for (NSString *suit in suits) {
        NSUInteger suitCount = [suits countForObject:suit];
        if (suitCount > maxCount) {
            maxSuit = suit;
            maxCount = suitCount;
        }
    }
    
    return maxCount;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠",@"♣", @"♥", @"♦"];
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4",
             @"5", @"6", @"7", @"8", @"9",
             @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [PlayingCard rankStrings].count - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
