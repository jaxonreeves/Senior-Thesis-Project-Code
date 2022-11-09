#declare faces and suits
faces <- c('A','K','Q','J','T',9:2)
suits <- c('s','h','d','c')

#populate deck
deck <- c()
for (i in 1:13) {
    for (j in 1:4) {
        deck[length(deck)+1] <- paste(faces[i],suits[j],sep="")
    }
}

#populate all possible starting hands
hands <- list()
for (i in 1:50) {
    for (j in (i+1):51) {
        for (k in (j+1):52) {
            hands[[length(hands)+1]] <- c(deck[i],deck[j],deck[k])
        }
    }
}

#define function to check for each type
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

#sort all possible starting hands
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

#verify lengths of sorted hands
length(hands)
length(rolled_up)
length(pairs)
length(three_big_cards)
length(three_to_straight)
length(two_to_straight)
length(high_card)
