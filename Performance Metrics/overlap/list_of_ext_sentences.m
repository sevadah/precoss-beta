function sent_IDs = list_of_ext_sentences(runFold, whichFolder)
    % as from model type to type there could be different number of sentences simulated (in testing stage)
    % this function scans for the number of sentences in Data folder where simulated data is
    % for each folder typically under different folders under 'ModelFolder/Data/simFolder

    fpath = fullfile(runFold, whichFolder{1}); % there is at least one folder

    listing = dir(fpath);

    ext_sentences = listing(contains({listing.name}, "_DR8_"));

    sent_IDs = {ext_sentences.name};

end