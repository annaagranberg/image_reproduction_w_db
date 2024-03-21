function [Mean, Max, Delta_E] = Euclidean(resL, resA, resB, refL, refA, refB)

% lab channels for both pictures

DL = (resL-refL); 

DA = (resA-refA); 

DB = (resB-refB); 

Delta_E = sqrt(DL.^2 + DA.^2 + DB.^2);

Mean = mean(Delta_E);
Max = max(Delta_E);

end