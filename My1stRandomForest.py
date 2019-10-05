#first Python Random Forest model: 

from sklearn import datasets,ensemble
digits = datasets.load_digits()
X_digits = digits.data
y_digits = digits.target
randomf=ensemble.RandomForestClassifier(warm_start=True, oob_score=True)
randomf.fit(X_digits[:-100], y_digits[:-100]).score(X_digits[-100:], y_digits[-100:])

tr=tree.DecisionTreeClassifier(criterion='gini', splitter='best', max_depth=None, min_samples_split=2, min_samples_leaf=1, min_weight_fraction_leaf=0.0, max_features=None, random_state=None, max_leaf_nodes=None, class_weight=None)
tr.fit(X_digits[:-100], y_digits[:-100]).score(X_digits[-100:], y_digits[-100:])
