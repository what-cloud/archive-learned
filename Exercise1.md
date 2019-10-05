overfitting
test/trainvalid

Overfitings happen when model learned noise that are specific to the training data set, instead of generic features.

How to find: I would leave test dataset out, then make sure the performance is same across training and test data set.

Possible approaches to reduce it:

1. Remove or deweight less important features;

2. Regularisation: tree pruning etc

3. Ensembling (voting or averaging)

1. User ID: NOT include - but potentially you can introduce a new feature - Year of Registration (if user ID is integer it may appear to have "predictive power" due to correlation to how long user has been with the website)

2. Time arrived page: Yes - reflect behaviour of a group of users

3. Size of ad: Yes -

4. Location: Yes-
To make model useful for unknown future data, you have to leave one part out ( part B, which can be further divided to Validation/Test), then feed the majority  (Training Dataset) to train the model, so this part is "Unknown" to the model trained using "training dataset".

Then you can use validation to see if model works on the validation set, and use it to update parameter of the model.

And use the last "unknown" part (Test Dataset) to evaluate if the model performed as good as it did on Training data



1. User ID: not useful, - but potentially you can introduce a new feature - Year of Registration (if user ID is integer it may appear to have "predictive power" due to correlation to how long user has been with the website)
