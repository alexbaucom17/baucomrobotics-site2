---
title: Teaching Computers to Think! (sort of...)
date: 2016-03-17 12:30:00 -0700
categories: [Projects]
tags: [machinelearning]     # TAG names should always be lowercase
image: /assets/MachineLearningCourse/preview.jpg
---



As part of my Machine Learning class at Penn, I got a chance to work on a gender identification project based on Twitter data.  The goal of the project was to try to identify the gender of 5000 people on Twitter based on their profile pictures and a summary of all the tweets they had written. In order to stimulate creativity, the professor made the project a sort of competition between all the teams in our class with prizes (and more importantly, grade bumps) going to the best teams. While my team had no intentions of trying to win the competition from the outset, we actually ended up doing just that! Read on to find out how.


## Setup

For the project, each team was given a labeled training set consisting of about 5000 people with 100x100 RGB images for each person, as well as a summary of how many times they had used the 5000 most common English words (including numbers and emoticons) in their Twitter history. We were also provided various features that had been extracted from the images such as head position, whether the person was smiling or wearing glasses, and a few other metrics; however, my team actually didn't end up using these features at all since they didn't provide any benefit to our model.

In addition to the training set with labels, we were given a testing set of 5000 people without labels that we could use to test our model. There was an online leader board where we could submit our predictions once every 5 hours and we would get an accuracy score. This helped us see how well our models were working and see how well the competition was doing.

Lastly, to combat over-fitting, the professor held out another 5000 data points for the validation set that he tested all of the final models on. How well we performed on this last set was how he determined the winners of the competition.


## Words

Interestingly, the 'easiest' thing to start with was just to skip using images altogether and look at the words people use. With a quick pass using an [AdaBoost algorithm](https://en.wikipedia.org/wiki/AdaBoost) with 2000 decision stumps, we could correctly predict the gender with 88% accuracy. After trying out various MATLAB boosting algorithms, we found we could get the best performance from an algorithm called [LogitBoost](https://www.mathworks.com/help/stats/ensemble-methods.html). We had to reduce the number for decision stumps to 1000 to meet the file size requirements, but this method by itself was still able to get approximately 90% accuracy.

Another method using only the words was to use a [SVM](https://en.wikipedia.org/wiki/Support_vector_machine) and a kernel called a [histogram intersection kernel](https://file.scirp.org/pdf/JCC_2015112015262272.pdf) which also got about 90% accuracy. An important note here was that the 10% error that this SVM had was, on average, a different 10% of the sample than the boosting got wrong. This meant that combining these two methods later would actually be useful.


## Images

Images are inherently tricky to work with since they are so large and individual pixels are not usually very descriptive by themselves, even if the image as a whole is very descriptive. In order to deal with this, a popular trick is to try to condense images into a smaller number of more descriptive features. We did this by using the open source library [VLFeat](https://www.vlfeat.org/index.html) which has a lot of really useful computer vision algorithms already implemented.

We used dense SIFT to extract feature descriptors and then found the most important combinations of these descriptors using [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis). We then augmented each feature with its x and y location in the image and created 256 clusters of features using a [Gaussian Mixture Model](https://en.wikipedia.org/wiki/Mixture_model#Gaussian_mixture_model). All of this allowed us to condense the information into 256 very descriptive features instead of 30,000 not very descriptive pixels. These 256 clusters were used to train another SVM which gave us about 84% accuracy by itself.

## Putting it all together

These methods each did reasonably well when used alone, but were so much more powerful together. We tried various ways of combining the data and the following yielded the best results.

Following advice from [this website](https://mlwave.com/kaggle-ensembling-guide/), we used what is called an ensemble stacking method to avoid over-fitting. This involved randomly splitting our data into 2 partitions and training two separate times on each half of the data, using each of the three models discussed above. The trained models from each half of the data were then used to generate scores for the other half of the data so that each data point had a score from each of our three models. The importance of this is that no data points were used for both training and predicting, as this would cause over-fitting.

Each of the three scores for each point was normalized and then the features were expanded by multiplying the scores together in various permutations to capture any interactions between the different models. Using one final SVM on this last set of expanded scores yielded results around 93-94% accuracy, depending on how the data was randomly split.

![](/assets/MachineLearningCourse/ScoreSVM.jpg)
_A plot of the score SVM using only the image scores and the boosted words score (the SVM on the words is not included here). Click to see a larger image._

![](/assets/MachineLearningCourse/ScoreSVMZoomed.jpg)
_A zoomed in view of the previous plot to show the support vectors. Click to enlarge._


## Results

Like I mentioned at the beginning of this post, my team ended up winning the competition, which had about 50 other teams. Not only that, but we won by a sizable margin of 1% (yes, that is a lot in the machine learning world!). There was another team who had built a huge model with about 30 different methods ensembled together that was able to get 96% accuracy on the test set; however, they had to cut down their model significantly to meet file size limits and only ended up getting about 91% on the held-out validation set.

Fun fact: our team name 'Crouching Tiger, Hidden Markov Model' also won first place in the team naming competition :) 