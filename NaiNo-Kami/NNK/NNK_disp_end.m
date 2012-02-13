function NNK_disp_end(timepause,time0)

% conn = database('fovpf','pgsql','olvssclr','org.postgresql.Driver','jdbc:postgresql://195.83.188.2') ;
% update(conn, 'acquisition',{'date_heure'},{'2010-03-08 10:00:00'},{'where num_appli = 21 and num_type = 24'}) ;
% close(conn)

timelasped = clock-time0 ;
elasped = '';
unit = ['Y';'M';'D';'h';'m';'s'] ; 
for i = 1:length(timelasped)
    test = fix(timelasped(i)) ; 
    if test > 0 
        elasped = [elasped ' ' char(num2str(test)) unit(i,1)] ; 
    end
end
        
count = 0 ; 
for i = 1 : 2*timepause
    pause(0.5)
    clc
    count = count + 1 ;
    
    minut = fix(((timepause)-(i/2))/60) ; 
    second = fix(((timepause)-(i/2))-(minut*60)) ; 
    timeleft = [ num2str(minut) ':' num2str(second)] ; 
    
    if count == 1
        disp('          ___   ____')
        disp('        /'' --;^/ ,-_\     \ | /    | | | /| | "|" | |\| /"_  ')
        disp('       / / --o\ o-\ \\   --(_)--   |/|/ /"| |  |  | | | \_|   ')
        disp('      /-/-/|o|-|\-\\|\\   / | \')
        disp('       ''`  ` |-|   `` ''               |\| |_" | | |   |\  /| "|"  /|')
        disp('             |-|                      | | |__ |/|/    |/ /"|  |  /"|   o  o  o')
        disp('             |-|O')
        disp('             |-(\\__')
        disp('          ...|-|\--,\_....')
        disp('      ,;;;;;;;;;;;;;;;;;;;;;;;;,.')
        disp(['~~,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,~~~~~~~~~~~~~~ Latest process done in' elasped '. Wait ' timeleft ' for next process ~~~~~~~~~~~~~~~~~~~~~~~~~'])
    
    elseif count == 2
        disp('          ___   ____')
        disp('        /'' --;^/ ,-_\     \ | /    | | | /| | "|" | |\| /"_  ')
        disp('       / / --o\ o-\ \\   --(_)--   |/|/ /"| |  |  | | | \_|   ')
        disp('      /-/-/|o|-|\-\\|\\   / | \')
        disp('       ''`  ` |-|   `` ''               |\| |_" | | |   |\  /| "|"  /|')
        disp('             |-|   Z                  | | |__ |/|/    |/ /"|  |  /"|   o  o  o')
        disp('             |-|O')
        disp('             |-(\\__')
        disp('          ...|-|\--,\_....')
        disp('      ,;;;;;;;;;;;;;;;;;;;;;;;;,.')
        disp(['~~,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,~~~~~~~~~~~~~~ Latest process done in' elasped '. Wait ' timeleft ' for next process ~~~~~~~~~~~~~~~~~~~~~~~~~'])
        
    elseif count == 3
        disp('          ___   ____')
        disp('        /'' --;^/ ,-_\     \ | /    | | | /| | "|" | |\| /"_  ')
        disp('       / / --o\ o-\ \\   --(_)--   |/|/ /"| |  |  | | | \_|   ')
        disp('      /-/-/|o|-|\-\\|\\   / | \')
        disp('       ''`  ` |-| Z `` ''               |\| |_" | | |   |\  /| "|"  /|')
        disp('             |-|    Z                 | | |__ |/|/    |/ /"|  |  /"|   o  o  o')
        disp('             |-|O')
        disp('             |-(\\__')
        disp('          ...|-|\--,\_....')
        disp('      ,;;;;;;;;;;;;;;;;;;;;;;;;,.')
        disp(['~~,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,~~~~~~~~~~~~~~ Latest process done in' elasped '. Wait ' timeleft ' for next process ~~~~~~~~~~~~~~~~~~~~~~~~~'])
        
    elseif count == 4
        disp('          ___   ____')
        disp('        /'' --;^/ ,-_\     \ | /    | | | /| | "|" | |\| /"_  ')
        disp('       / / --o\ o-\ \\   --(_)--   |/|/ /"| |  |  | | | \_|   ')
        disp('      /-/-/|o|-|\-\Z|\\   / | \')
        disp('       ''`  ` |-|   ``Z''               |\| |_" | | |   |\  /| "|"  /|')
        disp('             |-| Z                    | | |__ |/|/    |/ /"|  |  /"|   o  o  o')
        disp('             |-|O')
        disp('             |-(\\__')
        disp('          ...|-|\--,\_....')
        disp('      ,;;;;;;;;;;;;;;;;;;;;;;;;,.')
        disp(['~~,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,~~~~~~~~~~~~~~ Latest process done in' elasped '. Wait ' timeleft ' for next process ~~~~~~~~~~~~~~~~~~~~~~~~~'])
        
    elseif count == 5
        count = 0 ; 
        disp('          ___   ____')
        disp('        /'' --;^/ ,-_\     \ | /    | | | /| | "|" | |\| /"_  ')
        disp('       / / --o\ o-\ \\   --(_)--   |/|/ /"| |  |  | | | \_|   ')
        disp('      /-/-/|o|-|\-\Z|\\   / | \')
        disp('       ''`  ` |-| Z `` ''               |\| |_" | | |   |\  /| "|"  /|')
        disp('             |-|                      | | |__ |/|/    |/ /"|  |  /"|   o  o  o')
        disp('             |-|O')
        disp('             |-(\\__')
        disp('          ...|-|\--,\_....')
        disp('      ,;;;;;;;;;;;;;;;;;;;;;;;;,.')
        disp(['~~,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,~~~~~~~~~~~~~~ Latest process done in' elasped '. Wait ' timeleft ' for next process ~~~~~~~~~~~~~~~~~~~~~~~~~'])
    end
end