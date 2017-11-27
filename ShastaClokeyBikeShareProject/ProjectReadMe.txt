Greetings! I hope you like linear regressions and bike sharing services, because that's whats on the menu!

Directions for navigating my project:

1. Open the file "multiRegression.m" and run the glorious script it contains.
	-You will see four sections displayed in the command window.
	-Each section will have a header in all caps, a technique to determine which
	 coefficients should be eliminated, a multi regression on the remaining data,
	 and finally, a multitude of plots of predictors against their associated residuals.
	-The first section is the base line multi regression with none of the predictors
	 eliminated.
	-The predictors in the second section are eliminated graphically by plotting each
	 predictor against each other predictor and looking for colinearity.
	-The predictors in the third section are eliminated by use of the lasso technique. 
	-The predictors in the fourth section are eliminated by use of the ridge technique.

2. The plots are labeled according to the technique that was used to eliminate predictors.
	-The plots labeled with col# ridgeResidual are from the ridge elimination.
	-The plots labeled with col# lassoResidual are from the lasso elimination.
	-The plots labeled with col# newResidual are from the graphical elimination.
		*The plots labeled with col#a col#b show the predictors which were colinear.
	-The plots labeled with col# residual are from the origonal data.

3. To close alllll of the plots, use the closePlots script which I wrote.
	-To close origional residual plots, type close(pre) in the command window
	-To close colinearity plots, type close(lin) in the command window	
	-To close residual plots with graphical elimination, type close(post) in the command window
	-To close residual plots with lasso elimination, type close(lasso) in the command window
	-To close residual plots with ridge elimination, type close(ridge) in the command window

4. The end of the script contains an additional section where I determine the best
   predictors based on the three predictor elimination methods I used (ridge, lasso, graphical).
    -This last section includes a final multi regression which generates my final model
    -I researched logical values for each of the remaining predictors in my independent variable
     set and created 8 sample days(winter, spring, summer, autumn|holiday, non holiday).
    -I used these sample days with the final model and generated predictions which get 
     printed to the console.