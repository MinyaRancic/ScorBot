function ScorDispError(errStruct)
% SCORDISPERROR display a formatted message from a ScorBot error structure
% to the command prompt.
%
%   See also ScorParseErrorCode ScorIsReady
%
%   (c) M. Kutzer, 28Aug2015, USNA

if errStruct.Code ~= 0
    beep;
    fprintf(2,'\nScorBot Message [%d]\n->%s\n\t %s\n',...
        errStruct.Code,errStruct.Message,errStruct.Mitigation);
end