function plot_struct_structure(s,fs)
% function plot_struct_structure(s,fs)
%
% s is a MATLAB structure.
% fs is fontsize (optional, default=14)
% We plot an overview of the stucture of this structure
%       makes use of plot_graph
% function plot_struct_structure(s,fs)
%   Visualization of the field-structure of a Matlab datatype structure.
%
% Syntax:
%   plot_struct_structure(s,fs)
% Inputs: 
%   s:  MATLAB variable of datatype structure (isstruct(s)=true)
%  fs:  Fontsize (optional, default=14)
%
% Outputs:
%   No outputs.
%
% Example:
%   plot_struct_structure(struct('This',0,'is',1,'an',struct('example',2)))
%
%-------------------------------------------------------------------------
% Version 1.0
% 2016.09.30        Dr. Johannes Korsawe, Volkswagen AG, EXB/2
%-------------------------------------------------------------------------
% Works only for structs
if ~isstruct(s),return;end
if nargin==1,fs=14;end
% Gather data of structure
list{1} = s;    % Starting Entry for the list of to be examined data
listnames{1} = inputname(1);
if isempty(listnames{1}),listnames{1}='root';end
listindex(1) = 0;   % Zuordnungsindex
comment{1} = 'Root'; % Kommentar zu der Variable
nr = 1;   % Aktueller Index
laufindex=0;
while nr<=length(list),
    item = list{nr};     % Aktuelles Item
    actclass = class(item);
    if strcmp(actclass,'struct'),   % Struktur? Hänge neue Items an!
        comment{nr} = 'Structure';
        fn = fieldnames(item);
        nfn = length(fn);nl = length(list);
        for i=1:nfn,
            list{end+1} = item.(fn{i});
            test=ismember(fn{i},listnames);
            if test,   % Name gibt es schon!
                laufindex=laufindex+1;fn{i} = [fn{i},'_X_',num2str(laufindex)];
            end
            listnames{end+1} = fn{i};
            listindex(nl+i) = nr;
        end
    elseif strcmp(actclass,'matlab.ui.Figure'),
        disp('Figure');
        comment{nr} = '';
    elseif strcmp(actclass,'matlab.ui.container.Menu'),
        disp('uiMenu');
        comment{nr} = '';
    elseif strcmp(actclass,'matlab.ui.control.UIControl'),
        disp('uiControl');
        comment{nr} = '';
    elseif strcmp(actclass,'matlab.ui.container.Panel'),
        disp('uiPanel');
        comment{nr} = '';
    elseif strcmp(actclass,'matlab.graphics.axis.Axes'),
        disp('Axes');
    elseif strcmp(actclass,'matlab.graphics.chart.primitive.Line'),
        disp('Line');
        comment{nr} = '';
    elseif strcmp(actclass,'cell'),
        comment{nr} = 'Cell';
    elseif strcmp(actclass,'char'),
        comment{nr} = 'Char';
    elseif strcmp(actclass,'double'),
        n = size(item);
        comment{nr} = sprintf('%i x %i',n(1),n(2));
        if n(1)*n(2) ==1,   % Sonderfall Skalar
            comment{nr} = sprintf('%4.2f',item);
            if round(item)==item,
                comment{nr} = sprintf('%d',item);
            end
        end
    elseif strcmp(actclass,'logical'),
        n = size(item);
        comment{nr} = sprintf('Bool %i x %i',n(1),n(2));
    else,
        item
        actclass
        pause
    end
    nr = nr+1;
end
% Prepare call to plot_graph
% Exclude all items with empty comment
I = ~cellfun(@(x) isempty(x),comment);
list = list(I);
listnames = listnames(I);
comment = comment(I);
listindex = listindex(I);
I = find(I);
for i=2:numel(listindex),
    listindex(i) = find(I==listindex(i));
end
% Plot!
plot_graph(listnames,listindex(2:end),2:numel(listindex),'-comment',comment,'-direction','TB','-fontsize',fs);