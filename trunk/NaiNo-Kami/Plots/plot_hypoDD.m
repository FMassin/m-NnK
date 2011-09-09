function plot_hypoDD(in,file)

if exist('file','var') == 0
    file = '/Users/fredmassin/PhD/HypoDD/2007/all/phase.dat';
    file0 = '/Users/fredmassin/PhD/HypoDD/2007/all/event.dat';
    fileloc = '/Users/fredmassin/PhD/HypoDD/2007/all/hypoDD.loc';
    filereloc = '/Users/fredmassin/PhD/HypoDD/2007/all/hypoDD.reloc';
end
if exist('in','var') == 0
    in = 'all';
end

switch in
    case {'1','all'}
        figure('Position',[1 330 1440 454])
        % LOC
        event = importdata(fileloc) ; %disp(num2str(event(1:5,:)));
        xerr = event(:,8);
        yerr = event(:,9);
        herr = mean([xerr yerr],2);
        zerr = event(:,10);
        merr = mean(event(:,8:10),2);
        disp(['LOC | median error = ' num2str(median(merr)) ...
            ' | median H-error = ' num2str(median(herr)) ...
            ' median Z-error = ' num2str(median(zerr)) ])
        x=-50:50:5100;
        ax(1)=subplot(1,3,1);hold on;hist(herr,x)
        ax(2)=subplot(1,3,2);hold on;hist(zerr,x)
        ax(3)=subplot(1,3,3);hold on;hist(merr,x) 
        
        % RELOC
        event = importdata(filereloc) ; %disp(num2str(event(1:5,:)));
        xerr = event(:,8);
        yerr = event(:,9);
        herr = mean([xerr yerr],2);
        zerr = event(:,10);
        merr = mean(event(:,8:10),2);
        disp(['RELOC | median error = ' num2str(median(merr)) ...
            ' | median H-error = ' num2str(median(herr)) ...
            ' median Z-error = ' num2str(median(zerr)) ])
        axes(ax(1));[n,xout]=hist(herr,x);bareloc(1)=bar(xout,n,'g');box on;title('Horizontal errors');xlabel('Error [m]');ylabel('Number of event')
        axes(ax(2));[n,xout]=hist(zerr,x);bareloc(2)=bar(xout,n,'g');box on;title('Vertical errors');xlabel('Error [m]');ylabel('Number of event')
        axes(ax(3));[n,xout]=hist(merr,x);bareloc(3)=bar(xout,n,'g');box on;title('Mean errors');xlabel('Error [m]');ylabel('Number of event')
        legend('hypod71','hypoDD')
        linkaxes(ax,'xy')
        xlim([-50 1000]);ylim([0 600])
        
end