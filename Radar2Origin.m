%% Script to Rotate Left/Right Radars to Center Radar
% Rebecca Garcia 9/21/2020

%% Constants
% User Input Angles
heading = deg2rad(332.8);  % Heading of Center Radar (Origin) 
Angle0 = deg2rad(15);      % Angle by which Radars are off from center Radar (wrt vertical axis)
AngleRot = (pi/2)-Angle0;  % Angle used for Rotational Radar Movement
%% Pathing for Quat Mat Files
QLeft = 'C:\Users\rag315\Documents\MATLAB\TestData\Left\';
QOrigin = 'C:\Users\rag315\Documents\MATLAB\TestData\Mid\';
QRight = 'C:\Users\rag315\Documents\MATLAB\TestData\Right\';
loop = [string(QLeft);string(QOrigin);string(QRight)];
name = 'radarOrientation.mat';
% Setting Radar.Structure
Left = 'Left'; Origin = 'Origin'; Right = 'Right';
Pos = [string(Left);string(Origin);string(Right)];
n = zeros(3,0);
%% Looping through Each Radar
for i = 1:3
%% Loading Quat Data    
    load(string(loop(i)) + string(name));
    n(i) = length(radarOrientation.data);
    % Assigning QuatData
    for j = 1:n(i)
        Radar.(Pos{i}).t(j,:) = radarOrientation.data(j).time;
        Radar.(Pos{i}).qw(j,:) = radarOrientation.data(j).qw;
        Radar.(Pos{i}).qx(j,:) = radarOrientation.data(j).qx;
        Radar.(Pos{i}).qy(j,:) = radarOrientation.data(j).qy;
        Radar.(Pos{i}).qz(j,:) = radarOrientation.data(j).qz;
    end
    clear radarOrientation

%% From IMU to Radar Orientation (Ref 2 Std Orientation Frames)
Radar.(Pos{i}) = Ref2Std(Radar.(Pos{i}));

%% Building Rotation Matrices for Std to Final Frame  

    for j = 1:n(i)
       % Temp Variables
        dummy.qw = Radar.(Pos{i}).qw(j,:); dummy.qx = Radar.(Pos{i}).qx(j,:);
        dummy.qy = Radar.(Pos{i}).qy(j,:); dummy.qz = Radar.(Pos{i}).qz(j,:);
        
% Pulling Yaw, Pitch, & Roll Out of Quat Data
[Radar.(Pos{i}).yaw(j,1),Radar.(Pos{i}).pitch(j,1),Radar.(Pos{i}).roll(j,1)] = quaternion2LeftHandedYPR(dummy);    
    end
end
%% Replacing Yaw with Heading
Radar.Left.yaw(:,1) = heading + AngleRot;
Radar.Origin.yaw(:,1) = heading;   
Radar.Right.yaw(:,1) = heading - AngleRot;
%% Building Rotation Matrices for Side Radars to Radar Origin (Center)
RyL = RyLeftHanded(-AngleRot);  % Left Rotation Matrix
RyR = RyLeftHanded(AngleRot); % Right Rotation Matrix
%% Rotating to Final Frame (NED)

% Coordinate Transformation Matrix
Tstd2ned = [0 0 1;-1 0 0;0 -1 0];
% Position Vector of Object wrt to Radar Frame
% neglecting distance between radar & AC GPS Unit
% Also neglecting translational distance between radars
xyz = [1;1;1]; % xyz position Vector of Object
Bu
% Left
for j = 1:n(1)
Radar.Left.R = RyLeftHanded(Radar.Left.yaw(j))*RxLeftHanded(Radar.Left.pitch(j))*RzLeftHanded(Radar.Left.roll(j));
Radar.Left.NED(j,:) = (Tstd2ned*Radar.Left.R*RyL*xyz(:,1))';
end
% Origin
for j = 1:n(2)
Radar.Origin.R = RyLeftHanded(Radar.Origin.yaw(j))*RxLeftHanded(Radar.Origin.pitch(j))*RzLeftHanded(Radar.Origin.roll(j));
Radar.Origin.NED(j,:) = (Tstd2ned*Radar.Origin.R*xyz(:,1))';
end
% Right
for j = 1:n(3)
Radar.Right.R = RyLeftHanded(Radar.Right.yaw(j))*RxLeftHanded(Radar.Right.pitch(j))*RzLeftHanded(Radar.Right.roll(j));
Radar.Right.NED(j,:) = (Tstd2ned*Radar.Right.R*RyR*xyz(:,1))';
end
%% Calculating how off the Left & Right coordinates are from the Origin
for j = 1:n(1)
Radar.DiffLO(j,:) = abs(Radar.Left.NED(j,:)) - abs(Radar.Origin.NED(j,:));
end
for j = 1:n(3)
Radar.DiffRO(j,:) = abs(Radar.Right.NED(j,:)) - abs(Radar.Origin.NED(j,:));
end
%% Functions
% Converts an IMU Quat from Ref to Std Frame
function qStd = Ref2Std(qRef)
    % Building Rotation Vector
    qRef2Std.qw = 0;
    qRef2Std.qx = 0;
    qRef2Std.qy = 1/(sqrt(2));
    qRef2Std.qz = 1/(sqrt(2));
    % Rotating
    qStd = quatMultiply(qRef, quatInverse(qRef2Std));
end

function qinv = quatInverse(q) % reverse rotation
qinv.qw =  q.qw;
qinv.qx = -q.qx;
qinv.qy = -q.qy;
qinv.qz = -q.qz;
end

function q = quatMultiply(q1,q2) % Quaternion multiplcations 
q.qw = q1.qw*q2.qw - q1.qx*q2.qx - q1.qy*q2.qy - q1.qz*q2.qz;
q.qx = q1.qw*q2.qx + q1.qx*q2.qw + q1.qy*q2.qz - q1.qz*q2.qy;
q.qy = q1.qw*q2.qy - q1.qx*q2.qz + q1.qy*q2.qw + q1.qz*q2.qx;
q.qz = q1.qw*q2.qz + q1.qx*q2.qy - q1.qy*q2.qx + q1.qz*q2.qw;
end

% Left Hand Rotation Matrices
function R = RxLeftHanded(t)    
R = [1, 0, 0; 0, cos(t), sin(t); 0, -sin(t), cos(t)];
end
function R = RyLeftHanded(t)
R = [cos(t), 0, -sin(t); 0, 1, 0; sin(t), 0, cos(t)];
end
function R = RzLeftHanded(t)
R = [cos(t), sin(t), 0; -sin(t), cos(t), 0; 0, 0, 1];
end

function R = Rotq(q)    % EchoDyne Rotation Matrix for Quats
R = ...
[q.qw^2 + q.qx^2 - q.qy^2 - q.qz^2, 2*(q.qx*q.qy - q.qw*q.qz), 2*(q.qx*q.qz + q.qw*q.qy);
2*(q.qx*q.qy + q.qw*q.qz), q.qw^2 - q.qx^2 + q.qy^2 - q.qz^2, 2*(q.qy*q.qz - q.qw*q.qx);
2*(q.qx*q.qz - q.qw*q.qy), 2*(q.qy*q.qz + q.qw*q.qx), q.qw^2 - q.qx^2 - q.qy^2 + q.qz^2];
end

function [yaw, pitch, roll] = quaternion2LeftHandedYPR(q)
R = Rotq(q);
yaw = -atan2(-R(1,2), R(2,2));
pitch = atan2(R(3,2), sqrt(1-R(3,2)^2));
roll = -atan2(-R(3,1), R(3,3));
end
