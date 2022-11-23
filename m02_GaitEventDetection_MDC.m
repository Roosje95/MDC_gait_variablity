%% m_GaitEventDetection_UKBB
% Main sheet for generating gait events from kinematic data

% Codes connected to Visscher & Sansgiri et al. "Towards validation and
% standardization of automatic gait event identification algorithms for use
% in paediatric pathological populations".
% Current version is with TOE instead of HLX, and optimized for overall gait patterns

% Needed to run:
% 1. btk installed [http://biomechanical-toolkit.github.io/]
% 2. c3d files with marker trajectories of LTOE/RTOE, LANK/RANK, SACR
% 3. Matlab functions provided by Visscher & Sansgiri et al. -
% f_EventDetection, f_CodesUKBB

% Input: c3d files 
% Outcomes: Events struct indicating frame on which gait event is estimated
% to happen, if Fig=1 plots will be generated to control if events were
% correctly identified - do this for first trial of each individual. If
% needed adapt thresholds to individual

% Date: 11.5.2021
% Sailee Sansgiri & Rosa Visscher
% contact: bt@ethz.ch

% Adapted for use on MDC dataset:
% October 2021, Rosa Visscher

close all;
clc;

%% Inital set-up

Path_data_folder = '...'; % location c3d files you want to extract gait events from
Path_save = '..'; % location to save outcomes
% ATTENTION: add the zip folders
Path_func = '...'; % location f_EventDetection.zip
Path_btk = '..'; % location btk.zip, from biomechanical toolkit for matlab
Path_ukbb = '..'; % location Codes_UKBB.zip

Dir_list= dir(Path_data_folder);
Dir_list=Dir_list(~ismember({Dir_list.name},{'.','..'}));

addpath(genpath(Path_btk)); % add path towards btk
addpath(genpath(Path_ukbb)); % add path towards ukbb functions
addpath(genpath(Path_func)); %add path to functions to estimate gait events
addpath(genpath(Path_data_folder)); % add path towards c3d files

Fig=1;%1=generate and save plots; 0=no plots are geenrate or saved

% ATTENTION: add which files you wanna proces, can be based on names
% Dir_list
list = '';

%% Multiple folders
for l=1:length(list)
%     participant=Dir_list(l).name;
    participant=list{l,1};
    Path_data = [Path_data_folder,'\',participant]; 
    cd(Path_data) %go to folder in which c3d files are saved
    
%% Initialize variables
DIR_c3d = dir(fullfile(Path_data,'*.c3d'));% lists c3d files within selected folder
DIR_c3d=DIR_c3d(~ismember({DIR_c3d.name},{'.','..'}));% remove empty lines

%% Define Markers 

% Define which markers you want to use to identify initial contact and
% toe-off
% Overall gait patterns, ANK marker showed best for indicating IC. 
% For evaluating toe-walkers specifically select TOE instead.
% Overall and per subgroup, HXL marker showed best results for estimating TO.
% If HLX isn't available use TOE.
% Marker velocity can be calculated with either marker but we selected
% SACR, T10 would be good alternative in case SACR isnt present.

% % for TD
% IC_MarkerName_L = [participant,'_LANK'];
% TO_MarkerName_L = [participant,'_LTOE'];
% IC_MarkerName_R = [participant,'_RANK'];
% TO_MarkerName_R = [participant,'_RTOE'];
% Velo_MarkerName = [participant,'_SACR'];

% for CP
IC_MarkerName_L = 'LANK';
TO_MarkerName_L = 'LTOE';
IC_MarkerName_R = 'RANK';
TO_MarkerName_R = 'RTOE';
Velo_MarkerName = 'SACR';

%% for-loop to perform calculations for all c3d files
for i=2:(length(DIR_c3d)) % -1 as static c3d is last c3d file within folder
    cd(Path_data) 
    c3dfile = cellstr(DIR_c3d(i).name);% select a c3d file
    c3d_name = split(c3dfile,'.');
    
    % Load c3d with btl
    btkData=btkReadAcquisition(c3dfile{1,1});
    btkClearEvents(btkData);
    metadata=btkGetMetaData(btkData);
    ff=btkGetFirstFrame(btkData);
    Markers = btkGetMarkers(btkData);
    angles=btkGetAngles(btkData);
    f = btkGetPointFrequency(btkData);
    n = btkGetPointFrameNumber(btkData);
    
    %% Correct marker names if needed - TD
    marker_names = fieldnames(Markers);
    for n_marker=1:length(marker_names)
    if contains(marker_names(n_marker),[participant,'_'])
        marker_name = split(marker_names(n_marker),'_');
        marker_names_new(n_marker) = marker_name(2,1);
    else 
        marker_names_new(n_marker)  = marker_names(n_marker);
    end%end if-loopmarker names
    end% end for-loop marker names
    

  N = numel(Markers); 
  for k=1:numel(marker_names)
     [Markers(1:N).(marker_names_new{k})] = deal(Markers.(marker_names{k})) ;
  end
        
    %% Correct for Walking Direction
    Velo_Marker = Markers.(Velo_MarkerName);
    
    % delete zeros at the beginning or end of an trial
    dir_i = abs(Velo_Marker(end, 1) - Velo_Marker(1, 1));
    dir_j = abs(Velo_Marker(end, 2) - Velo_Marker(1, 2));
    
    walkdir = 1;  % x is walkdir
    
    if (dir_i < dir_j)
        walkdir = 2;  % y is walkdir
    end
    
    % pos. or neg. direktion on axis
    sgn = sign(Velo_Marker(end, walkdir) - Velo_Marker(1, walkdir));
    walkdir = walkdir * sgn;
    [Markers_Corrected]=f_rotCoordinateSystem(Markers, walkdir, 1);
    gaitAxis=1;
    verticalAxis=3;
    
    %% Filtering Markers and preprocessing
    [B,A] = butter(4,6/(f/2),'low');

    filt_IC_marker_L = [];
    filt_IC_marker_R = [];
    filt_TO_marker_L = [];
    filt_TO_marker_R = [];
    filt_Velo_marker=[];
    filt_IC_marker_L(:,:,1) = filtfilt(B, A, Markers_Corrected.(IC_MarkerName_L));
    filt_TO_marker_L(:,:,1) = filtfilt(B, A, Markers_Corrected.(TO_MarkerName_L));
    filt_IC_marker_R(:,:,1) = filtfilt(B, A, Markers_Corrected.(IC_MarkerName_R));
    filt_TO_marker_R(:,:,1) = filtfilt(B, A, Markers_Corrected.(TO_MarkerName_R));
    filt_Velo_marker(:,:,1) = filtfilt(B, A, Markers_Corrected.(Velo_MarkerName));
    
    y_velo=filt_Velo_marker(:,gaitAxis,:);
    z_velo=filt_Velo_marker(:,verticalAxis,:);
    
    %Determine approximate walking speed
    [vel,time]=f_approxVelocity(y_velo,z_velo,f);
    vel2=vel/100;
    
    %% Kinematic Algorithm_Ghoussayni - initial contact
    [IC_L,~] = f_Ghoussayni_500(filt_IC_marker_L,filt_TO_marker_L,gaitAxis,verticalAxis,n,f);
    [IC_R,~] = f_Ghoussayni_500(filt_IC_marker_R,filt_TO_marker_R,gaitAxis,verticalAxis,n,f);
    
    %% Kinematic Algorithm_ModifiedGhoussayni - toe-off
    [~,TO_L]=f_Ghoussayni_variablethreshold(filt_IC_marker_L,filt_TO_marker_L,gaitAxis,verticalAxis,n,f,vel2);
    [~,TO_R]=f_Ghoussayni_variablethreshold(filt_IC_marker_R,filt_TO_marker_R,gaitAxis,verticalAxis,n,f,vel2);
    
    %% Collect outcomes in struct
    Events.(participant).(c3d_name{1,1}).Left.IC = IC_L;
    Events.(participant).(c3d_name{1,1}).Left.TO = TO_L;
    if Events.(participant).(c3d_name{1,1}).Left.IC(:,1)==1
        Events.(participant).(c3d_name{1,1}).Left.IC(:,1) = [];
    end
    Events.(participant).(c3d_name{1,1}).Right.IC = IC_R;
    Events.(participant).(c3d_name{1,1}).Right.TO = TO_R;
    Events.(participant).(c3d_name{1,1}).Markers = {IC_MarkerName_L, TO_MarkerName_L, IC_MarkerName_R, TO_MarkerName_R, Velo_MarkerName};
    if Events.(participant).(c3d_name{1,1}).Right.IC(:,1)==1
        Events.(participant).(c3d_name{1,1}).Right.IC(:,1) = [];
    end
    
     %% check data on few events
        fewEvents = length(IC_L) < 2 ...
        || length(TO_L) < 1 ...
        || length(IC_R) < 2 ...
        || length(TO_R) < 1;
    if fewEvents
        continue;
    end%end if to check if there are enough events
    
    %% Extract Spatio-temporal params
    EventsFrames.Right_Foot_Strike = IC_R;
    EventsFrames.Left_Foot_Strike = IC_L;
    EventsFrames.Right_Foot_Off = TO_R;
    EventsFrames.Left_Foot_Off = TO_L;
    
    GaitParam = f_GaitParameter_UKBB(Markers,EventsFrames,f);
    Events.(participant).(c3d_name{1,1}).GaitParam = GaitParam;
    
    %% Plot Outcomes
    if Fig == 1
        figure
        subplot(2,1,1) %Left
        hold on
        plot(filt_TO_marker_L(:,end),'b')
        plot(filt_IC_marker_L(:,end),'r')
        for n=1:length(Events.(participant).(c3d_name{1,1}).Left.TO)
            plot(Events.(participant).(c3d_name{1,1}).Left.TO(1,n),filt_TO_marker_L(Events.(participant).(c3d_name{1,1}).Left.TO(1,n),end),'*b')
        end
        for m=1:length(Events.(participant).(c3d_name{1,1}).Left.IC)
            plot(Events.(participant).(c3d_name{1,1}).Left.IC(1,m),filt_IC_marker_L(Events.(participant).(c3d_name{1,1}).Left.IC(1,m),end),'*r')
        end
        title_name = join(['Estimated gait events for' c3dfile '- Left']);
        title(title_name)
        subplot(2,1,2) %Right
        hold on
        plot(filt_TO_marker_R(:,end),'b')
        plot(filt_IC_marker_R(:,end),'r')
        for n=1:length(Events.(participant).(c3d_name{1,1}).Right.TO)
            plot(Events.(participant).(c3d_name{1,1}).Right.TO(1,n),filt_TO_marker_R(Events.(participant).(c3d_name{1,1}).Right.TO(1,n),end),'*b')
        end
        for m=1:length(Events.(participant).(c3d_name{1,1}).Right.IC)
            plot(Events.(participant).(c3d_name{1,1}).Right.IC(1,m),filt_IC_marker_R(Events.(participant).(c3d_name{1,1}).Right.IC(1,m),end),'*r')
        end
        title_name = join(['Estimated gait events for' c3dfile '- Right']);
        title(title_name)
    end
    
    clear IC_L IC_R TO_L TO_R Velo_Marker filt_IC_marker_L filt_IC_marker_R filt_TO_marker_L filt_TO_marker_R GaitParam
   
    
end %FOR-loop c3d files

% fprintf('%d out of %d \n',l,length(Dir_list));

end%for-loop multiple folders

%% Save outcomes in struct 
cd(Path_save) 
save('Events_outcomes.mat','Events');




