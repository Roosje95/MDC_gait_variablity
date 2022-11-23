%% Order_SpatioTemporal_UKBB_MDC
% calculates spatio-temporal params based on automatic identified gait
% events

% Pre-request: run m02_GaitEventDetection_UKBB.m

% Input: Events
% Output: SpatioTemporal_MDC struct containing Spatio-temporal parameters
% (stride length, stride time, walking speed, step length,
% single limb support, double limb support, step time, cadance,
% stride width, kinematics)
%  T_SpatioTemporal_MDC sturct which can afterwards be important in R as
%  dataframe

% R. Visscher, June 2019
% Adapted: R. Visscher, March 2022

clc
%% Set-up
Path_structs = '...';
Path_save = '..';

% ATTENTION: adapt group based on cohort you want to analyse
Group = 'CP';%CP, TD, GMFCSI, GMFCSII

% ATTENTION: add the zip folders
addpath(Path_structs)


load('Events_outcomes.mat') %load file containing Events struct

list = fieldnames(Events);%names of files you want to analysis


%% Extract data
for i = 1:length(list)
    
    trails = fieldnames(Events.(list{i,1}));
    n_trials(i,1)= length(trails);% to see how many trials were done per participant
    %% Get outcomes per stride of all trails in one ordered struct
    for n=1:length(trails)
        params = fieldnames(Events.(list{i,1}).(trails{n,1}).GaitParam.Dummy);
        for m=1:length(params)
            SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left = Events.(list{i,1}).(trails{n,1}).GaitParam.Dummy.(params{m,1}).Left;
            SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right = Events.(list{i,1}).(trails{n,1}).GaitParam.Dummy.(params{m,1}).Right;
            SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All = [Events.(list{i,1}).(trails{n,1}).GaitParam.Dummy.(params{m,1}).Right Events.(list{i,1}).(trails{n,1}).GaitParam.Dummy.(params{m,1}).Left];
        end %end for-loop for each params
    end %end for-loop each trial
    
    %% Get outcomes per stride of all trails in one matrix
    n=1;
    for m=1:length(params)
        if n_trials(i,1)==2
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All];
        elseif n_trials(i,1)==4
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All];
        elseif n_trials(i,1)==3
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All];
        elseif n_trials(i,1)==5
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All];
        elseif n_trials(i,1)==6
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All];
        elseif n_trials(i,1)==7
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).All];
        elseif n_trials(i,1)==8
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).All];
        elseif n_trials(i,1)==9
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).All];
        elseif n_trials(i,1)==10
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).All];
        elseif n_trials(i,1)==11
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+10,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+10,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+10,1}).(params{m,1}).All];
        elseif n_trials(i,1)>11
            SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+10,1}).(params{m,1}).Left SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+11,1}).(params{m,1}).Left];
            SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+10,1}).(params{m,1}).Right SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+11,1}).(params{m,1}).Right];
            SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = [SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+1,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+2,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+3,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+4,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+5,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+6,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+7,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+8,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+9,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+10,1}).(params{m,1}).All SpatioTemporal_MDC.(Group).(list{i,1}).Trials.(trails{n+11,1}).(params{m,1}).All];
        end %end if-loop for how many trials
    end%end for-loop all params
    
    %% Remove outliers
    % value that is more than three scaled median absolute deviations gets
    % removed
    for m=1:length(params)
        SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}) = rmoutliers(SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{m,1}));
        SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}) = rmoutliers(SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{m,1}));
        SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}) = rmoutliers(SpatioTemporal_MDC.(Group).(list{i,1}).All.(params{m,1}));
    end
    
    %% Asymm Swing Time Stride Time
    % Assm = ln(Short Swing Time/Long swing time)*100
    if length(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support)>length(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support)
        for a=1:length(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support)
            if SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support(1,a)>SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support(1,a)
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Single_Support(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support(1,a))/log10(exp(1))*100);
            else
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Single_Support(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support(1,a))/log10(exp(1))*100);
            end
        end
    else
        for a=1:length(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support)
            if SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support(1,a)>SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support(1,a)
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Single_Support(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support(1,a))/log10(exp(1))*100);
            else
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Single_Support(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Single_Support(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Right.Single_Support(1,a))/log10(exp(1))*100);
            end
        end
    end% end if-loop swing time
    % Assm = ln(Short Stride Time/Long Stride Time)*100
    if length(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time)>length(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time)
        for a=1:length(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time)
            if SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time(1,a)>SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time(1,a)
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Time(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time(1,a))/log10(exp(1))*100);
            else
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Time(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time(1,a))/log10(exp(1))*100);
            end
        end
    else
        for a=1:length(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time)
            if SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time(1,a)>SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time(1,a)
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Time(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time(1,a))/log10(exp(1))*100);
            else
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Time(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Time(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Time(1,a))/log10(exp(1))*100);
            end
        end
    end% end if-loop stride time
    
    if length(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length)>length(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length)
        for a=1:length(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length)
            if SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length(1,a)>SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length(1,a)
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Length(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length(1,a))/log10(exp(1)))*100;
            else
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Length(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length(1,a))/log10(exp(1)))*100;
            end
        end
    else
        for a=1:length(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length)
            if SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length(1,a)>SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length(1,a)
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Length(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length(1,a))/log10(exp(1)))*100;
            else
                SpatioTemporal_MDC.(Group).(list{i,1}).All.Asymm_Stride_Length(1,a) = abs(log10(SpatioTemporal_MDC.(Group).(list{i,1}).Left.Stride_Length(1,a)/SpatioTemporal_MDC.(Group).(list{i,1}).Right.Stride_Length(1,a))/log10(exp(1)))*100;
            end
        end
    end% end if-loop stride length
    
    
    
    %% Calculate Mean, SD, CV
    SpatioTemporal_MDC.(Group).(list{i,1}).AmountStrides_ST = length(SpatioTemporal_MDC.(Group).(list{i,1}).All.Stride_Length);
    Params = fieldnames(SpatioTemporal_MDC.(Group).(list{i,1}).All);
    for j=1:length(Params)
        SpatioTemporal_MDC.(Group).(list{i,1}).Mean_All.(Params{j,1}) = nanmean(SpatioTemporal_MDC.(Group).(list{i,1}).All.(Params{j,1}));
        if j<6
            %nanmean
            SpatioTemporal_MDC.(Group).(list{i,1}).Mean_Left.(Params{j,1}) = nanmean(SpatioTemporal_MDC.(Group).(list{i,1}).Left.(Params{j,1}));
            SpatioTemporal_MDC.(Group).(list{i,1}).Mean_Right.(Params{j,1}) = nanmean(SpatioTemporal_MDC.(Group).(list{i,1}).Right.(Params{j,1}));
            
            %nansd
            SpatioTemporal_MDC.(Group).(list{i,1}).SD_Left.(Params{j,1}) = nanstd(SpatioTemporal_MDC.(Group).(list{i,1}).Left.(Params{j,1}));
            SpatioTemporal_MDC.(Group).(list{i,1}).SD_Right.(Params{j,1}) = nanstd(SpatioTemporal_MDC.(Group).(list{i,1}).Right.(Params{j,1}));
         
            %CV
            SpatioTemporal_MDC.(Group).(list{i,1}).CV_Left.(Params{j,1}) = SpatioTemporal_MDC.(Group).(list{i,1}).SD_Left.(Params{j,1})/SpatioTemporal_MDC.(Group).(list{i,1}).Mean_Left.(Params{j,1})*100;
            SpatioTemporal_MDC.(Group).(list{i,1}).CV_Right.(Params{j,1}) = SpatioTemporal_MDC.(Group).(list{i,1}).SD_Right.(Params{j,1})/SpatioTemporal_MDC.(Group).(list{i,1}).Mean_Right.(Params{j,1})*100;
            % SpatioTemporal_MDC.(Group).(list{i,1}).CV_All.(params{j,1}) = (SpatioTemporal_MDC.(Group).(list{i,1}).CV_Left+SpatioTemporal_MDC.(Group).(list{i,1}).CV_Right)/2;
        end%if-loop as asym doesnthave left and right values
    end %end for-loop each parameter, calculate mean/sd/CV
    
    
end %end for-loop subjects

for i = 1:length(list)
%% Extract data ST
% Calculate Mean, SD, CV
    SpatioTemporal_MDC.(Group).(list{i,1}).AmountStrides_ST = length(SpatioTemporal_MDC.(Group).(list{i,1}).All.Stride_Length);
    params = fieldnames(SpatioTemporal_MDC.(Group).(list{i,1}).All);
    for j=1:length(params)
        if j<6
        %nanmean
        SpatioTemporal_recal.(Group).(list{i,1}).Mean_Left.(params{j,1}) = nanmean(SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{j,1}));
        SpatioTemporal_recal.(Group).(list{i,1}).Mean_Right.(params{j,1}) = nanmean(SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{j,1}));
        SpatioTemporal_recal.(Group).(list{i,1}).Mean_All.(params{j,1}) = (mean(SpatioTemporal_recal.(Group).(list{i,1}).Mean_Left.(params{j,1}))+mean(SpatioTemporal_recal.(Group).(list{i,1}).Mean_Right.(params{j,1})))/2;
        %nansd
        SpatioTemporal_recal.(Group).(list{i,1}).SD_Left.(params{j,1}) = nanstd(SpatioTemporal_MDC.(Group).(list{i,1}).Left.(params{j,1}));
        SpatioTemporal_recal.(Group).(list{i,1}).SD_Right.(params{j,1}) = nanstd(SpatioTemporal_MDC.(Group).(list{i,1}).Right.(params{j,1}));
        SpatioTemporal_recal.(Group).(list{i,1}).SD_All.(params{j,1}) = (mean(SpatioTemporal_recal.(Group).(list{i,1}).SD_Left.(params{j,1}))+mean(SpatioTemporal_recal.(Group).(list{i,1}).SD_Right.(params{j,1})))/2;
        %CV
        SpatioTemporal_recal.(Group).(list{i,1}).CV_Left.(params{j,1}) = SpatioTemporal_recal.(Group).(list{i,1}).SD_Left.(params{j,1})/SpatioTemporal_recal.(Group).(list{i,1}).Mean_Left.(params{j,1})*100;
        SpatioTemporal_recal.(Group).(list{i,1}).CV_Right.(params{j,1}) = SpatioTemporal_recal.(Group).(list{i,1}).SD_Right.(params{j,1})/SpatioTemporal_recal.(Group).(list{i,1}).Mean_Right.(params{j,1})*100;
        SpatioTemporal_recal.(Group).(list{i,1}).CV_All.(params{j,1}) = (mean(SpatioTemporal_recal.(Group).(list{i,1}).CV_Left.(params{j,1}))+mean(SpatioTemporal_recal.(Group).(list{i,1}).CV_Right.(params{j,1})))/2;
        elseif j>5
            SpatioTemporal_recal.(Group).(list{i,1}).Mean_All.(params{j,1}) = SpatioTemporal_MDC.(Group).(list{i,1}).Mean_All.(params{j,1});
        end%if loop as asym params do not have left and right
        
    end %end for-loop each parameter, calculate mean/sd/CV
    
end %end for-loop subjects

