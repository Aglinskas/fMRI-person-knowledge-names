


%% Subjects
faces_svec = [7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31];
faces_drop_subs = [13 23];
faces_svec(ismember(faces_svec,faces_drop_subs)) = [];


words_svec = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31];
words_drop_subs = [11 12 21 25];
words_svec(ismember(words_svec,words_drop_subs)) = [];
%% Templates

words_beta_fn = '/Users/aidasaglinskas/Google Drive/Aidas/Data_words/S%d/Analysis2/beta_%.4i.nii';
faces_beta_fn = '/Users/aidasaglinskas/Google Drive/Aidas/Data_faces/S%d/Analysis/beta_%.4i.nii';
ROI_dir_fn = '/Users/aidasaglinskas/Google Drive/Aidas/Data_words/ROIs_PersonKnowledge/';
    tlbls = {'First memory'    'Attractiveness'    'Friendliness'    'Trustworthiness'    'Familiarity' 'Common name'    'How many facts'    'Occupation'    'Distinctiveness'    'Full name'    'Same Face' 'Same monument'};
    
%% ROIs
clc
ROIs = struct;
ROIs.dir = ROI_dir_fn;
temp = dir([ROIs.dir 'ROI*.nii']);
ROIs.files = {temp.name}';
ROIs.lbls = ROIs.files;
    %ROIs.lbls = strrep(ROIs.lbls,'','')
    ROIs.lbls = strrep(ROIs.lbls,'ROI_','');
    ROIs.lbls = strrep(ROIs.lbls,'.nii','');
    ROIs.lbls = strrep(ROIs.lbls,'-Left','-L');
    ROIs.lbls = strrep(ROIs.lbls,'-Right','-R');
    ROIs.lbls = strrep(ROIs.lbls,'Left','-L');
    ROIs.lbls = strrep(ROIs.lbls,'Right','-R');
    ROIs.lbls = strrep(ROIs.lbls,'Amygdala','AMY');
    ROIs.lbls = strrep(ROIs.lbls,'Angular','AG');
    ROIs.lbls = strrep(ROIs.lbls,'Prec','PREC');
    ROIs.lbls
%% Contrast vec

vec = repmat([ones(1,12) zeros(1,6)],1,5);
bt_inds = find(vec);


%%

%mats = [];
%vxMats = [];

fns = {faces_beta_fn words_beta_fn}';
svecS = {faces_svec words_svec};
exp_names = {'Faces' 'Names'};


tic
for exp_ind = 2;

use_fn = fns{exp_ind};
use_svec = svecS{exp_ind};

for r = 1:length(ROIs.files);
mask_fn = fullfile(ROIs.dir,ROIs.files{r});

for s = 1:length(use_svec);
subID = use_svec(s);

clc;
disp(exp_names{exp_ind})
disp(sprintf('S:%d/%d, R:%d/%d',s,length(use_svec),r,length(ROIs.files)));
disp(mats)
toc
for t = 1:12;
task_betas = bt_inds(t:12:end);

for sess = 1:5;
this_bt_ind = task_betas(sess);

dt_fn = sprintf(use_fn,subID,this_bt_ind);


ds = cosmo_fmri_dataset(dt_fn,'mask',mask_fn);

mats{exp_ind}(r,t,s,sess) = nanmean(ds.samples);
vxMats{exp_ind}{r,t,s,sess} = ds.samples;


end % ends sessions
end % ends tasks
end % ends subs 
end % ends ROIs

end % ends exp


disp('all done')
toc

save('/Users/aidasaglinskas/Desktop/OutRaw.mat')
%'mats','vxMats',svecS

%%
load('/Users/aidasaglinskas/Desktop/OutRaw.mat')

aBeta = []
aBeta.fmat_raw = mean(mats{1},4);
aBeta.fmat = aBeta.fmat_raw - aBeta.fmat_raw(:,11,:);
aBeta.fmat = aBeta.fmat(:,1:10,:);
aBeta.fsubs = svecS{1};
aBeta.wmat_raw = mean(mats{2},4);
aBeta.wmat = aBeta.wmat_raw - aBeta.wmat_raw(:,11,:);
aBeta.wmat = aBeta.wmat(:,1:10,:);
aBeta.wsubs = svecS{2};

aBeta.r_lbls = ROIs.lbls;
aBeta.t_lbls = tlbls;
aBeta.t_lbls10 = aBeta.t_lbls(1:10);










