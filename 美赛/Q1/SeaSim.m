clear all;
close all;

nhFig = 0; % Figure Number;
SeaRegLx = 40e+3; % Sea region length, unit: m
SeaRegLy = 40e+3; % Sea region length, unit: m
% ����Ƶ�����������ȷ���������ڼ��������㼣���֮��
% ��������ʱ������Ĳ�������Ŀ(ͨ���ռ�Ƶ�׵Ŀ�ȼ�����ʱ���������������������)��ʵ��Ƶ�����.
% ���ں����׶��ԣ����׿���Ƿǳ���ģ�����䲨�׿��һ����ָ�����˴󲿷�����(����˵��Ҫ����������)�Ĳ���ȫ�׿��
% �����������ȸ��ݲ��׺���������Ҫ�������ֶ�Ӧ���׿��
xSampleStep = 50; % unit: m
ySampleStep = 50;
xNs = round( SeaRegLx / xSampleStep );
yNs = round( SeaRegLy / ySampleStep );

x = linspace( -SeaRegLx / 2, SeaRegLx / 2, xNs );
y = linspace( -SeaRegLy/ 2, SeaRegLy / 2, yNs );

% �����׷���
g = 9.8; % gravity acceleration
% swell wave spectrum parameter
SwellWaveLength = 1000; % ӿ�˲���
KswellWavePeak = 2 * pi / SwellWaveLength;
SwellAngled=0;
SwellAngle = SwellAngled/ 180 * pi; % ӿ����۲���н�
KxswellWavePeak = KswellWavePeak * cos( SwellAngle );
KyswellWavePeak = KswellWavePeak * sin( SwellAngle );
SigmaKx = 2.5e-3; % ӿ���׿��
SigmaKy = 2.5e-3;
SigmaHSwell = 2; %ӿ�˲���
% wind wave spectrum parameter
WindAngle = 45 / 180 * pi; % ������۲���н�
U10 = 12; % 10�׸ߴ�������� % 5m/s, 10m/s, 15m/s �ķ����׿�ȷֱ�Ϊ 1.5, 0.4, 0.15.��Ӧ�����ռ�������Ϊ2m, 10m, 20m
KwindPeak = g / ( 1.2 * U10 )^2;
% sea wave spectrum parameter
NxSeaWave = xNs; % Ƶ��������������㸵��Ҷ�任
NySeaWave = yNs; 
KxSeaWave = 2 * pi / SeaRegLx * ( -xNs / 2 : 1 : xNs / 2 - 1 );
KySeaWave = 2 * pi / SeaRegLy * ( -yNs / 2 : 1 : yNs / 2 - 1 );
KxSeaWaveTicks = KxSeaWave;
KySeaWaveTicks = KySeaWave;
KxSeaWave = ( KxSeaWave == 0 ) * ( max( KxSeaWave ) * 1e-16 ) + KxSeaWave; % avoid divided by 0
KySeaWave = ( KySeaWave == 0 ) * ( max( KySeaWave ) * 1e-16 ) + KySeaWave; % avoid divided by 0

% swell wave spectrum
SpectrumSwell = zeros( NySeaWave, NxSeaWave );
Temp1 = ones( NySeaWave, 1 ) * ( KxSeaWave - KxswellWavePeak ) / SigmaKx;
Temp2 = ( KySeaWave - KyswellWavePeak )' / SigmaKy * ones( 1, NxSeaWave );
SpectrumSwell = SigmaHSwell^2 / 2 / pi / SigmaKx / SigmaKy * exp( -0.5 * ( Temp1.^2 + Temp2.^2 ) );
clear Temp1;
clear Temp2;
figure;
colormap(gray(256));
image( KxSeaWave, KySeaWave, 256 - 255 / ( max( max( abs( SpectrumSwell ) ) ) - min( min ( abs( SpectrumSwell ) ) ) ) * ( abs( SpectrumSwell ) - min( min ( abs( SpectrumSwell ) ) ) ) );
axis('xy');
xlabel( 'kx:X������');
ylabel( 'ky:Y������');
title( 'ӿ����');

KxSeaWaveMatrix = ones( NySeaWave, 1 ) * KxSeaWave;
KySeaWaveMatrix = KySeaWave' * ones( 1, NxSeaWave );
KSeaWaveTemp1 = ( sqrt( KxSeaWaveMatrix.^2 + KySeaWaveMatrix.^2 ) );
Fwk1 = exp( - 1.22 * ( sqrt( KSeaWaveTemp1 ./ KwindPeak ) -1 ).^2  );
HKKpx1 = 1.24 * ( ( KSeaWaveTemp1 / KwindPeak < 0.31 ) & ( KSeaWaveTemp1 / KwindPeak >= 0 ) );
HKKpx2 = 2.61 * ( ( KSeaWaveTemp1 / KwindPeak ).^0.65 ) .* ( ( KSeaWaveTemp1 / KwindPeak < 0.9 ) & ( KSeaWaveTemp1 / KwindPeak >= 0.31 ) );
HKKpx3 = 2.28 * ( ( KSeaWaveTemp1 / KwindPeak ).^( -0.65 ) ) .* ( KSeaWaveTemp1 / KwindPeak >= 0.9 );
HKKp1 = HKKpx1 + HKKpx2 + HKKpx3;
Temp1x = 1.62 * 1e-3 * U10 / ( g^0.5 ) ./ ( KSeaWaveTemp1 ).^3.5;
Temp2x = exp( -( KwindPeak ./ KSeaWaveTemp1 ).^2 ) .* ( 1.7 .^ Fwk1 );
Temp3x = ( HKKp1 .* ( sech( ( HKKp1 .* ( atan( ( KySeaWaveMatrix ./ KxSeaWaveMatrix ) ) - WindAngle ) ) ) ).^2 );
% SpectrumWind1 = ( Temp1x .* Temp2x .* Temp3x )';
% SpectrumWind = SpectrumWind1';
SpectrumWind = Temp1x .* Temp2x .* Temp3x;
clear KSeaWaveTemp1 Fwk1 HKKpx1 HKKpx2 HKKpx3 HKKp1 Temp1x Temp2x Temp3x;
figure;
contour( KxSeaWave, KySeaWave, abs( SpectrumWind ) );
axis('xy');
xlabel( 'kx:X������');
ylabel( 'ky:Y������');
title( '������');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%ȫ�ף� ӿ����+������
SpectrumSea = SpectrumSwell + SpectrumWind;
% ���ڲ�������������ʵ�����ף��������������
% ������ֵΪ1�������ֲ��;�����λ�ֲ�
rand('state',sum(100*clock));
PhiSeaRand = 2 * pi * rand( NySeaWave, NxSeaWave );
AmRayleigh = raylrnd( 1, NySeaWave, NxSeaWave );
SpectrumSeaReal = 2 * pi .* sqrt( 2 * xNs * yNs / xSampleStep / ySampleStep .* SpectrumSea ) .* AmRayleigh .* exp( j * PhiSeaRand );
% ����߶�
wh = zeros( yNs, xNs );   % Wave Height, heigth depart from mean sea level
% wh = real( ( fftshift( fft( ( fftshift( fftshift( fft( fftshift( SpectrumSeaReal ), yNs ) ) ) )', xNs ) ) )' ) / NySeaWave / NxSeaWave;
wh = ( fftshift( fft( ( fftshift( fftshift( fft( fftshift( SpectrumSeaReal ), yNs ) ) ) )', xNs ) ) )' / NySeaWave / NxSeaWave;
Varwh = sqrt( sum( sum( ( real( wh ) - mean( mean( real( wh ) ) ) ).^2 ) ) / xNs / yNs );
wh = wh / Varwh * ( SigmaHSwell / 2 );% ��ӿ�˲��߽��й�һ��

hFig = figure;
colormap(gray(256));
image( x, y, 256 - 255 / ( max( max( real( wh ) ) ) - min( min ( real( wh ) ) ) ) * ( real( wh ) - min( min ( real( wh ) ) ) ) );
% title('ӿ�˷��� 45 ��, ���� ', SwellWaveLength)
title(['ӿ�˷���: ',num2str(SwellAngled),' ��',',  ����: ',num2str(SwellWaveLength),' m',',  ӿ�˲���: ',num2str(SigmaHSwell),' m'])
xlabel( ['X ( unit: ', num2str(xSampleStep),' m)']);
ylabel( ['Y ( unit: ', num2str(ySampleStep),' m)']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ����ɢ��ϵ������
Sigma = zeros( xNs, yNs );
ms2 = 3.66 * 1e-3 * U10;
MR02 = 1;
% �ɺ��沨�׼���ÿ���x,y�����¶�
xSlope = ones( yNs, 1 ) * real( ( fftshift( fft( fftshift( ( j * KxSeaWaveMatrix( 1, : ) .* SpectrumSeaReal( 1, : ) )' ), xNs ) ) )' ) / NxSeaWave;
ySlope = real( ( fftshift( fft( fftshift( ( j * KySeaWaveMatrix( :, 1 ) .* SpectrumSeaReal( :, 1 ) ) ), yNs ) ) ) ) / NySeaWave * ones( 1, xNs );
% ��������Ǿ���,���б�ʾ
IncidentAngleLocal = xSlope.^2 + ySlope.^2;
Sigma = MR02 / ms2 .* exp( -IncidentAngleLocal / ms2 );
% Sigma0Coef = sqrt( Sigma );
hFig = figure;
colormap(gray(256));
image( x, y, 256 - 255 / ( max( max( abs( Sigma ) ) ) - min( min ( abs( Sigma ) ) ) ) * ( abs( Sigma ) - min( min ( abs( Sigma ) ) ) ) );
axis('xy');
xlabel( 'x0: along track');
ylabel( 'y0: cross track');
title( 'Scattering Coffecient Distribution');

fid=fopen('sea_top_wl1000_wh50m.dat','w')
fprintf(fid,'%10.5f\n',real(wh));
status=fclose(fid);

fid=fopen('sea_top_wl1000_wh50m.dat','r');
sea_dem=fscanf(fid,'%g',[800,800]);
fclose(fid);
%image( x, y, 256 - 255 / ( max( max( real( sea_dem ) ) ) - min( min ( real( sea_dem ) ) ) ) * ( real( sea_dem ) - min( min ( real( sea_dem ) ) ) ) );
% 
 mesh(sea_dem)
 colorbar
% view(0,90)
%colormap(gray)
