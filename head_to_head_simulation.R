library(tidyverse) # for data wrangling and plotting
source('evaluator/Constants.R')
source('evaluator/FiveEval.R')
source('evaluator/SevenEval.R') # takes a while

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

# Define function to run an individual head-to-head comparison and
# return category1 win rate. Chooses n many pairs of starting hands from
# the given categories and then simulates m many rounds with each pair of
# starting hands, for a total of n*m many rounds simulated. Returns the
# average win rate of category1 across all n*m many rounds
head_to_head_comparison <- function(category1, category2, n, m) {
    # Select specified starting hand categories
    player1_category <- starting_hands[[category1]]
    player2_category <- starting_hands[[category2]]

    # Run n many simulations of the head-to-head category1 vs category2
    # matchup and store category1 win rates
    category1_win_rates <- replicate(n, expr = {
        # Deal two players starting hands from chosen category and ensure no duplicate cards
        player1 <- sample(player1_category,1)[[1]]
        player2 <- sample(player2_category,1)[[1]]
        starter_hands <- list(player1 = player1, player2 = player2)
        while (any(duplicated(unlist(starter_hands)))) {
            player2 <- sample(player2_category,1)[[1]]
            starter_hands <- list(player1 = player1, player2 = player2)
        }

        # Convert the starter hands to numeric
        starter_hands <- lapply(starter_hands, function(x){
            as.numeric(deck_numeric[x])
        })
        all(!duplicated(unlist(starter_hands) )) # check: are all cards unique? (should be TRUE)
        remaining_cards <- setdiff(0:51, unlist(starter_hands))

        # Run m many simulations of the next 4 cards for each player
        hands4 <- lapply(1:m, function(x){
            sample(remaining_cards, 4)
        })
        hands_player1 <- sapply(hands4, function(x){ 
                                    evaluate_7cards(c(starter_hands$player1, x))
                                })
        hands_player2 <- sapply(hands4, function(x){ 
                                    evaluate_7cards(c(starter_hands$player2, x))
                                })

        # Compare winners across all m rounds and return win rate for player1
        results <- data.frame(player1 = hands_player1, player2 = hands_player2 ) |> 
                              mutate(winner = ifelse(player1 > player2, "player 1", "player 2")) |>
                              count(winner)
        results$n[1]/m
    })

    # Compute and return average win rate
    return(mean(category1_win_rates))
}

# Define function to run all 36 possible pairings of head-to-head matchups
# and return dataframe of results. Chooses n many pairs of starting hands
# and simulates m many rounds for each pair.
run_all_comparisons <- function(n, m) {
    # Initialize dataframe
    results_table <- data.frame(matrix(ncol = 6, nrow = 6))
    colnames(results_table) <- c("    1  ", "    2  ", "    3  ",
                                 "    4  ", "    5  ", "    6  ")
    rownames(results_table) <- c("        Rolled Up | 1 |", "            Pairs | 2 |",
                                 "  Three Big Cards | 3 |", "Three to Straight | 4 |",
                                 "  Two to Straight | 5 |", "        High Card | 6 |")

    # Populate results_table
    for (i in 1:6) {
        for (j in 1:6) {
            results_table[[j]][i] <- head_to_head_comparison(i, j, n, m)
            cat(paste("Comparison", (i-1)*6+j, "of 36 done...\n"))
        }
    }
    cat("Results:\n")

    # Return results_table
    return(results_table)
}

# Run single head-to-head simulation (takes a while)
#head_to_head_comparison(1, 1, 10000, 100)

# Run all head-to-head simulations (takes a very long time)
run_all_comparisons(1000, 100)
