% Make figures Plot p-value structural covariance maps for all subregions
clear; clc; close all

wkpath = fileparts( matlab.desktop.editor.getActiveFilename);
wkpath = fullfile( wkpath, 'Figure_1');

% figdir = fullfile( wkpath, 'Images');
% if ~exist( figdir, 'dir')
%     mkdir( figdir);
% end

datasets = {'Figure_1B_Dataset1', 'Figure_1B_Dataset2'};
folds = {'StdLRTub', 'StdLRAon', 'StdLRPirF', 'StdLRPirT'};

% x; 47
slice2plot = {'x', 47; 'y', 48; 'z', 32};

% threshold
p_thr = 0.995;

p = struct( 'threshold', [], 'cm', [], 'fontsize', 7, 'hold', 'on');
p.threshold = {[p_thr, 1]};
p.cm = {autumn};

for d_idx = 1 : length( datasets)
    dataset_name = regexp( datasets{ d_idx}, 'Dataset[0-9]$', 'match', 'once');

    for k = 1 : length( folds)
        fold = folds{ k};
        pos_pval = fullfile( wkpath, datasets{ d_idx}, fold, [fold, '_tfce_corrp_tstat1.nii.gz']);
        img2plot = {pos_pval};
        for j = 1 : size( slice2plot, 1)
            figure;
            % https://github.com/zelanolab/primaryolfactorycortexparcellation
            MNIOverlay( img2plot, slice2plot{ j, 2}, 'coord_style', slice2plot{ j, 1}, 'param', p);
            
            save_file = fullfile( figdir, sprintf( '%s_%s_thr%g_%s_%d', ...
                dataset_name, fold, p_thr, slice2plot{ j, 1}, slice2plot{ j, 2}));
        end
    end
end

