//
//  PlayingCard.h
//  Matchismo
//
//  Created by DaZzz on 05.09.13.
//  Copyright (c) 2013 DaZzz inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
