import math
import numpy as np
import pandas as pd
import random
import scipy.optimize

data_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/Developmental study/Task/Dev_Learning_Study/Output/fMRI/'

output_path = '/Users/zeynepenkavi/Dropbox/PoldrackLab/DevStudy/output/fits/'

data = pd.read_csv(data_path+'ProbLearn409850.csv')

def calculate_prediction_error(x0,data):
    
    TrialNum = data.Trial_type
    Response = data.Response
    Outcome = data.Points_earned
    
    EV = [0,0,0,0]
    Prediction_Error = 0
    alphapos=0.05
    alphaneg=x0[0]
    beta=1
    exponent=x0[1]
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
            
            #If the outcome is better than expected use alphapos
            if Outcome[i] > EV[int(TrialNum[i]-1)]:
                Prediction_Error = alphapos*(Outcome[i] - EV[int(TrialNum[i]-1)])**exponent
            
            #If the outcome is worst than expected use alphaneg
            if Outcome[i] < EV[int(TrialNum[i]-1)]:
                Prediction_Error = -1*alphaneg*(EV[int(TrialNum[i]-1)]-Outcome[i])**exponent #have to do it this way because you can't put a negative number to an exponent between 0 and 1
                   
            if Outcome[i] == EV[int(TrialNum[i]-1)]:
                Prediction_Error = 0
            
            EV[int(TrialNum[i]-1)] += Prediction_Error
    
    choicelogprob = 0
    for each_item in choiceprob:
        choicelogprob = choicelogprob - math.log(each_item)
        
    return(choicelogprob)


def select_optimal_parameters(subject):
    data =  pd.read_csv(data_path+'ProbLearn'+subject+'.csv')
    
    Results = pd.DataFrame({'x0_alpha_neg' : [],
                            'x0_exponent' : [],
                            'xopt_alpha_neg' : [],
                            'xopt_exponent' : [],
                            'choicelogprob' : [],})

    for i in range(50):
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
            Results.choicelogprob[i] = calculate_prediction_error(xopt,data)
            
        except:
            print("fmin error")
    
    #write out sorted data
    Results.sort_values(by=['choicelogprob']).to_csv(output_path+'LearningParametersSingleAlpha_'+str(subject)+'.csv')