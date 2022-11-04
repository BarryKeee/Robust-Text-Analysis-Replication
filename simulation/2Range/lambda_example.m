function [lambda] = lambda_example(p1,p2)
%lambda = lambda_example(p1,p2) describes the range of possible values of the Herfindahl index for a given
%p1 and p2. See Ke, Nesbit, Montiel Olea (2022). Both p1,p2 are elements of the (0,1) interval.

arguments
        
        p1 (1,1) {mustBeNumeric,mustBeGreaterThanOrEqual(p1,0),mustBeLessThanOrEqual(p1,1)}
        
        p2 (1,1) {mustBeNumeric,mustBeGreaterThanOrEqual(p2,0),mustBeLessThanOrEqual(p2,1)}
                         
end

if p2>2*p1
    
   aux    = p1/p2;
    
   lambda = (aux)^2 + (1-aux)^2;
   
   clear aux
    
elseif p2 < (2*p1) -1
    
   aux    = (1-p1)/(1-p2); 
    
   lambda = (aux)^2 + (1-aux)^2;
   
   clear aux
   
else 
   
   lambda = 1/2;
   
end
end

