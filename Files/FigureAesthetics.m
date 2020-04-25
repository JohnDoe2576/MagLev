function [] = FigureAesthetics(FigHdl, fn, fs, clr)
%               FigHdl: Figure Handle
%               fn: Font Name
%               fs: Font Size
%               clr: Custom color object

% Figure properties
FigHdl.Units = 'centimeters';
FigHdl.Position = [25 1.75 24 10];
FigHdl.Color = 'w';

% Axis properties
AxHdl = FigHdl.CurrentAxes;
AxHdl.FontName = fn; AxHdl.FontSize = fs;
AxHdl.TitleFontWeight = 'normal';
AxHdl.TitleFontSizeMultiplier = 1.0;
AxHdl.LabelFontSizeMultiplier = 1.0;
AxHdl.Color = clr.my_grey; AxHdl.GridColor = 'w';
AxHdl.XColor = 'k'; AxHdl.YColor = 'k'; AxHdl.ZColor = 'k';
AxHdl.LineWidth = 0.6; AxHdl.GridAlpha = 1;