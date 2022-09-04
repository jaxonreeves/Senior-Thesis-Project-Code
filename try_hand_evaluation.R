# starter code for using an existing poker hand evaluation library to 
#    estimate the head-to-head probability of two starter hands 
#    in seven card stud poker

library(tidyverse) # for data wrangling and plotting
source('evaluator/Constants.R')
source('evaluator/FiveEval.R')
source('evaluator/SevenEval.R') # takes awhile

# we want to be able to convert betwee human-readable cards & integers
faces <- c('A','K','Q','J','T',9:2)
suits <- c('s','h','d','c')

deck <- paste(rep(faces, each = length(suits)), 
              rep(suits, times = length(faces)), sep = "")
deck_numeric <- 0:(length(deck)-1)
names(deck_numeric) <- deck

deck_numeric['As']
deck_numeric['Qs']

# function to evaluate a hand of 7 cards
evaluate_7cards <- function(hand) {
  
  # if necessary, convert the cards to numeric
  if(any(!is.numeric(hand))){
    hand <- deck_numeric[hand]
  }
  # evaluate the hand using SevenEval 
  #   (bigger score means a better hand)
  SevenEval$getRankOfSeven(hand[1], hand[2], hand[3], hand[4],
                           hand[5], hand[6], hand[7])
}
evaluate_7cards(c('As','Ks','Qs','Js','Ts','8d','7d')) # good hand = high score
evaluate_7cards(c('2s','4s','6s','8c','3h','9h','7d')) # bad hand = low score


## ESTIMATE HEAD TO HEAD PROBABILITY
# deal two players 3 cards each
starter_hands <- list(player1 = c("As", "Ah", "2c"), # high pair
                      player2 = c("8h", "9h", "Th") # suited connectors
                      )

# convert the starter hands to numeric
starter_hands <- lapply(starter_hands, function(x){
  as.numeric(deck_numeric[x])
})
all(!duplicated(unlist(starter_hands) )) # check: are all cards unique? 
# (should be TRUE)
remaining_cards <- setdiff(0:51, unlist(starter_hands) )

# how many random hands?
n <- 10000 # sample size

# simulate the next 4 cards
hands4 <- lapply(1:n, function(x){
  sample(remaining_cards, 4)
  
})

hands_player1 <- sapply(hands4, 
                        function(x){ 
                          evaluate_7cards(c(starter_hands$player1, x))
})
    
hands_player2 <- sapply(hands4, 
                        function(x){ 
                          evaluate_7cards(c(starter_hands$player2, x))
                        })

# compare winners
data.frame(player1 = hands_player1, 
           player2 = hands_player2 ) |> 
  mutate(winner = ifelse(player1 > player2, "player 1", "player 2")) |> 
  count(winner)

  
