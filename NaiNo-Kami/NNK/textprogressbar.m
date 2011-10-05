function [progress_bar_position] = textprogressbar(i,max,progress_bar_position,time_for_this_iteration,text)


if exist('text','var') == 0 ; text = '' ; end
progress_bar_position = i / max;
progress_string='|';
for counter = 1:floor(progress_bar_position * 100 / 2),
    progress_string = [progress_string, '#'];
end
steps_remaining = max - i;
minutes = floor(time_for_this_iteration * steps_remaining / 60);
seconds = rem(floor(time_for_this_iteration *  steps_remaining), 60);
if (seconds > 9),
    timeremaining = [num2str(minutes) 'm ' num2str(seconds) 's'] ;
else
    timeremaining = [num2str(minutes) 'm 0' num2str(seconds) 's'];
end
progress_string = [progress_string ' - ' timeremaining ' remaining']; 
message= ['                     LAST NEWS                     ' text ];
n=round(51*(1-((length(message)/51)-floor(length(message)/51))));
spaces=repmat([' '],1,fix(n)) ;
message= [message spaces];
message= reshape(message,51,length(message)/51)';


    disp(['|=================================================|']);
disp(progress_string);
if floor(progress_bar_position * 100)<100
    disp(['|================= ',num2str(floor(progress_bar_position * 100)),'% completed =================|']);
else
    disp(['|================= ',num2str(floor(progress_bar_position * 100)),'% completed ================|']);
end
disp(message)
