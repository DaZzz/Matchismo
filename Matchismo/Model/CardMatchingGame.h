//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by DaZzz on 07.09.13.
//  Copyright (c) 2013 DaZzz inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (NSString *)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;

@end
