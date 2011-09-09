function clearselected(in)

global hpp hp


delete(hpp(in))
hpp(in)=0;
[hpp] = resizepanels(hp,hpp,0);
