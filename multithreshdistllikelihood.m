function llikelihood=multithreshdistllikelihood(x1,s1,x2,s2,x3,s3,stimulus,...
  State1index,State2index,State3index);

  monts=1e6;

  [State1Prob,State2Prob,State3Prob]= multinomialthresholddist(stimulus,...
    monts,x1,s1,x2,s2,x3,s3);

  %Replace 0s with smallest real value

  State1Prob(State1Prob==0)=1/(monts*2);
  State2Prob(State2Prob==0)=1/(monts*2);
  State3Prob(State3Prob==0)=1/(monts*2);

  llikelihoodstate1=log(State1Prob(State1index));
  llikelihoodstate2=log(State2Prob(State2index));
  llikelihoodstate3=log(State3Prob(State3index));

  llikelihood=-sum(llikelihoodstate1)-sum(llikelihoodstate2)-sum(llikelihoodstate3);

end
