function tbl=multinombootstrap(stimulus,monts,mustartstate2,sigmastartstate2...
  muendstate2,sigmaendstate2,mustartstate3,sigmastartstate3)

  stimulussize=size(stimulus);
  montssize=size(monts);

  assert(length(stimulussize)==2,'Stimulus vector is not sized correctly.');
  assert(montssize(1)==1&&montssize(2)==1,'Size of trials is not correct.');

  if isrow(stimulus)
    stimulus=stimulus';
  endif

  numtrials=length(stimulus);

  state2start=makedist('LogNormal','mu',mustartstate2,'sigma',sigmastartstate2);
  state2end=makedist('LogNormal','mu',muendstate2,'sigma',sigmaendstate2);
  state3start=makedist('LogNormal','mu',mustartstate3,'sigma',sigmastartstate3);

  state2startthresholds=random(state2start,numtrials,monts);
  state2endthresholds=state2startthresholds+random(state2end,numtrials,monts);
  state3startthresholds=random(state3start,numtrials,monts);

  State11=stimulus<state2startthresholds&stimulus<state3startthresholds;
  State2=state2startthresholds<stimulus&stimulus<state2endthresholds&stimulus<state3startthresholds;
  State12=state2endthresholds<stimulus&stimulus<state3startthresholds;
  State3=stimulus>state3startthresholds;

  State1=State11+State12;

  State2=State2.*2;
  State3=State3.*3;

  result=State1+State2+State3;

  result=categorical(result);

  for ind=1:monts
    tbl{ind}.stimulus=stimulus;
    tbl{ind}.result=result(:,ind);
  endfor

  end
