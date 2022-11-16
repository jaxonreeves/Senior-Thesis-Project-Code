# Seven Card Stud Starting Hand Probabilities: A Senior Thesis Project

* Author: Jaxon Reeves
* Class: MATH 401
* Semester: Fall 2022
* Institution: Boise State University

## Abstract

This program was designed as a Senior Thesis project to explore
the expected win rates of the different categories of starting hands
in the poker variant Seven Card Stud. The project runs a simulation
of head-to-head matchups between the categories with support for
simulating an individual comparison as well as compiling the results
of all possible comparisons into a single table.

## Background

In the Seven Card Stud variant of poker, players are initially dealt
three cards for their starting hand, and then accumulate four more cards
to round out their hand. The point of interest for this project is the
three cards initially dealt, i.e. the starting hands.

There are 22,100 possible starting hands, which are divided into six categories. In order of best to worst, and noting the percentage of cards belonging to each
one, these categories are:

* Rolled Up - three of a kind (0.24%)
* Pairs - two of a kind (16.94%)
* Three Big Cards - three of ten, jack, queen, king, ace (2.90%)
* Three to Straight - three cards in sequence (2.61%)
* Two to Straight - two cards in sequence (32.43%)
* High Card - three cards not belonging to any previous category (44.89%)

Although the general ranking is established, exact head-to-head odds were
not published anywhere the author could find. This project was designed
to investigate the specific win rates for each of the 36 head-to-head
matchups, as well as a composite average win rate for each category.

## Structure

An R project for running a single round of Seven Card Stud with hard-coded
starting hands was found and adapted to suit this project's needs (see
references for how to acquire this starter code). This starter code included
the evaluation of which of two hands wins the round, contained in the evaluator
directory.

The simulation of head-to-head matchups is run from "head_to_head_simulation.R"
which first generates all possible starting hands and then categorizes them
accordingly into the six types. Each type is represented with an integer using the following relationships:

* 1 - Rolled Up
* 2 - Pairs
* 3 - Three Big Cards
* 4 - Three to Straight
* 5 - Two to Straight
* 6 - High Card

From there, two functions are defined to run the simulation:

* head_to_head_comparison(category1, category2, n, m)
    * runs a single head-to-head comparison
    * parameters:
        * category1 - integer from 1-6 specifying the first starting hand category
        * category2 - integer from 1-6 specifying the second starting hand category
        * n - integer specifying the number of pairs of starting hands used in the simulation
        * m - integer specifying the number of rounds simulated for each pair of starting hands
    * returns:
        * average win rate of category1
* run_all_comparisons(n, m)
    * runs all 36  head-to-head comparisons by calling head_to_head_comparison() for each
    * parameters:
        * n - integer specifying the number of pairs of starting hands used in the simulation
        * m - integer specifying the number of rounds simulated for each pair of starting hands
    * returns:
        * results of each comparison compiled into a table with the rows identified by category1 and the columns identified by category2

## Usage

In order to open this project, it is recommended to open "SevenCardPoker.Rproj" in RStudio, which has built-in support for R projects. Then, the program is run
from "head_to_head_simulation.R".

The final lines of head_to_head_simulation.R (lines 165-169) identify which simulation will be run:

* To run a single head-to-head comparison, modify the head_to_head_comparison() function call on line 166 to specify the desired comparison and sample size parameters, then comment out the run_all_comparisons() function call on line 169
* To run all head-to-head comparisons, modify the run_all_comparisons() function call on line 169 to specify the desired sample size parameters, then comment out the head_to_head_comparison() function call on line 166

Finally, to run the simulation simply execute the entire head_to_head_simulation.R file and the results will be output to the console.

## Results

The primary point of inquiry for this project was to simulate the 36 head-to-head comparisons and compile the results into a table. The results of a simulation using sample size parameters n = 1000, m = 100 are as follows:

| Head-to-Head Win Rates | 1 | 2 | 3 | 4 | 5 | 6 |
|-:|:-:|:-:|:-:|:-:|:-:|:-:|
| Rolled Up \| 1 \| | 0.50681 | 0.86614 | 0.89598 | 0.85869 | 0.92891 | 0.94301 |
| Pairs \| 2 \| | 0.13403 | 0.49274 | 0.56449 | 0.63997 | 0.68013 | 0.70144 |
| Three Big Cards \| 3 \| | 0.11895 | 0.44925 | 0.46471 | 0.57816 | 0.63956 | 0.65898 |
| Three to Straight \| 4 \| | 0.14315 | 0.35900 | 0.41667 | 0.48208 | 0.49588 | 0.50277 |
| Two to Straight \| 5 \| | 0.08316 | 0.31785 | 0.35443 | 0.47954 | 0.48579 | 0.48955 |
| High Card \| 6 \| | 0.08428 | 0.30314 | 0.32973 | 0.48976 | 0.48362 | 0.48913 |

We can see that along the diagonal of mirror matchups, i.e. the comparisons between the same category, we have about 0.5 or 50% for each, which is to be expected.

Additionally, for each row the win rates increase from left to right, which follows from the general ranking of the categories with Rolled Up (1) being the best, and High Card (6) being the worst.

Similarly, the win rates below the diagonal of mirror matchups are nearly entirely below 0.5 or 50%, and the win rates above the diagonal of mirror matchups are nearly entirely above 0.5 or 50%.

Finally, we can take any head-to-head matchup and find its inverse, i.e. Pairs vs Two to Straight and Two to Straight vs Pairs, and the win rates sum to approximately 1 or 100%.

All of these signs indicate that the simulation was run correctly, and we can trust the head-to-head win rates with some degree of accuracy.

There are two conclusions in particular which we note here. The first of which is simply how dominant the top tier of starting hands (Rolled Up) is - against the other categories, it has at least an 86% win rate. The main threat to this starting hand is in fact itself, but considering only 0.24% of starting hands fall into this category, it is surely a promising starting hand to bet on early.

The second conclusion we note is how similar the win rates are between the bottom three rows. Two to Straight, and even Three to Straight, have just barely higher winning odds than the categories below them, even the catch-all High Card category. These starting hands are not as promising as one might assume based simply on the general rankings, a statement which becomes even more clear with the next graphic.

The secondary point of inquiry for this project was to calculate the composite average win rate for each category. The results using the simulated data in the above table are as follows:

| Category | Average Win Rate |
|-:|:-:|
| Rolled Up | 0.83326 |
| Pairs | 0.53547 |
| Three Big Cards | 0.48494 |
| Three to Straight | 0.39993 |
| Two to Straight | 0.36839 |
| High Card | 0.36328 |

As mentioned previously, the bottom three categories are extremely close in average win rates, while Rolled Up has a dominant 83.326% win rate even taking into account the mirror matchup.

There is noticeable separation between Pairs, Three Big Cards, and the rest, but even still only going as high as 53.547% for pairs and 48.494% for Three Big Cards.

This concludes the investigation into starting hand winning odds, with the moral of the story being: if you draw Rolled Up, be sure to bet early and often! However for any other category, it's very much a coin-flip to determine your chances of winning based solely on your starting hand.

## References

Two main references were used in this project:

* https://github.com/mathedjoe/SevenCardPoker
    * starter R project code for running a single round of Seven Card Stud
* http://www.poker-base.com/seven-card-stud/sevencardstud.aspx
    * details starting hand categories and densities
