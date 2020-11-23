rm(list=ls(all=TRUE))  ## efface les données
source('~/thib/projects/tools/R_lib.r')
setwd("~/thib/projects/typing/data/")

## 
setwd('~/thib/projects/typing/data/data')
filenames <-  dir(full.names = FALSE)
i = 0
for (name in filenames){
    d <- fromJSON(read_json(name))
    d.trial = subset(d, trial_type == "html-audio-keyboard-multi-response") %>%
        select_if(~sum(!is.na(.)) > 0) %>%
        select(-c(SC_responseMatrix, SC_nTrialSC, SC_dir,  trial_type, CorrectPerceptual))
    ## C_nTrialSC = SC_nTrials
    ## CorrectPerceptual = acc
    d.conf = subset(d, trial_type == "html-slider-response") %>%
        mutate(trial_index = trial_index - 1) %>%
        select_if(~sum(!is.na(.)) > 0) %>%
        select(-c(stimulus, trial_type,  key_press2 ,  thiscondition,  SC_dir, SC_responseMatrix))
    d <- merge(d.trial, d.conf, by = 'trial_index') %>%
        mutate(sujet = str_sub(name, start = 1, end = -6))
    if (i >0){
        data <- rbind(d, data)
    }
    else{
        data <- d
    }
    i = i + 1
}
 
