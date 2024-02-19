clear; clc;

wkpath = fileparts( matlab.desktop.editor.getActiveFilename);
wkpath = fullfile( wkpath, 'Figure_8');

data = readtable( fullfile( wkpath, 'Figure8_Dataset1_TUB-PAG_Age-Gender-wholeBrainFA-adjusted_FA-BMI.txt'));
[r, p] = corr( data.Pathway_Avg_FA_Adj, data.BMI_Adj);

figure;
plot( data.Pathway_Avg_FA_Adj, data.BMI_Adj, 'o');
xlabel( 'Fractional anisotropy'); ylabel( 'Body mass index');

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

% Save thresholed r value map for plotting
rval.vol( pval.vol > pthr) = nan;
rval.vol = permute( rval.vol, [2, 1, 3]);
MRIwrite( rval, fullfile( wkpath, 'Thressholded_rval.nii.gz'));
