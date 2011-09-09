function selector(action,lincre)

global fieldedit 

lesincre = [1/(24*60) ; 1/(24) ; 1 ; 30.5] ;

switch(action)

    case 'plus' 
        entereddate = get(fieldedit(1),'String') ;

        date1 = entereddate([1 2 4 5 7 8]) ;
        hour1 = entereddate([10 11]) ;
        minu1 = entereddate([13 14]) ;
        sec1  = entereddate([16:length(entereddate)]) ;
        
        eval(['toset = datestr(datenum([date1 hour1 minu1 sec1(1:2)],''yymmddHHMMSS'')+(' lincre '*(1)),''yy/mm/dd HH:MM:SS'');'])
        set(fieldedit(1),'String',toset) ;
        
    case 'moins' 
        entereddate = get(fieldedit(1),'String') ;

        date1 = entereddate([1 2 4 5 7 8]) ;
        hour1 = entereddate([10 11]) ;
        minu1 = entereddate([13 14]) ;
        sec1  = entereddate([16:length(entereddate)]) ;

        eval(['toset = datestr(datenum([date1 hour1 minu1 sec1(1:2)],''yymmddHHMMSS'')+(' lincre '*(-1)),''yy/mm/dd HH:MM:SS'');'])
        set(fieldedit(1),'String',toset) ;
        
    case 'plus2' 
        entereddate = get(fieldedit(4),'String') ;

        date1 = entereddate([1 2 4 5 7 8]) ;
        hour1 = entereddate([10 11]) ;
        minu1 = entereddate([13 14]) ;
        sec1  = entereddate([16:length(entereddate)]) ;

        eval(['toset = datestr(datenum([date1 hour1 minu1 sec1(1:2)],''yymmddHHMMSS'')+(' lincre '*(1)),''yy/mm/dd HH:MM:SS'');'])
        set(fieldedit(4),'String',toset) ;
        
    case 'moins2' 
        entereddate = get(fieldedit(4),'String') ;

        date1 = entereddate([1 2 4 5 7 8]) ;
        hour1 = entereddate([10 11]) ;
        minu1 = entereddate([13 14]) ;
        sec1  = entereddate([16:length(entereddate)]) ;

        eval(['toset = datestr(datenum([date1 hour1 minu1 sec1(1:2)],''yymmddHHMMSS'')+(' lincre '*(-1)),''yy/mm/dd HH:MM:SS'');'])
        set(fieldedit(4),'String',toset) ;
        
end

