clear; clc;

wkpath = fileparts( matlab.desktop.editor.getActiveFilename);
wkpath = fullfile( wkpath, 'Figure_3');

files = {'Dataset1_TUB_Voxelwise_Correlation_FisherZ.nii.gz',...
    'Dataset2_TUB_Voxelwise_Correlation_FisherZ.nii.gz'};

files = cellfun( @(x) fullfile( wkpath, x), files, 'un', 0);

mri = cellfun( @MRIread, files, 'un', 0);
mask = ~isnan( mri{1}.vol);
r = cellfun( @(x) x.vol( mask), mri, 'un', 0);

% MNI coordinates
sz = size( mri{1}.vol);
[y, x, z] = ind2sub( sz, find( mask));
mni_xyz = mri{1}.vox2ras1 * [x(:), y(:), z(:), ones( numel(x), 1)]';
mni_x = mni_xyz( 1, :);

left_ind = mni_x < 0;
right_ind = ~(mni_x < 0);

% Correlation between TUB-PAG r and x coordinates
figure;
for k = 1 : 2
    dataset_name = regexp( files{ k}, 'Dataset[0-9]', 'match', 'once');

    subplot( 2, 2, 2*(k-1)+1)
    plot( mni_x( left_ind), r{ k}( left_ind), 'o');
    xlabel( 'MNI x (mm)'); ylabel( 'r (Fisher''s z');
    title( [dataset_name, ' L TUB']);

    subplot( 2, 2, 2*(k-1)+2);
    plot( mni_x( right_ind), r{ k}( right_ind), 'o');
    xlabel( 'MNI x (mm)'); ylabel( 'r (Fisher''s z');
    title( [dataset_name, ' R TUB']);
end
