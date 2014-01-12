function [val, varargout] = diffusion_distance(im1, im2, sig, dim, threshold, pad_type)
% DIFFUSION_DISTANCE calculate the diffusion distance between matrices
% dist = diffusion_distance(im1, im2, [sig, dim], threshold, pad_type]) 
% [dist, iter] = diffusion_distance(im1, im2) compute the diffusion distance
% between im1 and im2 (histograms). 
% 
% Optionally returns the number of iterations. This number will be limited by
% the size of the histograms, and the threshold value, which can be set
% manually, or will take the value 1e-4.
% 
% The padding method used by the filtering stages can be set using the 4th
% argument, and defaults to circular. For available options, see help imfilter. 
% 
% Reference:
% Diffusion Distance for Histogram Comparison
% Ling and Okada, Proc. CVPR, 2006
%
% Matt Foster <ee1mpf@bath.ac.uk>
% Copyright (c) 2008, Matthew Foster
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.


error(nargchk(2, 6, nargin, 'struct'))

if nargin < 4
  sig = 0.5;
  dim = 3;
end

if nargin == 3
  error('Strange number of arguments.');
end

if nargin < 5
  threshold = 1e-4;
end

if nargin < 6
  pad_type = 'circular'; % see help imfilter
end

kernel = fspecial('gaussian', dim, sig);

dist = im1 - im2;
val = sum(abs(dist(:)));

level_val = 1000; % This need initialising to larger than the threshold.
iter = 0;

while level_val > threshold && all(size(dist) >= size(kernel))
  iter = iter + 1;
  % filter, and downsample
  dist = imresize(imfilter(dist, kernel, pad_type), 0.5);
  level_val = sum(abs(dist(:)));

  val = val + level_val;
end

if nargout >= 2
  varargout{1} = iter;
end

