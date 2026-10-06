
% DO THIS: load the extra and correct file
record17 = record;
% DO THIS: load the last correct file
record.iCuedLoc(10,1:100) = ones(1,100); % times teh correct iLoc
record.RT(10,1:100) = record17.RT(17, 1:100);
record.answer(10,1:100) = record17.answer(17, 1:100);
record.correctness(10,1:100) = record17.correctness(17, 1:100);
record.targetPrs(10,1:100) = record17.targetPrs(17, 1:100);
% DO THIS: append record to the last correct file (remeber to add folderName!!!)

% DO THIS: load the extra and correct file
record.iCuedLoc(10,1:100) = ones(1,100); % times teh correct iLoc
record.RT(10,1:100) = record.RT(17, 1:100);
record.answer(10,1:100) = record.answer(17, 1:100);
record.correctness(10,1:100) = record.correctness(17, 1:100);
record.targetPrs(10,1:100) = record.targetPrs(17, 1:100);

record.iCuedLoc = record.iCuedLoc(1:10, :); % times teh correct iLoc
record.RT = record.RT(1:10, :);
record.answer = record.answer(1:10, :);
record.correctness = record.correctness(1:10, :);
record.targetPrs= record.targetPrs(1:10, :);
% DO THIS: append record to the extra and correct file (remeber to add folderName!!!)
% DO THIS: change the name of the extra and correct file
% DO THIS: delete the wrong file