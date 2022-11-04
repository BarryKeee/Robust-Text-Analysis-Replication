function HHI_doc1 = HHI_doc1(B, Theta)
    HHI = sum(Theta.^2, 1)';
    HHI_doc1 = HHI(1);
end

