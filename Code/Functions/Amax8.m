function out = Amax8(hf,f,BPFIest,BPFOest)

hf = hf(f<=1000,:);
[max_values, max_indices] = maxk(hf, 4);
max_indices = f(max_indices); 

out=[];
out.Summation = sum(max_values.^2)';
out.max_indicesBPFI_1 = max_indices(1,:)'/BPFIest;
out.max_indicesBPFI_2 = max_indices(2,:)'/BPFIest;
out.max_indicesBPFI_3 = max_indices(3,:)'/BPFIest;
out.max_indicesBPFI_4 = max_indices(4,:)'/BPFIest;
out.max_indicesBPFO_1 = max_indices(1,:)'/BPFOest;
out.max_indicesBPFO_2 = max_indices(2,:)'/BPFOest;
out.max_indicesBPFO_3 = max_indices(3,:)'/BPFOest;
out.max_indicesBPFO_4 = max_indices(4,:)'/BPFOest;
end