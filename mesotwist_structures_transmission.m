clf
incoming_pol_light=[1;0];
no=1.5; %Can be any number, does not affect the output
ne=no+0.220571429; % Measured by Anna
%ne=no+0.22; %To be adjusted

%OPTIMERA FÖR 2.1 um

%lambdas=[450,589]*1e-9; %Anna's wavelengths
lambdas=[500,600]*1e-9;
%thicknesses=[3.5,3.5,3.5,3.5]*1e-6; %Measured by Anna
thicknesses=[3.5,3.5,3.5,3.5,3.5,3.5]*1e-6; %To be adjusted
%thicknesses=[0.8,1.2,1.6,2,2.4,2.8,3.2,3.6,4]*1e-6;
colors=['b','c','g','y','r','m'];

%twists=-mid_twist*[linspace(0,1,500),linspace(1,0,500);
%    linspace(0,-0.2,100),linspace(-0.2,0.8,500),linspace(0.8,0,400);
%    linspace(0,-0.4,200),linspace(-0.4,0.6,500),linspace(0.6,0,300);
%    linspace(0,-0.6,300),linspace(-0.6,0.4,500),linspace(0.4,0,200);
%    linspace(0,-0.8,400),linspace(-0.8,0.2,500),linspace(0.2,0,100);
%    linspace(0,-1,500),linspace(-1,0,500)];
        
outputs=zeros(20,100);

for m=1:6

    for i=1:2
        subplot(2,1,i)
        hold on
    
        thickness=thicknesses(m);
        dz=thickness/1000;
        opt_twist=0.2e6;
        %mid_twist=thickness/4.7e-6*0.5; %What we used for the paper
        mid_twist=thickness/4.7e-6*0.75;
        lambda=lambdas(i);

        twists=-mid_twist*[linspace(0,1,500),linspace(1,0,500);
            linspace(0,-0.2,100),linspace(-0.2,0.8,500),linspace(0.8,0,400);
            linspace(0,-0.4,200),linspace(-0.4,0.6,500),linspace(0.6,0,300);
            linspace(0,-0.6,300),linspace(-0.6,0.4,500),linspace(0.4,0,200);
            linspace(0,-0.8,400),linspace(-0.8,0.2,500),linspace(0.2,0,100);
            linspace(0,-1,500),linspace(-1,0,500)];
        twist=twists(m,:);
        
        pol_angles=linspace(0,pi);
        
        output=zeros(1,100);
        
        %twist=linspace(0,2*pi,1000); %linear
        %twist=-mid_twist*[linspace(0,1,500),linspace(1,0,500)]; %axis angle
        %twist=-mid_twist*[linspace(0,0.5,250),linspace(0.5,-0.5,500),linspace(-0.5,0,250)]; %axis angle
        %twist=mid_twist*sin(linspace(0*pi,1*pi,1000));

        % First order mesotwist with offset
      %  offset=0.01; %a
      %  maxtwist=opt_twist*thickness/2-offset/2; %b
      %  twist=[linspace(0,-maxtwist,1000*(1/2-offset/(2*opt_twist*thickness))),linspace(-maxtwist,offset,1000*(1/2+offset/(2*opt_twist*thickness))+1)];

        % Second order mesotwist

        for k=1:100
            pol_angle=pol_angles(k);
            incoming_pol_light=[1;0];
            for j=1:1000
                phi=twist(j);
                d1=2*pi*dz/lambda*no;
                d2=2*pi*dz/lambda*ne;
            
                LC_layer=[exp(1i*d2)*sin(phi)^2+exp(1i*d1)*cos(phi)^2, (exp(1i*d1)-exp(1i*d2))*sin(phi)*cos(phi);
                (exp(1i*d1)-exp(1i*d2))*sin(phi)*cos(phi), exp(1i*d1)*sin(phi)^2+exp(1i*d2)*cos(phi)^2];
            
                incoming_pol_light=LC_layer*incoming_pol_light;
                %disp(LC_layer)
            end
        
            polarizer=[cos(pol_angle)^2, cos(pol_angle)*sin(pol_angle);
                cos(pol_angle)*sin(pol_angle), sin(pol_angle)^2];
            
            pol_light = polarizer * incoming_pol_light;
            output(k)=abs(pol_light(1))^2 + abs(pol_light(2))^2;
        end
        
        
        outputs(3*(m-1)+i,:) = output;
        
        plot(pol_angles*180/pi,output,'Color',colors(m))
        %disp(thickness/lambda)
        %pause(0.1)
    end
end

%disp('Maxtwist:')
%disp(maxtwist)

subplot(2,1,1)
xticks([0,45, 90,135, 180])
%xticklabels({'0', '90', '180'})

xlabel('\gamma [°]')
ylabel('T [%]')
%legend('0.8 \mum','2.1 \mum','3.4 \mum','4.0 \mum','location','SW')
%str=num2str(lambda);
axis([0,180,0,1])

subplot(2,1,2)
xticks([0,45, 90,135, 180])


xlabel('\gamma [°]')
ylabel('T [%]')
%legend('0.8 \mum','2.1 \mum','3.4 \mum','4.0 \mum','location','SW')
%str=num2str(lambda);

set(findall(gcf,'-property','FontSize'),'FontSize',20) % Increase font size for all text
set(findall(gcf,'-property','LineWidth'),'LineWidth',2) % Increase line width for all plots
axis([0,180,0,1])


%% To plot the relevant twists
clf

for m=1:6
    twist=twists(m,:);
    hold on
    plot(twist*180/pi,linspace(0,thickness,1000),'Color',colors(m))
end

%for m=3:4
%    twist=twists(m,:);
%    hold on
%    plot(twist*180/pi,linspace(0,thickness,1000),'--','Color',colors(m))
%end

set(findall(gcf,'-property','FontSize'),'FontSize',20) % Increase font size for all text
set(findall(gcf,'-property','LineWidth'),'LineWidth',2) % Increase line width for all plots

plot([0,0],[0,thickness],':','Color','black','LineWidth',1)

xlabel('\phi [°]')
ylabel('z [\mum]')