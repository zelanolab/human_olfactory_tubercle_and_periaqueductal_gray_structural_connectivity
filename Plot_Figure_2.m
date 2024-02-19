% Partial corrleation (using regression method) between TUB and PAg, and
% NAcc and PAG.

% Age, Gender, NAcc gray matter density was regressed out when calculating
% the correlation between TUB and PAG.

% Age, Gender, TUB gray matter density was regressed out when calculating
% the correlation between NAcc and PAG.

clear; clc; close all
wkpath = fileparts( matlab.desktop.editor.getActiveFilename);
wkpath = fullfile( wkpath, 'Figure_2');

d1 = readtable( fullfile( wkpath, 'Dataset1_Partial_Correlation_GMD.txt'));
d2 = readtable( fullfile( wkpath, 'Dataset2_Partial_Correlation_GMD.txt'));

[d1_tub_r, d1_tub_p] = corr( d1.TUB_with_NAccRegressed, d1.PAG_with_NAccRegressed);
[d2_tub_r, d2_tub_p] = corr( d2.TUB_with_NAccRegressed, d2.PAG_with_NAccRegressed);

[d1_nacc_r, d1_nacc_p] = corr( d1.NAcc_with_TUBRegressed, d1.PAG_with_TUBRegressed);
[d2_nacc_r, d2_nacc_p] = corr( d2.NAcc_with_TUBRegressed, d2.PAG_with_TUBRegressed);

tbl = array2table( [d1_tub_r, d1_tub_p, d1_nacc_r, d1_nacc_p; ...
    d2_tub_r, d2_tub_p, d2_nacc_r, d2_nacc_p], ...
    'VariableNames', {'TUB-PAG r', 'TUB-PAG p', 'NAcc-PAG r', 'NAcc-PAG p'}, ...
    'RowNames', {'Dataset1', 'Dataset2'});

% % Write table to file
% writetable( tbl, 'Partial_corr_result.xlsx', 'WriteVariableNames', true, 'WriteRowNames', true);

figure;
subplot( 221)
plot( d1.TUB_with_NAccRegressed, d1.PAG_with_NAccRegressed, 'o');
lsline;
legend off
title( 'TUB-PAG Dataset1');

subplot( 222)
plot( d2.TUB_with_NAccRegressed, d2.PAG_with_NAccRegressed, 'o');
lsline;
legend off
title( 'TUB-PAG Dataset2')

subplot( 223)
plot( d1.NAcc_with_TUBRegressed, d1.PAG_with_TUBRegressed, 'o');
lsline;
legend off
title( 'NAcc-PAG Dataset1')

subplot( 224)
plot( d2.NAcc_with_TUBRegressed, d2.PAG_with_TUBRegressed, 'o');
lsline;
legend off
title( 'NAcc-PAG Dataset2')
