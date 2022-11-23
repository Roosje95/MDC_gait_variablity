%% m03_Order_Kinematics_MDC %%
% extracts saggital joint angles and foot progression from previously
% prossessed matlab sctructs

% Pre-request: First run m01_GetGaitParams_c3dtomat

% Input: StructAllGC
% Output: SpatioTemporal_MDC and T_SpatioTemporal_MDC containing 
% meanSD and curves from (saggital) Hip flexion, knee flexion, ankle
% dorsiflexion

% R. Visscher, June 2020
% Adapted: R. Visscher, March 2022

clc
clear all
close all

%% Set-up
% Adapt paths to structs you wanna extract info from and group towards
% which group you are analyzing
Path_structs = ('...');
% ATTENTION: adapt group based on cohort you want to analyse
Group = 'CP';%CP, TD

addpath(Path_structs)
% ATTENTION: add the zip folders
addpath(genpath('...'));% add Codes_UKBB.zip

%% Order kinematics
cd(Path_structs)
direc = dir;
direc(strncmp({direc.name}, '.', 1)) = [];
total = length(direc);
list = {direc.name};

for x = 1:length(list)
    cd(Path_structs)
    subject_trail = list(x);
    cd(list(x)) % move into subfolder subject
    subdirec = dir;
        
         % load normalizsed struct
    Path_measurement = [Path_structs '\' char(list(x)) '\PIGoutcomesNormalized.mat'];
    load(Path_measurement)%loads file named StractAllGC
    
    %% Get outcomes Joint Angles
    trails = fieldnames(StructAllGC);
    SpatioTemporal_MDC.(Group).(list{x}).AmountStrides_Kinematics= length(trails);%left and right are treated as seperate strides
    l=1;
    r=1;
    for n=1:length(trails)
        if contains(trails{n,1},'L')
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Left(:,l) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Pelvis.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Left(:,l) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Hip.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.KneeFlex.Left(:,l) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Knee.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.AnkleFlex.Left(:,l) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Ankle.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.FootProgress.Left(:,l) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Transversal.FootProgress.Left;
        l=l+1;
        elseif contains(trails{n,1},'R')
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Left(:,l) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Pelvis.Right;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Right(:,r) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Hip.Right;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.KneeFlex.Right(:,r) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Knee.Right;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.AnkleFlex.Right(:,r) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Ankle.Right;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.FootProgress.Right(:,r) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Transversal.FootProgress.Right; 
        r=r+1;
        else
        %pelvis
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Left(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Pelvis.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Right(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Pelvis.Right;
        %hip
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Left(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Hip.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.HipFlex.Right(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Hip.Right;
        %knee
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.KneeFlex.Left(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Knee.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.KneeFlex.Right(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Knee.Right;
        %ankle
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.AnkleFlex.Left(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Ankle.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.AnkleFlex.Right(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Sagittal.Ankle.Right;
        %footProgress
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.FootProgress.Left(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Transversal.FootProgress.Left;
        SpatioTemporal_MDC.(Group).(list{x}).Angles_100.FootProgress.Right(:,n) = StructAllGC.(trails{n,1}).PIGnormalised_100.Angle.Transversal.FootProgress.Right; 
        end %end if-loop to extract L, R or both
    end %end for-loop amount of trials
    
    %% Calculate Mean, SD, CoV
    Params=fieldnames(SpatioTemporal_MDC.(Group).(list{x}).Angles_100);
    for j=1:length(Params)
        %take left and right trials into one matrix
%         SpatioTemporal_MDC.(Group).(list{x}).Angles_100.(Params{j,1}).All = [SpatioTemporal_MDC.(Group).(list{x}).Angles_100.(Params{j,1}).Left SpatioTemporal_MDC.(Group).(list{x}).Angles_100.(Params{j,1}).Right];
        %meanSD
%         SpatioTemporal_MDC.(Group).(list{x}).MeanSD.(Params{j,1}).All = mean(std(SpatioTemporal_MDC.(Group).(list{x}).Angles_100.(Params{j,1}).All'));
        SpatioTemporal_MDC.(Group).(list{x}).MeanSD.(Params{j,1}).Left = nanmean(nanstd(SpatioTemporal_MDC.(Group).(list{x}).Angles_100.(Params{j,1}).Left'));
        SpatioTemporal_MDC.(Group).(list{x}).MeanSD.(Params{j,1}).Right = nanmean(nanstd(SpatioTemporal_MDC.(Group).(list{x}).Angles_100.(Params{j,1}).Right'));
        
        SpatioTemporal_MDC.(Group).(list{x}).MeanSD.(Params{j,1}).All = (SpatioTemporal_MDC.(Group).(list{x}).MeanSD.(Params{j,1}).Left+SpatioTemporal_MDC.(Group).(list{x}).MeanSD.(Params{j,1}).Right)/2;
    end
    
end


