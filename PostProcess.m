function [] = PostProcess(dat)

t = dat.t; u = dat.u; y = dat.y;

clr = LoadPlotlyColors();
fh = figure( 'Name', 'Magnetic levitation system' );
stairs( t, u( :, 1 ), 'Color', clr.brick_red, ...
        'LineStyle', '-', 'LineWidth', 0.5 );
hold on; box on; grid on;
plot( t, y( :, 1 ), 'Color', clr.muted_blue, ...
        'LineStyle', '-', 'LineWidth', 0.5 );
xlabel( 't [s]' ); ylabel( 'U / Y' ); title( 'Input-Output' );
legend( 'Input, U', 'Output, Y' );
set( legend, 'Location', 'South' );
set( legend, 'Orientation', 'Horizontal');
xlim( [ min( t ) max( t ) ] ); ylim( [ -2 8 ] );
xticks = 0:300:900; yticks = -2:3:8;
FigureAesthetics( fh, 'Times New Roman', 12, clr );

% exportgraphics( fh, 'fig\png\MagLevTrainingData.png', 'Resolution', 1200 );
% exportgraphics( fh, 'fig\eps\MagLevTrainingData.eps');
% exportgraphics( fh, 'fig\png\MagLevTestDataTR.png', 'Resolution', 1200 );
% exportgraphics( fh, 'fig\eps\MagLevTestDataTR.eps');
% exportgraphics( fh, 'fig\png\MagLevTestDataSS.png', 'Resolution', 1200 );
% exportgraphics( fh, 'fig\eps\MagLevTestDataSS.eps');