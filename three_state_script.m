%Script to analyize 3 state data. Needs to have a table called tbl with the following
%stimulus(double)
%result(categorical)
%result is defined in the following way:
%1,2,3

%Setup option for the analysis
optionsolve=optimset('MaxFunEvals',1e5,'MaxIter',500,'TolFul',1,'TolX',1,...
  'Display','iter','PlotFcns',@optiplotfval);
x0=[log(700),0.2,log(500),0.4,log(1700),0.1];

%Setup bootstrap options
boots=1000
optionboots=optimset('MaxFunEvals',1e5,'MaxIter',500,'TolFul',1,'TolX',1);
numofworkers=8;
ci=0.95

%Do the analysis

[State1Prob,State2Prob,State3Prob,plotstimulus,llike,x]=...
  threestateanalysis(tbl,x0,optionsolve,boots,optionboots,numofworkers,ci);

%Plot Results

figure;
hold on;
State1Plot=plot(plotstimulus,State1Prob.best,'-b',plotstimulus,State1Prob.hi','b:',...
  plotstimulus,State1Prob.lo,':b');
State2Plot=plot(plotstimulus,State2Prob.best,'-b',plotstimulus,State2Prob.hi','b:',...
  plotstimulus,State2Prob.lo,':b');
State3Plot=plot(plotstimulus,State3Prob.best,'-b',plotstimulus,State3Prob.hi','b:',...
  plotstimulus,State3Prob.lo,':b');



