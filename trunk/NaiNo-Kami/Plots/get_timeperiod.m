function get_timeperiod(in,ind,tex)
global butt
if exist(fullfile(pwd,[in '.m']),'file')==2
    delete(fullfile(pwd,[in '.m']));
    set(butt(ind),'String',tex,'TooltipString','Pick a time period file')
else
    loc=pwd;
    if exist('../tmp/mempath.mat','file')==2
        load ../tmp/mempath.mat;cd(pathname)
    end
    [filename,pathname]=uigetfile('*.m','Pick a MATLAB time period file');
    cd(loc);
    copyfile(fullfile(pathname,filename),fullfile(pwd,[in '.m']));
    set(butt(ind),'String','X','TooltipString','Delete the time period file')
    save ../tmp/mempath pathname
end