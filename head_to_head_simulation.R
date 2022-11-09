library(tidyverse) # for data wrangling and plotting
source('evaluator/Constants.R')
source('evaluator/FiveEval.R')
source('evaluator/SevenEval.R') # takes awhile

# Create deck with human-readable cards and numeric version for computing
faces <- c('A','K','Q','J','T',9:2)
suits <- c('s','h','d','c')
deck <- paste(rep(faces, each = length(suits)), 
              rep(suits, times = length(faces)), sep = "")
deck_numeric <- 0:(length(deck)-1)
names(deck_numeric) <- deck

# Define function to evaluate a hand of 7 cards
evaluate_7cards <- function(hand) {
  # If necessary, convert the cards to numeric
  if(any(!is.numeric(hand))){
    hand <- deck_numeric[hand]
  }
  # Evaluate the hand using SevenEval (bigger score means a better hand)
  SevenEval$getRankOfSeven(hand[1], hand[2], hand[3], hand[4],
                           hand[5], hand[6], hand[7])
}

# Generate all possible starting hands
hands <- list()
for (i in 1:50) {
    for (j in (i+1):51) {
        for (k in (j+1):52) {
            hands[[length(hands)+1]] <- c(deck[i],deck[j],deck[k])
        }
    }
}

# Define function to check for each category of starting hand
is_rolled_up <- function(hand) {
    return((substr(hand[1],1,1) == substr(hand[2],1,1)) &&
           (substr(hand[2],1,1) == substr(hand[3],1,1)))
}
is_pairs <- function(hand) {
    return((substr(hand[1],1,1) == substr(hand[2],1,1)) ||
           (substr(hand[1],1,1) == substr(hand[3],1,1)) ||
           (substr(hand[2],1,1) == substr(hand[3],1,1)))
}
is_three_big_cards <- function(hand) {
    return((substr(hand[1],1,1) %in% c('A','K','Q','J','T')) &&
           (substr(hand[2],1,1) %in% c('A','K','Q','J','T')) &&
           (substr(hand[3],1,1) %in% c('A','K','Q','J','T')))
}
is_three_to_straight <- function(hand) { #note: deck is strictly descending order
    return(((match(substr(hand[3],1,1),faces)-match(substr(hand[2],1,1),faces)) == 1) &&
           ((match(substr(hand[2],1,1),faces)-match(substr(hand[1],1,1),faces)) %in% c(1, 11))) # special case of 'A', '2', and '3'
}
is_two_to_straight <- function(hand) { #note: deck is strictly descending order
    return(((match(substr(hand[3],1,1),faces)-match(substr(hand[2],1,1),faces)) == 1) ||
           ((match(substr(hand[3],1,1),faces)-match(substr(hand[1],1,1),faces)) == 12) || # special case of 'A' and '2'
           ((match(substr(hand[2],1,1),faces)-match(substr(hand[1],1,1),faces)) == 1))
}

# Sort all possible starting hands and create list of categories
rolled_up <- list()
pairs <- list()
three_big_cards <- list()
three_to_straight <- list()
two_to_straight <- list()
high_card <- list()
for (i in 1:length(hands)) {
    if (is_rolled_up(hands[[i]])) {
        rolled_up[[length(rolled_up)+1]] <- hands[[i]]
    } else if (is_pairs(hands[[i]])) {
        pairs[[length(pairs)+1]] <- hands[[i]]
    } else if (is_three_big_cards(hands[[i]])) {
        three_big_cards[[length(three_big_cards)+1]] <- hands[[i]]
    } else if (is_three_to_straight(hands[[i]])) {
        three_to_straight[[length(three_to_straight)+1]] <- hands[[i]]
    } else if (is_two_to_straight(hands[[i]])) {
        two_to_straight[[length(two_to_straight)+1]] <- hands[[i]]
    } else {
        high_card[[length(high_card)+1]] <- hands[[i]]
    }
}
starting_hands <- list(rolled_up,
                       pairs,
                       three_big_cards,
                       three_to_straight,
                       two_to_straight,
                       high_card)

## RUN SIMULATION TO ESTIMATE HEAD TO HEAD PROBABILITY
# Choose starting hand categories
player1_category <- starting_hands[[1]]
player2_category <- starting_hands[[1]]

# Deal two players starting hands from chosen category
starter_hands <- list(player1 = sample(player1_category,1)[[1]],
                      player2 = sample(player2_category,1)[[1]])

# Convert the starter hands to numeric
starter_hands <- lapply(starter_hands, function(x){
  as.numeric(deck_numeric[x])
})
all(!duplicated(unlist(starter_hands) )) # check: are all cards unique? (should be TRUE)
remaining_cards <- setdiff(0:51, unlist(starter_hands))

# Define sample size n
n <- 1000

# Simulate the next 4 cards for each player
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

# Compare winners across n rounds
data.frame(player1 = hands_player1, 
           player2 = hands_player2 ) |> 
  mutate(winner = ifelse(player1 > player2, "player 1", "player 2")) |>
  count(winner)
