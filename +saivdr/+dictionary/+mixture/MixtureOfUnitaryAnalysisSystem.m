classdef MixtureOfUnitaryAnalysisSystem < saivdr.dictionary.AbstAnalysisSystem %#~codegen
    %MIXTUREOFUNITARYANALYSISYSTEM Mixture of unitary analysis system 
    %
    % SVN identifier:
    % $Id: MixtureOfUnitaryAnalysisSystem.m 683 2015-05-29 08:22:13Z sho $
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
    properties (Nontunable)
        UnitaryAnalyzerSet
    end
    
    properties (Access = private)
        nAnalyzers
        normalizationFactor
    end
    
    methods
        
        % Constructor
        function obj = MixtureOfUnitaryAnalysisSystem(varargin)
            setProperties(obj,nargin,varargin{:});
            obj.nAnalyzers = length(obj.UnitaryAnalyzerSet);
            obj.normalizationFactor = 1/sqrt(obj.nAnalyzers);
        end
        
    end
    
    methods (Access = protected)
        
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            
            % Save the child System objects
            for iDic = 1:obj.nAnalyzers
                s.UnitaryAnalyzerSet{iDic} = ...
                    matlab.System.saveObject(obj.UnitaryAnalyzerSet{iDic});
            end
            
            % Save the protected & private properties
            s.nAnalyzers = obj.nAnalyzers;
            s.normalizationFactor = obj.normalizationFactor;
        end
        
        function loadObjectImpl(obj,s,wasLocked)
            % Load protected and private properties
            obj.nAnalyzers = s.nAnalyzers;
            obj.normalizationFactor = s.normalizationFactor;
            
            % Call base class method to load public properties
            loadObjectImpl@matlab.System(obj,s,wasLocked);
            %
            for iDic = 1:obj.nAnalyzers
                obj.UnitaryAnalyzerSet{iDic} = ...
                    matlab.System.loadObject(s.UnitaryAnalyzerSet{iDic});
            end
        end
        
        function [coefs,scales] = stepImpl(obj,srcImg,nLevelSet)
            subCoefs  = cell(1,obj.nAnalyzers);
            subScales = cell(obj.nAnalyzers,1);
            if isscalar(nLevelSet)
                nLevelSet = nLevelSet * ones(1,obj.nAnalyzers);
            end
            for idx = 1:obj.nAnalyzers-1
                subAnalyzer = obj.UnitaryAnalyzerSet{idx};
                [subCoefs{idx}, tmpScales ] = ...
                    step(subAnalyzer,srcImg,nLevelSet(idx));
                subScales{idx} = ...
                    [ tmpScales ; -1 -1 ];
            end
            idx = obj.nAnalyzers;
            subAnalyzer = obj.UnitaryAnalyzerSet{idx};
            [subCoefs{idx}, tmpScales ] = ...
                step(subAnalyzer,srcImg,nLevelSet(idx));
            subScales{idx} = tmpScales;
            coefs  = obj.normalizationFactor * cell2mat(subCoefs);
            scales = cell2mat(subScales);
        end
        
    end

end