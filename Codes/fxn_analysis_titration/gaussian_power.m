close all
x=linspace(-3,3,1000);
figure,hold on
p_all = -.1:.05:.1;
y2 = normpdf(x); plot(x,y2,'-','LineWidth',2)
for p= p_all
    y1 = normpdf(x).^p;
    plot(x,y1,'--')
end
