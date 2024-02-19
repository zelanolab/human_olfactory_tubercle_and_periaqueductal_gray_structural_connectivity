clear; clc;
wkpath = fileparts( matlab.desktop.editor.getActiveFilename);
wkpath = fullfile( wkpath, 'Figure_7');

female = readtable( fullfile( wkpath, 'PathwayAverageFA_BMI_Female_AgeAdj.txt'));
male = readtable( fullfile( wkpath, 'PathwayAverageFA_BMI_Male_AgeAdj.txt'));
all = readtable( fullfile( wkpath, 'PathwayAverageFA_PeakRFA_BMI_GenderAgeAdj.txt'));

% correlation for female and male combined
[r, p] = corr( all.Pathway_Avg_FA_Adj, all.BMI_Adj);

% peak
[peak_r, peak_p] = corr( all.PeakR_FA_Adj, all.BMI_Adj);

% correlation for female
[female_r, female_p] = corr( female.Female_Path_Average_FA_AgeAdj, female.Female_BMI_AgeAjd);
female_n = length( female.Female_Path_Average_FA_AgeAdj);

% correlation for male
[male_r, male_p] = corr( male.Male_Path_Average_FA_AgeAdj, male.Male_BMI_AgeAjd);
male_n = length( male.Male_Path_Average_FA_AgeAdj);

% Compare female to male
z1 = 0.5 * log( (1 + female_r) ./ (1 - female_r));
z2 = 0.5 * log( (1 + male_r) ./ (1 - male_r));
f = sqrt( 1/(female_n - 3) + 1/(male_n - 3));
fm_z = (z1 - z2) / f;
fm_p = 2*( 1 - normcdf( abs( fm_z), 0, 1));


figure; 
subplot( 121);
hold on;
plot( female.Female_Path_Average_FA_AgeAdj, female.Female_BMI_AgeAjd, 'ro');
plot( male.Male_Path_Average_FA_AgeAdj, male.Male_BMI_AgeAjd, 'bo');
title( 'Females and Males')
xlabel( 'Fractional anisotropy');
ylabel( 'Body mass index');

% peak r
subplot( 122);
plot( all.PeakR_FA_Adj, all.BMI_Adj, 'o');
lsline
title( 'Peak')

xlabel( 'Fractional anisotropy');
ylabel( 'Body mass index');


% fdr correction for the correlation
pval = MRIread( fullfile( wkpath, 'Path_thr0.25_Voxel-Correlation-between_FA_and_BMI_for_dti_FA_to_MNI_s2_P.nii.gz'));
rval = MRIread( fullfile( wkpath, 'Path_thr0.25_Voxel-Correlation-between_FA_and_BMI_for_dti_FA_to_MNI_s2_R2Z.nii.gz'));

pval.vol = permute( pval.vol, [2, 1, 3]);
rval.vol = permute( rval.vol, [2, 1, 3]);

% p value on the path
mask = ~isnan( pval.vol);
mask_pval = pval.vol( mask);

% See https://brainder.org/2011/09/05/fdr-corrected-fdr-adjusted-p-values/
pthr = fdr( mask_pval(:), 0.005);

% Maximal negative correlation
[~, midx] = min( rval.vol(:));
[mx, my, mz] = ind2sub( size( rval.vol), midx);
% MNI coordinate
mni_xyz = rval.vox2ras1 * [mx, my, mz, 1]';

% Save thresholed r value map for plotting
rval.vol( pval.vol > pthr) = nan;
rval.vol = permute( rval.vol, [2, 1, 3]);
MRIwrite( rval, fullfile( wkpath, 'Thressholded_rval.nii.gz'));




