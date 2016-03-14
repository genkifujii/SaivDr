classdef PixelLossSystem < ...
        saivdr.degradation.linearprocess.AbstLinearSystem %#codegen
    %PIXELLOSSSYSTEM Pixel-loss process
    %   
    % SVN identifier:
    % $Id: PixelLossSystem.m 714 2015-07-30 21:44:30Z sho $
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
        LossType    = 'Random';
        %
        Density = 0.5;
        Seed    = 0;
        Mask = [];
    end
    
    properties (Hidden, Transient)
        LossTypeSet = ...
            matlab.system.StringSet({...
            'Random',...
            'Specified'})
    end
    
    properties (Access = protected, Nontunable)
       maskArray 
    end
    
    methods
        % Constractor
        function obj = PixelLossSystem(varargin)
            obj = ...
                obj@saivdr.degradation.linearprocess.AbstLinearSystem(...
                varargin{:});
        end

    end
    
    methods (Access = protected)

        function s = saveObjectImpl(obj)
            s = saveObjectImpl@...
                saivdr.degradation.linearprocess.AbstLinearSystem(obj);
            s.maskArray = obj.maskArray;
        end
        
        function loadObjectImpl(obj, s, wasLocked)
            obj.maskArray = s.maskArray;
            loadObjectImpl@...
                saivdr.degradation.linearprocess.AbstLinearSystem(obj,s,wasLocked);
        end
        
        function flag = isInactiveSubPropertyImpl(obj,propertyName)
            if strcmp(propertyName,'Density') || ...
                    strcmp(propertyName,'Seed')
                flag = ~strcmp(obj.LossType,'Random');            
            elseif strcmp(propertyName,'Mask')
                flag = ~strcmp(obj.LossType,'Specified');
            else
                flag = false;
            end            
        end
        
        function setupImpl(obj,input)
            
            nDim = getOriginalDimension(obj,size(input));
            switch obj.LossType
                case {'Random'}
                    broadcast_id =1;
                    if labindex == broadcast_id
                        rng(obj.Seed,'twister')
                        maskArray_ = rand(nDim(1:2)) > obj.Density;
                        obj.maskArray = labBroadcast(broadcast_id,...
                            maskArray_);
                    else
                        obj.maskArray = labBroadcast(broadcast_id);
                    end
                case {'Specified'}
                    obj.maskArray = obj.Mask;
                    obj.Density = sum(obj.maskArray(:))/numel(obj.maskArray);
                otherwise
                    me = MException('SaivDr:InvalidOption',...
                        'Invalid loss type');
                    throw(me);
            end
            %
            setupImpl@saivdr.degradation.linearprocess. ...
                AbstLinearSystem(obj,input);            
        end
        
        function picture = normalStepImpl(obj,picture)
            nCmps = size(picture,3);
            for iCmp = 1:nCmps
                cmp = picture(:,:,iCmp);
                cmp(obj.maskArray==0)=0;
                picture(:,:,iCmp) = cmp;
            end
        end
        
        function output = adjointStepImpl(obj,input)
            output = normalStepImpl(obj,input);
        end
        
        function originalDim = getOriginalDimension(~,ovservedDim)
            originalDim = ovservedDim;
        end      
        
    end
    
end