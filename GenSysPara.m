function [ sysPara] = GenSysPara()
% /*!
%  *  @brief     This function generate the system parameters.
%  *  @details   . 
%  *  @param[out] sysPara struct, which has the following field:
%           see code comments for details.
%  *  @param[in] Null
%  *  @pre       .
%  *  @bug       Null
%  *  @warning   Null
%  *  @author    Collus Wang
%  *  @version   1.0
%  *  @date      2017.05.25.
%  *  @copyright Collus Wang all rights reserved.
%  * @remark   { revision history: V1.0, 2017.05.25. Collus Wang,  first draft }
%  * @remark   { revision history: V1.1, 2017.05.25. Collus Wang,  support multiple targets and interference. use the first NumTarget/NumInterference as valid input. }
%  * @remark   { revision history: V1.1, 2017.05.25. Collus Wang, 1.steering vector calculation can include element response. StvIncludeElementResponse; 2. add DiagonalLoadingFactor for mvdr}
%  */

%% system parameter settings
% general parameter
sysPara.SampleRate = 18.432e6;    % double scaler, sample rate in SPS
sysPara.Duration = 1e-3;          % double scaler, simulation duration

% Antenna parameter
sysPara.AntennaType = 'Custom';  % string. Antenna type. valid value = {'Custom', };
sysPara.AntennaPatternFileName = '.\AntennaPattern\C_5G7_Gen3_Antenna_Filled.csv'; % string. csv antenna pattern file exported from HFSS.
sysPara.FreqCenter = 5725e6;    % double scaler. Center frequency, Unit in Hz.  e.g. 5725e6, 34e9
sysPara.FreqSpan = 200e6;       % double scaler. Frequency span, unit in Hz.

% Array parameter
sysPara.ArrayType = 'Conformal';      % string. Array type. valid value = {'Conformal', 'UCA'};
sysPara.NumElements = 24;       % interger scaler. number of antenna elements
sysPara.NumChannel = 4;         % interger scaler. number of used channels
sysPara.Radius = 0.162;         % double scaler. radius of UCA array, in meter. e.g. 3rd Gen = 0.162;
sysPara.StvIncludeElementResponse = false; % boolen scaler. Include individual element response in the calculation of steering vector
                                          % If this property is true, the steering vector includes the individual element responses.
                                          % If this property is false, the computation of the steering vector assumes the elements are isotropic.

% Target parameter
sysPara.TargetSigType = 'QPSK';     % string. target singal type. valid value = {'QPSK', '16QAM', '64QAM'}
sysPara.NumTarget = 1;              % interger scaler. number of target
sysPara.TargetAngle = [[-10; 0], [+10;0]];      % double 2xN matrix. incoming wave direction in degree, [azimuth; elevation]. Each column represents one target.
                                                % The azimuth angle must be between �C180 and 180 degrees, and the elevation angle must be between �C90 and 90 degrees.
                                                % N<=NumTarget is the number of targets. if N < NumTarget, use the first NumTarget columns as targets. 
sysPara.TargetPower = [0; 0];                % double vector. target relative power above 1W in dB.
sysPara.SymbolRate = sysPara.SampleRate;      % double scaler. symbol rate

% Interfence parameter
sysPara.SwitchInterence = true;    % boolen scaler. true = enable interference; false = disable interference.
sysPara.InterferenceType = 'Sine';  % string. interferece type, valid value = {'Sine'}
sysPara.NumInterference = 2;        % interger scaler. number of interference
sysPara.InterferenceFreq = [10e3; 20e3];    % Nx1 double column vector. interfence frequency at baseband, in Hz. N is the number of interference.
                                            % N<=NumInterference is the number of interferences. if N < NumInterference, use the first NumInterference columns. 
sysPara.SIR = [-10; -3];                      % Nx1 double column vector. SIR in dB. each row represents one interference SIR. N is the number of interference.
                                            % N<=NumInterference is the number of interferences. if N < NumInterference, use the first NumInterference columns. 
sysPara.InterferenceAngle = [[-25; 0], [+25;0]];    % double 2xNumInterference matrix. intereference direction in degree, [azimuth; elevation]. 
                                                    % The azimuth angle must be between �C180 and 180 degrees, and the elevation angle must be between �C90 and 90 degrees.
                                                    % N<=NumInterference is the number of interferences. if N < NumInterference, use the first NumInterference columns. 

% noise parameter
sysPara.SwitchAWGN = true;          % boolen scaler. switch flag of AWGN.  true = add noise; false = not add noise.
sysPara.SNR = 30;                   % double scaler. SNR, in dB, in-channel SNR. Valid only when SwitchAWGN = true.

% beamformer
sysPara.BeamformerType = 'MMSE';        % string. beamformer type. valid value = {'MVDR', 'LCMV', 'MRC', 'MMSE'}
% beamformer para.
sysPara.LcmvPara.AngleToleranceAZ = 15; % double scaler. The angle (in degree) tolerance for LCVM constraints. The desired azimuth angle is set to [TargetAngle, TargetAngle-AngleToleranceAZ, TargetAngle+AngleToleranceAZ] with response of [1;1;1]
sysPara.MvdrPara.DiagonalLoadingFactor = 0; % double scaler. Specify the diagonal loading factor as a positive scalar. Diagonal loading is a technique used to achieve robust beamforming performance, especially when the sample support is small.

% WeightsNormalization
sysPara.WeightsNormalization = 'Bypass';% string. valid value = {'Distortionless', 'Preserve power', 'MinQuantizationError', 'Bypass'}. Approach for normalizing beamformer weights. 
                                        % If you set this property value to 'Distortionless', the gain in the beamforming direction is 0 dB. 
                                        % If you set this property value to 'Preserve power', the norm of the weights is unity.
                                        % If you set this property value to 'MinQuantizationError', the weight are normalized by max(abs(weight)) so that quantization error is minimized.
                                        % If you set this property value to 'Bypass', the weight normalization process is skipped.
% NumWeightsQuantizationBits
sysPara.NumWeightsQuantizationBits = 0; % 1x1 integer. Number of phase shifter quantization bits. The number of bits used to quantize beamformer weights. 
                                        % Specify the number of bits as a non-negative integer. A value of zero indicates that no quantization is performed.

% DOA estimation Parameters
sysPara.DoaEstimator = 'ToolboxMusicEstimator2D';     % string. DOA estimator type. valid value = {'ToolboxMusicEstimator2D'}
sysPara.AzimuthScanAngles = [-30:0.5:30].';           % double vector. Azimuth scan angles, Specify the azimuth scan angles (in degrees) as a real vector. 
                                                      % The angles must be between �C180 and 180, inclusive. You must specify the angles in ascending order.
sysPara.ElevationScanAngles = 0;                    % double vector. Elevation scan angles. Specify the elevation scan angles (in degrees) as a real vector or scalar. 
                                                    % The angles must be within [�C90 90]. You must specify the angles in an ascending order.

% Flags
sysPara.GlobalDebugPlot = ~false;     % false = close mudule debug plot information; true = debug plot information depends on each module.

%% check input
% check Target number consistency
if size(sysPara.TargetAngle,1) ~=2
    error('TargetAngle should be colum vectors for each target.')
end
if size(sysPara.TargetAngle, 2) < sysPara.NumTarget
    error('TargetAngle size < NumTarget!');
end
if length(sysPara.TargetPower) < sysPara.NumTarget
    error('TargetPower length < NumTarget!');
end

% check interference number consistency
if size(sysPara.InterferenceAngle,1) ~=2
    error('InterferenceAngle should be colum vectors for each interference.')
end
if size(sysPara.InterferenceAngle, 2) < sysPara.NumInterference
    error('InterferenceAngle size < NumInterference!');
end
if length(sysPara.SIR) < sysPara.NumInterference
    error('SIR length < NumInterference!');
end
if length(sysPara.InterferenceFreq) < sysPara.NumInterference
    error('InterferenceFreq length < NumInterference!');
end

% Vectors are all in column vector style
sysPara.TargetPower = ColumnVectorize(sysPara.TargetPower);
sysPara.SIR = ColumnVectorize(sysPara.SIR);
sysPara.InterferenceFreq = ColumnVectorize(sysPara.InterferenceFreq);
sysPara.AzimuthScanAngles = ColumnVectorize(sysPara.AzimuthScanAngles);
sysPara.ElevationScanAngles = ColumnVectorize(sysPara.ElevationScanAngles);

%% generated parameters
sysPara.FrequencyRange = [sysPara.FreqCenter-sysPara.FreqSpan/2; sysPara.FreqCenter+sysPara.FreqSpan/2];  % double 2x1 vector. frequency range of Antenna Elements
sysPara.LenWaveform = round(sysPara.SampleRate*sysPara.Duration);       % interger scaler. number of samples for the simulation.

% ignore redundant inputs for the convenience of further processing 
if ~sysPara.SwitchInterence, sysPara.NumInterference = 0; end
sysPara.TargetAngle = sysPara.TargetAngle(:,1:sysPara.NumTarget);
sysPara.InterferenceFreq = sysPara.InterferenceFreq(1:sysPara.NumInterference);
sysPara.SIR = sysPara.SIR(1:sysPara.NumInterference);
sysPara.InterferenceAngle = sysPara.InterferenceAngle(:,1:sysPara.NumInterference);

% sort azimuth angles in ascending order
[~,idxTmp] = sort(sysPara.TargetAngle(1,:), 'ascend');
sysPara.TargetAngle = sysPara.TargetAngle(:,idxTmp);
sysPara.TargetPower = sysPara.TargetPower(idxTmp);

[~,idxTmp] = sort(sysPara.InterferenceAngle(1,:), 'ascend');
sysPara.InterferenceAngle = sysPara.InterferenceAngle(:,idxTmp);
sysPara.SIR = sysPara.SIR(idxTmp);
sysPara.InterferenceFreq = sysPara.InterferenceFreq(idxTmp);

end

function columnVector = ColumnVectorize(vector)
% convert row vector to column vector
if ~isvector(vector)
    error('input should be a vector.')
else
    if isrow(vector)
        columnVector = vector.';
    else
        columnVector = vector;
    end
end
end