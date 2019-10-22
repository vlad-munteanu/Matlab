close all;
%%
figure 
hold on
plot (p1)
plot (p2)
plot(p3)
plot([1 length(p1)],[Thresh Thresh],'k')
legend('left sensor','center sensor','right sensor')
grid
hold off
%%
figure
hold on
plot(normalize(lms),'b')
plot(normalize(rms),'r')
plot(normalize(p1),'k')
legend('left speed','right speed','left sensor')
hold off
%%
figure
hold on
plot(lms-rms,'b')
%plot(normalize(rms),'r')
legend('left speed','right speed')
hold off
%%
figure
hold on
plot(p1,'b')
plot(p3,'r')
plot([1 length(p1)],[Thresh Thresh],'--k')
hold off
legend('left sensor','right sensor')
%%
correlate