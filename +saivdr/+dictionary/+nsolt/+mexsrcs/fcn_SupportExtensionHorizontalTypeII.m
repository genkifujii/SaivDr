function arrayCoefs = fcn_SupportExtensionHorizontalTypeII( ...
    arrayCoefs, nRows, nCols, paramMtx1,paramMtx2,isPeriodicExt) %#codegen
%FCN_SUPPORTEXTENSIONHORIZONTALTYPEII
%
% SVN identifier:
% $Id: fcn_SupportExtensionHorizontalTypeII.m 683 2015-05-29 08:22:13Z sho $
%
% Requirements: MATLAB R2013b
%
% Copyright (c) 2014-2015, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
% LinedIn: http://www.linkedin.com/pub/shogo-muramatsu/4b/b08/627
%
persistent h;
if isempty(h)
    h = saivdr.dictionary.nsolt.mexsrcs.SupportExtensionHorizontalTypeII();
end
arrayCoefs = step(h,arrayCoefs,nRows,nCols,paramMtx1,paramMtx2,isPeriodicExt);
end