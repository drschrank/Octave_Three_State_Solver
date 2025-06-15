function [State1Prob,State2Prob,State3Prob,plotstimulus,llike,x]=...
  threestateanalysis(tbl,x0,optionsolve,boots,optionboots,numofworkers,ci);

[xbest,llike,xboot]=multithreshsolver(tbl,x0,optionsolve,boots,optionboots,...
  numofworkers);

 plotstimulus=1:10:5000;
 plotstimulus=plotstimulus';

 %Get some values for the 50% and 95% confidence estimates

[State1Prob.best,State2Prob.best,State3Prob.best]=multinomialthresholddist(plotstimulus,...
   1e4,xbest(1),xbest(2),xbest(3),xbest(4),xbest(5),xbest(6));

%for ind=1:boots
%  [State1Probboot(ind,:),State2Probboot(ind,:),State3Probboot(ind,:)=...
%    multinomialthresholddist(plotstimulus,1e4,xboot(ind,1),xboot(ind,2),xboot(ind,3),xboot(ind,4),...
%     xboot(ind,5),xboot(ind,6));
%endfor

 %Find the confidence intervals

 State1Prob.lo=prctile(State1Probboot,(1-ci)/2*100);
 State2Prob.lo=prctile(State2Probboot,(1-ci)/2*100);
 State3Prob.lo=prctile(State3Probboot,(1-ci)/2*100);

 State1Prob.hi=prctile(State1Probboot,(1-(1-ci)/2)*100);
 State2Prob.hi=prctile(State2Probboot,(1-(1-ci)/2)*100);
 State3Prob.hi=prctile(State3Probboot,(1-(1-ci)/2)*100);

 %Find the 50-percentile solution
 State1Prob.med=prctile(State1Probboot,50);
 State2Prob.med=prctile(State2Probboot,50);
 State3Prob.med=prctile(State3Probboot,50);

 %Get the parameters for the fit and the parameter confidence intervals.
 x.lo=prctile(xboot,(1-ci)/2*100);
 x.hi=prctile(xboot,(1-(1-ci)*2)*100);
 x.med=prctile(xboot,50);
end
