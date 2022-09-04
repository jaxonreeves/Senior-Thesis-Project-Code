rm(list = ls(all = TRUE))
setwd('~/SpecialK/R')
source('Evaluator/Constants.R')
source('Evaluator/FiveEval.R')
source('Evaluator/SevenEval.R')

#Convert human-readable cards to integers
card <- function(x) {
allCards <- paste(
        do.call(c,lapply(c('A','K','Q','J','T',9:2),function(x) rep(x,4))),
        c('s','h','d','c'), sep='')

  which(allCards==x)-1
}
card('As')
card('2d')

#Wrapper for the evaluator
evaluate <- function(hand) {
  hand <- do.call(c,lapply(hand,card))
  SevenEval$getRankOfSeven(hand[1], hand[2], hand[3], hand[4], hand[5], hand[6], hand[7])
}
evaluate(c('As','Ks','Qs','Js','Ts','8d','7d'))
evaluate(c('As','Ks','Qs','Td','9d','8d','7d'))
evaluate(c('7s','6s','5s','4s','2d','9d','Td'))

#Generate 10,000 random hands
randomHand <- function(...) {
	sample(0:51,7)
}
n <- 10000
hands <- lapply(1:n,randomHand)

#Evaluate them!
evaluate <- function(hand) {
	SevenEval$getRankOfSeven(hand[1], hand[2], hand[3], hand[4], hand[5], hand[6], hand[7])
}
T <- system.time(lapply(hands,evaluate))
c('Hands Per Second'=as.numeric(round(n/T['elapsed'],0)))
