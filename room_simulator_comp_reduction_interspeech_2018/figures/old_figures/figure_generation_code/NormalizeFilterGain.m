%
% Programmed by Chanwoo Kim
%
% Normalize the Gain of the filter

function [aad_H] = NormalizeGain(aad_H)
	[M, N] = size(aad_H);


	adWeight = sqrt(sum(abs(aad_H .* aad_H)));

	adWeight = adWeight / adWeight(1);


	for i = 1 : N

		aad_H(:, i) = aad_H(:, i) / adWeight(i); 

	end

%	plot(linspace(0, 8000, length(aad_H)), 20 * log10(abs(aad_H)));




end
