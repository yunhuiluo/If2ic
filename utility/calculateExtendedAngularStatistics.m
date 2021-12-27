function [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
    calculateExtendedAngularStatistics(A, B)
    
    n=size(A, 1);
    angles=zeros(n, 1);
    
    for i=1:n
        a=A(i, :)';
        b=B(i, :)';
        
        angles(i)=rad2deg(acos(a'*b/(sqrt((a'*a)*(b'*b)))));
        
    end
    
    minAngle=min(angles);
    meanAngle=mean(angles);
    trimeanAngle=trimean(angles');
    medianAngle=median(angles);
    maxAngle=max(angles);
    
    sa=sort(angles);
    n=numel(angles);
    
    nn=round(n/4);
    best25=mean(sa(1:nn));
    worst25=mean(sa((n-nn+1):n));
    
    average=geomean([meanAngle, medianAngle, trimeanAngle, best25, worst25]);
    
end
