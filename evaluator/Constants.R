#!/usr/bin/env python
# encoding: utf-8

#Constants.R

#Created by Kenneth J. Shackleton on 14 June 2011.
#Copyright (c) 2011 Ringo Limited.
#All rights reserved.
#R Port by Zach Mayer on 4 December 2011

DECK_SIZE = 52

INDEX_OF_SEVEN_OF_SPADES = 32
INDEX_OF_EIGHT_OF_CLUBS = 31

NUMBER_OF_SUITS = 4
NUMBER_OF_FACES = 13

SPADE = 0
HEART = 1
DIAMOND = 8
CLUB = 57

TWO_FIVE = 0
THREE_FIVE = 1
FOUR_FIVE = 5
FIVE_FIVE = 22
SIX_FIVE = 94
SEVEN_FIVE = 312
EIGHT_FIVE = 992
NINE_FIVE = 2422
TEN_FIVE = 5624
JACK_FIVE = 12522
QUEEN_FIVE = 19998
KING_FIVE = 43258
ACE_FIVE = 79415

TWO_FLUSH = 1
THREE_FLUSH = 2
FOUR_FLUSH = 4
FIVE_FLUSH = 8
SIX_FLUSH = 16
SEVEN_FLUSH = 32
EIGHT_FLUSH = 64
NINE_FLUSH = (EIGHT_FLUSH+SEVEN_FLUSH+SIX_FLUSH+FIVE_FLUSH+FOUR_FLUSH+THREE_FLUSH+TWO_FLUSH+1)	#128
TEN_FLUSH = (NINE_FLUSH+EIGHT_FLUSH+SEVEN_FLUSH+SIX_FLUSH+FIVE_FLUSH+FOUR_FLUSH+THREE_FLUSH+1)	#255
JACK_FLUSH = (TEN_FLUSH+NINE_FLUSH+EIGHT_FLUSH+SEVEN_FLUSH+SIX_FLUSH+FIVE_FLUSH+FOUR_FLUSH+1)	#508
QUEEN_FLUSH = (JACK_FLUSH+TEN_FLUSH+NINE_FLUSH+EIGHT_FLUSH+SEVEN_FLUSH+SIX_FLUSH+FIVE_FLUSH+1)	#1012
KING_FLUSH = (QUEEN_FLUSH+JACK_FLUSH+TEN_FLUSH+NINE_FLUSH+EIGHT_FLUSH+SEVEN_FLUSH+SIX_FLUSH+1)	#2016
ACE_FLUSH = (KING_FLUSH+QUEEN_FLUSH+JACK_FLUSH+TEN_FLUSH+NINE_FLUSH+EIGHT_FLUSH+SEVEN_FLUSH+1)	#4016

#_SEVEN tag suppressed
TWO = 0
THREE = 1
FOUR = 5
FIVE = 22
SIX = 98
SEVEN = 453
EIGHT = 2031
NINE = 8698
TEN = 22854
JACK = 83661
QUEEN = 262349
KING = 636345
ACE = 1479181
#end of _SEVEN tag suppressed

MAX_FIVE_NONFLUSH_KEY_INT = ((4*ACE_FIVE)+KING_FIVE)
MAX_FIVE_FLUSH_KEY_INT = (ACE_FLUSH+KING_FLUSH+QUEEN_FLUSH+JACK_FLUSH+TEN_FLUSH)
MAX_SEVEN_FLUSH_KEY_INT = (ACE_FLUSH+KING_FLUSH+QUEEN_FLUSH+JACK_FLUSH+TEN_FLUSH+NINE_FLUSH+EIGHT_FLUSH)
MAX_NONFLUSH_KEY_INT = ((4*ACE)+(3*KING))

MAX_FLUSH_CHECK_SUM = (7*CLUB)

L_WON = -1
R_WON = 1
DRAW = 0

CIRCUMFERENCE_FIVE = 187853
CIRCUMFERENCE_SEVEN = 4565145
#/////////
#//The following are used with NSAssert for
#//debugging, ignored by release mode
RANK_OF_A_WORST_HAND = 0
RANK_OF_A_BEST_HAND = 7462
RANK_OF_WORST_FLUSH = 5864
RANK_OF_BEST_NON_STRAIGHT_FLUSH = 7140
RANK_OF_WORST_STRAIGHT = 5854
RANK_OF_BEST_STRAIGHT = 5863
RANK_OF_WORST_STRAIGHT_FLUSH = 7453
RANK_OF_BEST_STRAIGHT_FLUSH = RANK_OF_A_BEST_HAND

KEY_COUNT = 53924
NON_FLUSH_KEY_COUNT = 49205
FLUSH_KEY_COUNT = 4719
#/////////

#Used in flush checking. These must be distinct from each of the suits.
UNVERIFIED = -2
NOT_A_FLUSH = -1
#/////////

#Bit masks
SUIT_BIT_MASK = 511
NON_FLUSH_BIT_SHIFT = 9
#/////////
