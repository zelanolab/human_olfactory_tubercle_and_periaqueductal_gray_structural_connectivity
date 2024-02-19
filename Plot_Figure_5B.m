% Probability of the connection to each of the olfactory subregions
clear; clc; 

wkpath = fileparts( matlab.desktop.editor.getActiveFilename);
wkpath = fullfile( wkpath, 'Figure_5');

roi_nams = {'Tub', 'AON', 'PirF', 'PirT'};
file_name = fullfile( wkpath, 'Fig5b_Seed_Target-AON-PirF-PirT-Tub_thr_1.txt');

prob_mat = importdata( file_name);
hdr_nam = cellfun( @(x) strtrim( x), prob_mat.textdata, 'un', 0);
[is_exist, locb] = ismember( roi_nams, hdr_nam);
if any( ~is_exist)
    error( '%s were not found.', strjoin( roi_nams( is_exist), ', '));
end

% Normalize by waytotal
idx4norm = 2;
norm_meth = lower( strtrim( prob_mat.textdata{ idx4norm} ));
mat = prob_mat.data( :, locb) ./ prob_mat.data( :, idx4norm);

% one-way repeated anova
% https://www.mathworks.com/matlabcentral/fileexchange/5576-rmaov1
[nb_subj, nb_roi] = size( mat);
f_subj = repmat( (1 : nb_subj)', [nb_roi, 1]);
f_region = arrayfun( @(x) x*ones( nb_subj, 1), (1:nb_roi)', 'un', 0);
f_region = cell2mat( f_region);
[P1, F1, es] = rm_anova1( [mat(:), f_region, f_subj]);
% F3, 1005, P1 = 0 F = 466.55 es = 0.5821

figure; 
boxplot( mat(:), f_region);
set( gca, 'xtick', 1:nb_roi, 'xticklabel', roi_nams);
ylabel( sprintf( 'Probability (Normalized by %s)', norm_meth))
