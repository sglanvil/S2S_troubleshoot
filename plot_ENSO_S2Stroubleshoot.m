% July 18, 2022
% run this on laptop, not glade

clear; clc; close all;

% --------------------------------------------- use this to get the lon/lat
% file is located here
addpath /Users/sglanvil/Documents/S2S_analysis/Ocean
fil='SST1_g210.G_JRA.v14.gx1v7.01.pop.h.ALL.nc';
lon=ncread(fil,'TLONG');
lat=ncread(fil,'TLAT');
lon=lon(:,1);
lat=lat(1,:)';

% ------------------------------------ JRA55do-FO, just first of month data
% originally made on glade
% find . -name "*.pop.r.*01-00000.nc" -type f -exec cp {} /glade/scratch/ssfcst/sglanvil/ocean/ \;
% ncecat -O -v TEMP_CUR -d k,0 g210*nc out.nc
fil='out.nc';
t1=datetime('1/Jan/1999');
t2=datetime('1/Jun/2022');
time=t1:t2;
time=time(day(time)==1);
sst=squeeze(ncread(fil,'TEMP_CUR'));
enso=squeeze(nanmean(nanmean(sst(lon>=190 & lon<=240,abs(lat)<=5,:),1),2));

% ------------------------------------------------------------ observations
% https://www.metoffice.gov.uk/hadobs/hadisst/data/download.html (HadISST_sst.nc.gz)
fil='/Users/sglanvil/Documents/CCR/meehl/data/HadISST_sst_197001-202206.nc';
lon0=ncread(fil,'longitude');
lat0=ncread(fil,'latitude');
lon0(lon0<0)=lon0(lon0<0)+360;
raw=ncread(fil,'sst');
raw(raw<0)=NaN; % --- remove negative values (probably ice flags)
[lon0sorted,inx]=sort(lon0); % --- deal with some neg lon issues
raw=raw(inx,:,:); % --- deal with some neg lon issues
lon0=lon0(inx); % --- deal with some neg lon issues
t1=datetime('15/Jan/1870');
t2=datetime('15/Jun/2022');
timeOBS=t1:t2;
timeOBS=timeOBS(day(timeOBS)==15); % datetime monthly option
ensoOBS=squeeze(nanmean(nanmean(raw(lon0>=190 & lon0<=240,abs(lat0)<=5,:),1),2));

% ------------------------------------------------------------- plot figure
printName='ENSO_S2Stroubleshoot';
subplot(2,1,1);
    hold on; grid on; box on;
    plot(time,enso,'b','linewidth',2);
    plot(timeOBS,ensoOBS,'k','linewidth',2);
    legend('JRA55do-FO','HadISST','location','northwest');
    ylabel('\bfENSO Index (\circC)');
    xlim(datetime([1999 2022],[1 12],[1 31])) % how to handle axis for datetime
    xticks(datetime('01-Jan-2000') : calyears(2) : datetime('31-Dec-2022'))
    xtickangle(45);
    set(gca,'fontsize',13);
print(printName,'-r300','-dpng');

