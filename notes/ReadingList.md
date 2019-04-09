**Davidow, J. Y., Insel, C., & Somerville, L. H. (2018). Adolescent development of value-guided goal pursuit. Trends in Cognitive Sciences.***
"many studies have shown that the ventral striatum response to the anticipation and *receipt* of rewards is elevated during adolescence"
***Is VStr response for gains is larger for teens***

**Crone, E. A., Zanolie, K., Van Leijenhorst, L., Westenberg, P. M., & Rombouts, S. A. (2008). Neural mechanisms supporting flexible performance adjustment during development. Cognitive, Affective, & Behavioral Neuroscience, 8(2), 165-177.**
- Simplified WCST
- Comparing neural response (ACC, DLPFC and OFC) to different types of feedback
- WCST is NOT probabilistic. Negative feedback in this task should always lead to behavior change. In the machine game you should persist with playing even if you experience a loss in the positive EV machines.
- Feedback does NOT depend on behavior (+/- feedback given regardless of participant behavior. In the machine game if participant chooses to pass no feedback is received)
- Information value of feedback: In the machine game the information value from each trial is less than WCST

**Van Duijvenvoorde, A. C., Zanolie, K., Rombouts, S. A., Raijmakers, M. E., & Crone, E. A. (2008). Evaluating the negative or valuing the positive? Neural mechanisms supporting feedback-based learning across development. Journal of Neuroscience, 28(38), 9495-9503.**
- "children performed disproportionally more inaccurately after receiving negative feedback relative to positive feedback"
- "dorsolateral prefrontal cortex and superior parietal cortex were more active after negative feedback for adults, but after positive feedback for children"
- WCST with 2 rules; comparing response to different feedback types
- Does suggest that kids are worse in learning from negative feedback
***post-loss ACC-DLPFC connectivity compared between adults vs kids***
***Behavioral check: are there enough large losses for adults in run1?***

**van den Bos, W. et al. (2009) Better than expected or as bad as you thought? The neurocognitive development of probabilistic feedback processing. Front. Hum. Neurosci. 3, 52**
- Switching to thinking about 'informative value' of feedback instead of just its valence
- Manipulating probability of feedback BUT NOT THE MAGNITUDE
- Feedback received in each trial (i.e. no pass option)
Hypotheses:
- Difference between gain vs loss in dACC increases with age
- Difference between positive vs negative performance in DLPFC recruitment shifts with age (?)
- Decrease in activity related to positive feedback with age
- *pos > neg feedback*: caudate, dlpfc, parietal cortex
- *neg > pos feedback*: dACC
- Behavioral matching?
***ACC, DLPFC predicting behavior change on subsequent trials***

**Tamnes, C.K. et al. (2010) Brain maturation in adolescence and young adulthood: regional age-related changes in cortical thick- ness and white matter volume and microstructure. Cereb. Cortex 20, 534–548**

**Somerville, L.H. and Casey, B. (2010) Developmental neurobiology of cognitive control and motivational systems. Curr. Opin. Neurobiol. 20, 236–241**

**Somerville, L.H. et al. (2011) Frontostriatal maturation predicts cognitive control failure to appetitive cues in adolescents. J. Cogn. Neurosci. 23, 2123–2134**

**van den Bos, W. et al. (2012) Striatum–medial prefrontal cortex connectivity predicts developmental changes in reinforcement learning. Cereb. Cortex 22, 1247–1255**
-  "[A]ge differences in learning parameters with a stronger impact of negative feedback on expected value in children"
- "neural representation of prediction errors was similar across age groups, but functional connectivity between the ventral striatum and the medial prefrontal cortex changed as a function of age"
- Pairs of options that differ in probability of positive outcome. Difference between pairs is only 10% (as opposed to 45% for the machine game) and magnitude is not varied
- "The relation between prediction errors and subsequent learning is confirmed by studies demonstrating an association between the representation of prediction errors in the striatum and individual differences in performance on probabilistic learning tasks"
- ***p(lose/shift) and p(win/stay)***
- RL model with two alphas (compared only to one other model with single alpha; not presenting distributions of parameters)
- Model predictions and actual behavior correlates <0.5, yet the similarly low correspondence across age groups “supports” comparing estimates across groups (?!)
- No age group differences in betas; lower alpha pos for kids and lower alpha neg for adults - - this should suggest that p(lose/shift) is lower for adults?
- No neural differences of PE representations

**Paulsen, D. et al. (2012) Neurocognitive development of risk aversion from early childhood to adulthood. Front. Hum. Neurosci. 5, 178**

**Christakou, A., Gershman, S. J., Niv, Y., Simmons, A., Brammer, M., & Rubia, K. (2013). Neural and psychological maturation of decision-making in adolescence and young adulthood. Journal of cognitive neuroscience, 25(11), 1807-1823.**
- "Performance relied on greater impact of negative compared with positive PEs, the relative impact of which matured from adolescence into adulthood."
- IGT - probabilities in all decks are the same BUT ‘risky’ decks have larger gains/losses (0>EV) and ‘safe’ decks have smaller gains/losses (0<EV)
- ***RL Model with two alpha, and two temperatures (one for outcome sensitivity, beta, and one for choice sensitivity/stickiness that is fit in a second stage fixing the other three parameters)***
- Compared to a model with one alpha and stickiness and one alpha and no stickiness
- Behavioral results: Beta, stickiness and alpha neg increase with age;
- neural: confusing; using a sum of square ration statistic instead of z values. They call it the 'fidelity' of the representation. I think it is meant to capture how well these putative constructs from the computational models actually fit the neural data
  - No linear/non-linear difference in EV (decision phase) or PE (outcome phase) maps
  - EV clusters in dlPFC, vlPFC and vmPFC correlated with age; frontal gyrus also related to performance
  - Similar areas also correlated with age for the PE regressor; adolescents and adults differ in the regions where the PE regressors correlate with performance ("qualitative difference"; lacking "contextualizaton of reward information compared to adults")

**Satterthwaite, T.D. et al. (2013) Functional maturation of the executive system during adolescence. J. Neurosci. 33, 16249–16261**

**Barkley-Levenson, E. and Galván, A. (2014) Neural representation of expected value in the adolescent brain. Proc. Natl. Acad. Sci. U. S. A. 111, 1646–1651**

**Javadi eta al. (2014) Adolescents Adapt More Slowly than Adults to Varying Reward Contingencies. J of. Cog. Neuro. 20:12, 2770:81.**
- From the abstract: "Results showed that adolescents possessed a shallower slope [inverse temperature] in the sigmoid curve governing the relation between expected value [...] and probability of stay (selecting the same option as in the previous trial)."
- "At the neural level, BOLD correlates of learning rate, expected value, and prediction error did not [...] differ between adolescents and adults. [...] Our results indicate that adults seem to behaviorally integrate punishing feedback better than adolescents in their estimation of the current state of the contingencies."
- (simplified overview of neural correlates of RL model components): alpha in dACC, PE in VStr and EV in vmPFC
- Task: 'system changes' lead to changes of reward contingencies of the stimuli
- RL model: single learning rate that is updated trial by trial
- Behavioral group difference found for beta; adults are less likely to switch
- No neural group difference
- No comparison of model to other possible models, comparing only whether the model fits similarly across groups and fits worse for adolescents but using the similarity of correlations between BOLD and parameters they argue that the worse fit for adolescents is a function of more volatile behavior
- "Post hoc tests on this three-way interaction showed interesting results: first, adults achieved a smaller absolute value of prediction error for being punished after trials which they responded correctly to, and second, they achieved a higher absolute value of change in expectation for being punished after trials which they responded wrongly to. The former finding shows that adults were more capable of interpreting negative feedback as either leading or misleading and therefore had more accurate expectations. The latter finding, on the other hand, shows that they incorporated punishment when updating their state to a greater extent when they felt like they were mistaken."

**Luking, K.R. et al. (2014) Kids, candy, brain and behavior: Age differences in responses to candy gains and losses. Dev. Cogn. Neurosci. 9, 82–92**
- Card guessing game: outcome is probabilistic but there is no learning
- One relevant contrast: Adults show larger responses to losses compared to kids in anterior insula, hippocampus and caudate while responses to gains were closer to each other for the two groups

**Peters, S. et al. (2014) Strategies influence neural activity for feedback learning across child and adolescent development. Neuropsychologia 62, 365–374**

**Vink, M. et al. (2014) Frontostriatal activity and connectivity increase during proactive inhibition across adolescence and early adulthood. Hum. Brain Mapp. 35, 4415–4427**

**Braams, B.R. et al. (2015) Longitudinal changes in adolescent risk-taking: a comprehensive study of neural responses to rewards, pubertal development, and risk-taking behavior. J. Neurosci. 35, 7226–7238**

**Casey, B.J. (2015) Beyond simple models of self-control to circuit-based accounts of adolescent behavior. Annu. Rev. Psychol. 66, 295–319**

**Hartley, C.A. and Somerville, L.H. (2015) The neuroscience of adolescent decision-making. Curr. Opin. Behav. Sci. 5, 108**

**Hauser, T.U. et al. (2015) Cognitive flexibility in adolescence: neural and behavioral mechanisms of reward prediction error processing in adaptive decision making during development. Neuroimage 104, 347–354**
- From the abstract: "We found that adolescents learned faster from negative RPEs than adults. The fMRI analysis revealed that within the RPE network, the adolescents had a significantly altered RPE-response in the anterior insula. This effect seemed to be mainly driven by increased responses to negative prediction errors."
- Compared 3 RL models: Single alpha, to alphas for +/- RPE and anticorrelated valuation with 4 alphas chosen/unchosen and +/- RPE
- "For the fMRI analysis, we estimated one single set of canonical model parameters for all participants"
- No behavioral differences (neither in overall performance nor in number of switches)
- Chose the most complicated model based on AIC (which doesn't penalize for model complexity)

**Luna, B. et al. (2015) An integrative model of the maturation of cognitive control. Annu. Rev. Neurosci. 38, 151–170**

**Silverman, M.H. et al. (2015) Neural networks involved in adolescent reward processing: an activation likelihood estimation meta- analysis of functional neuroimaging studies. Neuroimage 122, 427–439**
- ALE Meta-analysis comparing reward processing network between adolescents and adults (Silverman, Jedd, Luciana 2015)
- Broke it down by experiment stage and reward valence
- Adolescent insula during anticipation and caudate during outcome were more active compared to adults
- Adolescent Vstr also more active for positive outcomes compared to adults

**Davidow, J.Y. et al. (2016) An upside to reward sensitivity: the hippocampus supports enhanced reinforcement learning in adolescence. Neuron 92, 93–99**

**Palminteri, S. et al. (2016) The computational development of reinforcement learning during adolescence. PLoS Comput. Biol. 12, e1004953**

**Somerville, L.H. (2016) Searching for signatures of brain maturity: what are we searching for? Neuron 92, 1164–1167**

**Church, J.A. et al. (2017) Preparatory engagement of cognitive control networks increases late in childhood. Cereb. Cortex 27, 2139–2153**

**Crone, E.A. and Steinbeis, N. (2017) Neural perspectives on cognitive control development during childhood and adolescence. Trends Cogn. Sci. 21, 205–215**

**Schreuders, E. et al. (2018) Contributions of reward sensitivity to ventral striatum activity across adolescence and early adulthood. Child Dev. 89, 797–810**

**Sherman, L., Steinberg, L., & Chein, J. (2018). Connecting brain responsivity and real-world risk taking: Strengths and limitations of current methodological approaches. Developmental cognitive neuroscience, 33, 27-41.**
- Review of ‘individual difference’ studies of neural markers for (only) adolescent risk taking
- This paper is a good example of all the problems in the field (no one paradigm, no good definition of a consistent DV etc.)
- Bottom-up/whole brain analyses don’t agree with ROI approaches (where people find what they are looking for)
- No single/good individual difference marker found
