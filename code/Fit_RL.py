import copy
import math
import numpy as np
import pandas as pd
import random
import scipy.optimize

data_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/Developmental study/Task/Dev_Learning_Study/Output/fMRI/'

output_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy/output/fits/'


def extract_pars(pars):
    fixparams = []
    fitparams = []
    
    for key in sorted(pars.keys()):
        if np.isnan(pars[key]):
            fitparams.append(key)
        else:
            fixparams.append(key)
    
    out = {'fitparams':fitparams, 'fixparams':fixparams}
        
    return(out)

def calculate_prediction_error(x0,data, pars):
    
    TrialNum = data.Trial_type
    Response = data.Response
    Outcome = data.Points_earned
    
    EV = [0,0,0,0]
    Prediction_Error = 0
    choiceprob = np.zeros((len(TrialNum)))
    
    #FIGURE OUT HOW TO FIX AND NOT FIT THESE - TRY USING PARS. X0 SHOULD ALREADY ONLY HAVE VALUES FOR THE PARAMETERS THAT WILL BE FITTED
    
    fixparams = extract_pars(pars)['fixparams']
    fitparams = extract_pars(pars)['fitparams']
    
    alphaneg=x0[0]
    alphapos=x0[1]
    beta=x0[2]
    expneg=x0[3]
    exppos=x0[4]
    
    
    for i in range(len(TrialNum)):
        #First update the choice probabilities for each trial
        if Response[i] == 0:
            choiceprob[i] = 1
                      
        if Response[i] == 1:
            choiceprob[i] = math.exp(EV[int(TrialNum[i]-1)]*beta)/(math.exp(EV[int(TrialNum[i]-1)]*beta)+1)
            
        if Response[i] == 2:
            choiceprob[i] = 1-math.exp(EV[int(TrialNum[i]-1)]*beta)/(math.exp(EV[int(TrialNum[i]-1)]*beta)+1)       
        
        #If a machine has been played update the RPE      
        if Outcome[i] != 0:
            
            #ADD ADDITIONAL IF STATEMENT FOR SINGLE LEARNING RATE OPTION
            
            #If the outcome is better than expected use alphapos
            if Outcome[i] > EV[int(TrialNum[i]-1)]:
                Prediction_Error = alphapos*(Outcome[i] - EV[int(TrialNum[i]-1)])**exppos
            
            #If the outcome is worst than expected use alphaneg
            if Outcome[i] < EV[int(TrialNum[i]-1)]:
                Prediction_Error = -1*alphaneg*(EV[int(TrialNum[i]-1)]-Outcome[i])**expneg #have to do it this way because you can't put a negative number to an exponent between 0 and 1
                   
            if Outcome[i] == EV[int(TrialNum[i]-1)]:
                Prediction_Error = 0
            
            EV[int(TrialNum[i]-1)] += Prediction_Error
    
    neglogprob = 0
    choiceprob = np.where(choiceprob == 1, 0.99999999, np.where(choiceprob == 0, 0.00000001, choiceprob))
    for each_item in choiceprob:
        neglogprob = neglogprob - math.log(each_item)
        
    return(neglogprob)


def select_optimal_parameters(subject, n_fits=50, pars = {'alpha_neg':np.nan, 'alpha_pos':np.nan, 'beta':np.nan,  'exp_neg':np.nan, 'exp_pos':np.nan}):
    
    data =  pd.read_csv(data_path+'ProbLearn'+str(subject)+'.csv')
    
    Results = pd.DataFrame({'x0_alpha_pos' : np.nan,
                            'x0_alpha_neg' : np.nan,
                            'x0_beta' : np.nan,
                            'x0_exp_pos' : np.nan,
                            'x0_exp_neg' : np.nan,
                            'xopt_alpha_pos' : np.nan,
                            'xopt_alpha_neg' : np.nan,
                            'xopt_beta' : np.nan,
                            'xopt_exp_pos' : np.nan,
                            'xopt_exp_neg' : np.nan,
                            'neglogprob' : np.nan}, index = range(n_fits))
    
    fixparams = extract_pars(pars)['fixparams']
    fitparams = extract_pars(pars)['fitparams']
      
    #make string containing info on fitted pars for output file name        
    model_name = 'LearningParamsFix_'+ '_'.join(fixparams) + '_Fit_'+ '_'.join(fitparams)
    
    def sample_x0(pars):
        
        pars_copy = copy.copy(pars)
        x0 = []
        #Fix vs fit params
        for key in sorted(pars_copy.keys()):
            #if NaN then fit param; so sample from prior; otherwise leave as is
            if np.isnan(pars_copy[key]):
                #Priors
                #UPDATING X0 FOR ALL PARS THAT WILL BE FITTED AFTER SAMPLING FROM PRIOR TO make sure x0 has the correct order and only values for parameters that will be fittd!
                if key == 'alpha_neg':
                    pars_copy[key] = random.uniform(1,2)
                    x0.append(pars_copy[key])
                if key == 'alpha_pos':
                    pars_copy[key] = random.uniform(3,4)
                    x0.append(pars_copy[key])
                if key == 'beta':
                    pars_copy[key] = random.uniform(5,6)
                    x0.append(pars_copy[key])
                if key == 'exp_neg':
                    pars_copy[key] = random.uniform(7,8)
                    x0.append(pars_copy[key])
                if key == 'exp_pos':
                    pars_copy[key] = random.uniform(9,10)
                    x0.append(pars_copy[key])
            
        return(x0)
    
    for i in range(n_fits):
    
        x0=sample_x0(pars)
        
        try:
            print(x0)
            
            #Fit model
            xopt = scipy.optimize.fmin(calculate_prediction_error,x0,args=(data,pars,),xtol=1e-6,ftol=1e-6)
            
            #convert xopt to dictionary for easier update of Results df
            xopt_dict = dict(zip(fitparams,list(xopt)))
            
            #fill in Results df with x0 and xopt for the fitted params
            for key in sorted(pars.keys()):
                    Results['x0_'+key][i] = pars[key]
                    if key in fitparams:
                        Results['xopt_'+key] = xopt_dict[key]
            
            #add neg log of fit to Results output
            Results.neglogprob[i] = calculate_prediction_error(xopt,data)
            
        except:
            print("fmin error")
    
    #write out sorted data
    Results.sort_values(by=['neglogprob']).to_csv(output_path+ model_name+str(subject)+'.csv')
    
# Based on http://zenkavi.github.io/DevStudy/output/reports/ExploratoryDVs.nb.html
# the age difference in this task lies in learning from high variance negative feedback
# Which parameter would this be captured in?
# Well this machine has two properties that are different than the others: the magnitude of the loss and the frequency of loss (sensitivity to EV vs variance?). So either alpha_neg if the RPE from the machine is not weighed enough and/or the exponent on the loss if the loss doesn't feel as severe as it should 
# Can you fit the model per condition? Probably not since there would only be 45 trials and there should be a more elegant way of capturing this in a single model