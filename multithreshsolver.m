function [xbest,llike,xboot]=multithreshsolver(tbl,x0,optionsolve,boots,optionboots,...
  numofworkers)

  stimulus=tbl.stimulus;

%Get the indices of State 1, State 2, and State 3 in order to speed up the computation time.

  State1index=find(tbl.result==1);
  State2index=find(tbl.result==2);
  State3index=find(tbl.result==3);

%Setup a function to remap anything below zero to the smallest possible float.
  remap=@(x)x.*(x>0)+realmin.*(x<=0);

%Minimization fuction
  minfunc=@(x)multithreshdistllikelihood(remap(x(1)),remap(x(2)),remap(x(3)),...
    remap(x(4)),remap(x(5)),remap(x(6)),stimulus,...
    State1index,State2index,State3index);

[x,llike,exitflag]=fminsearch(minfunc,x0,optionsolve);

close all;

if ~exitflag
    error('Could not find best fit to data. Terminating search.');
endif

bootbl=multinombootstrap(stimulus,boots,x(1),x(2),x(3),x(4),x(5),x(6));

x0=x;

%Setup parralell pool for MATLAB only
%pool=parpool(numofworkers);

%Setup progress bar for parrelell pool (works only with MATLAB)
%Progress=parfor_progressbar(boots,'Progress through bootstrap calculation');

%parfor ind=1:boots
parfor (ind=1:boots,numofworkers);

  stimulus=bootbl{ind}.stimulus;

  %Get the indices of State 1, State 2, and State 3 in order to speed up the
  %computaiton time.

  State1index=find(bootbl{ind}.result==1);
  State2index=find(bootbl{ind}.result==2);
  State3index=find(bootbl{ind}.result==3);

  %%%Need to include in parfor loop to pass to the workers.
  %Setup a function to remap anything below zero to the smallest possible float.
  remap=@(x)x.*(x>0)+realmin.*(x<=0);

  %Minimization fuction
  minfunc=@(x)multithreshdistllikelihood(remap(x(1)),remap(x(2)),remap(x(3)),...
    remap(x(4)),remap(x(5)),remap(x(6)),stimulus,...
    State1index,State2index,State3index);

  [x,llike,exitflag]=fminsearch(minfunc,x0,optionboots);

  if ~exitflag
    warning('xboot not found for this interation. Delete from list.');
    xboot(ind,:)=nan;
  endif

  %Progress.iterate(1);

endparfor

%Remove any xboots that weren't found because we got to the end of our
%max interations before converging

xboot(isnan(xboot))=[];

%Clean up parallel objects

%close(Progress);
%delete(pool);

x=remap(x);
xboot=remap(xboot);
end
