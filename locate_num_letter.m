function interested_area = locate_num_letter(im)
row = sum(im,2);
figure(1),plot(row);
xlabel('row number');
ylabel('pixels are white')
grid on 
axis tight

enhance = row > 300;
figure(2);
plot(1:length(row),row);
hold on
plot(enhance*1200);
hold off
xlabel('Row number');
ylabel('pixels are white');
grid on 
axis tight
legend('white count','regions');

startIdx = [1;find(diff(enhance)==1)];
endIdx = [find(diff(enhance)== -1);length(enhance)];
[~,region] = max(endIdx - startIdx);
upperbound = startIdx(region);
lowerbound = endIdx(region);
interested_area = im(upperbound:lowerbound,:);