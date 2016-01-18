# Tweelings
## Description
`Tweelings` is a web-application aiming to search for tweets and give a feeling analysis based on them.

## Algorithms
Right now, the application implements three classifying algorithms. A tweet can be classified as positive, neutral, or negative.

### Keywords
#### Principle
This is the basic algorithm. Using two files containing words associated with a positive or a negative rating, the algorithm counts the positive and negative words. For example, if the number of positive words is greater than the number of negative words, the tweet is classified as positive.

#### Analysis
The main advantage of this algorithm is that it does not require a base of tweets to function. However, because of the rather limited lexicon, most tweets end up classified as neutral.