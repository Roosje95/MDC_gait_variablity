%% GetGaitParams_UKBBfrom2015
% gets gait params from UKBB data collected in set-up since 2015

% Needed: c3d files, parameter.mat file, f_Codes_UKBB, Gait_algo_1, btk

% Input: VD & Struct made with c3dtomat_multiFolder.m
% Output: StructAllC3D,StructAllGC

% April 2020, Rosa Visscher

clear all; clc; close all;

%% Settings

% file locations 
Path_data = ('...'); % folder containing c3d and params.mat file
Path_dest = ('...');% folder where you wanna save the processed data structs

% add all needed folders to the matlab path
addpath(Path_data)
addpath(Path_dest)
% ATTENTION: add the zip folder Codes_UKBB containing required functions
addpath(genpath('...\Codes_UKBB'));

%load mat_info file, so matlab knows how to read in the data
load('P:\Projects\NCM_CP\project_only\NCM_CP_MotorDevelopmentCurve\Data\mat_info_2019.mat')

%% Extract spatio-temporal and kinematic data

% ATTENTION: add list with file names you wanna process
measurements = ...;
total = length(measurements);
for x = 1:length(measurements)
    measurement = char(measurements{x,1});
    Direc_data = [Path_data '\' char(measurement)];
    cd(Direc_data) % move into subfolder subject
    subdirec = dir(fullfile(Direc_data,'*.c3d'));
    subdirec(strncmp({subdirec.name}, '.', 1)) = []; % removes the . and .. entries
            
            Kinetics = 1;%1=yes, 0=no
            EMG_recorded = 0;
       
        Copy_mat = 1;  
        Path_measurements = Direc_data;
        Path_temp = [Path_dest '\files_c3d'];
        Path_save = [Path_dest '\files_structs'];
        
        [StructAllC3D,StructAllGC] = A_generalScript_UKBBfrom2015(subject,Kinetics,Copy_mat,Path_measurements,Path_temp,Path_save,EMG_recorded);
        
        disp([x total]);    
    
    cd .. % move up to subject folders
    clc
end
