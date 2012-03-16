function NNK_editsettings(setting)

if exist('setting','var')==0 
    if exist('settingsfilename.mat','file')==2
        load  settingsfilename.mat
    else
        disp(['Please tell me the setting file name you want to use ...    ' ; ...
              'Next time you launch a NNK commande the same filename       ' ; ...
              'will be used without asking. Change the settings filename by' ; ...
              'specification in NNK commande (ex:                          ' ; ...
              'NNK(''this-file-is-my-new-settings-file'')                    ' ]); 
        setting = input('Settings filename (no spaces):', 's');        
    end
end
save settingsfilename.mat setting
edit(setting);