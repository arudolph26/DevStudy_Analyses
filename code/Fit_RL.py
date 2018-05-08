import math
import numpy as np
import pandas as pd
import random
import scipy.optimize

data_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/Developmental study/Task/Dev_Learning_Study/Output/fMRI/'

output_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy/output/fits/'

def calculate_prediction_error(x0,data):
    
    TrialNum = data.Trial_type
    Response = data.Response
    Outcome = data.Points_earned
    
    EV = [0,0,0,0]
    Prediction_Error = 0
    alphapos=x0[0]
    alphaneg=x0[1]
    beta=x0[2]
    exponent=x0[3]
    choiceprob = np.zeros((len(TrialNum)))
    
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
                Prediction_Error = alphapos*(Outcome[i] - EV[int(TrialNum[i]-1)])**exponent
            
            #If the outcome is worst than expected use alphaneg
            if Outcome[i] < EV[int(TrialNum[i]-1)]:
                Prediction_Error = -1*alphaneg*(EV[int(TrialNum[i]-1)]-Outcome[i])**exponent #have to do it this way because you can't put a negative number to an exponent between 0 and 1
                   
            if Outcome[i] == EV[int(TrialNum[i]-1)]:
                Prediction_Error = 0
            
            EV[int(TrialNum[i]-1)] += Prediction_Error
    
    neglogprob = 0
    choiceprob = np.where(choiceprob == 1, 0.99999999, np.where(choiceprob == 0, 0.00000001, choiceprob))
    for each_item in choiceprob:
        neglogprob = neglogprob - math.log(each_item)
        
    return(neglogprob)


def select_optimal_parameters(subject, n_fits=50, pars):
    
    data =  pd.read_csv(data_path+'ProbLearn'+str(subject)+'.csv')
    
    Results = pd.DataFrame({'x0_alpha_pos' : np.nan,
                            'x0_alpha_neg' : np.nan,
                            'x0_beta' : np.nan,
                            'x0_exponent' : np.nan,
                            'xopt_alpha_pos' : np.nan,
                            'xopt_alpha_neg' : np.nan,
                            'xopt_beta' : np.nan,
                            'xopt_exponent' : np.nan,
                            'neglogprob' : np.nan}, index = range(n_fits))
    
    fixparams = ...
    fitparams = ...
    
    model_name = 'LearningParamsFix_'+ ... + '_Fit_'+ ...
    
    # chenge x0 depending on pars
    
    for i in range(n_fits):
        #Priors
        x0=[random.uniform(0,.4),random.uniform(0,1)]
        try:
            print(x0)
            
            #Fit model
            xopt = scipy.optimize.fmin(calculate_prediction_error,x0,args=(data,),xtol=1e-6,ftol=1e-6)
            
            #Update Results output
            Results.x0_alpha_neg[i]=x0[0]
            Results.x0_exponent[i]=x0[1]
            Results.xopt_alpha_neg[i]=xopt[0]
            Results.xopt_exponent[i]=xopt[1]
            Results.neglogprob[i] = calculate_prediction_error(xopt,data)
            
        except:
            print("fmin error")
    
    #write out sorted data
    Results.sort_values(by=['neglogprob']).to_csv(output_path+ model_name+str(subject)+'.csv')
    
#TO ADD:
    #Options for different parameters
    #Model comparison: which 
    #Stability of parameters for each subject
    #Consistent age difference (regardless of parameter stability)
#Imaging:
    #BIDS validator
    #MRI-QC
    #fmri-prep