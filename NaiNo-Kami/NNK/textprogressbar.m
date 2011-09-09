function [progress_bar_position] = textprogressbar(i,max,progress_bar_position,time_for_this_iteration,text)


if exist('text','var') == 0 ; text = '' ; end

progress_bar_position = progress_bar_position + 1 / max;

disp(['|=================================================|']);
progress_string='|';
for counter = 1:floor(progress_bar_position * 100 / 2),
    progress_string = [progress_string, '#'];
end
disp(progress_string);
disp(['|================= ',num2str(floor(progress_bar_position * 100)),'% completed =================|']);
% display progress per cent
steps_remaining = max - i;
minutes = floor(time_for_this_iteration * steps_remaining / 60);
seconds = rem(floor(time_for_this_iteration *  steps_remaining), 60);
disp(' ');
if (seconds > 9),
    disp(['          ' text ' estimated remaining time: ', num2str(minutes), ':', num2str(seconds)]);
    % show time indicators
else
    disp(['          ' text ' estimated remaining time: ', num2str(minutes), ':0', num2str(seconds)]);
end

