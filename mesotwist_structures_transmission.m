%% To plot transmission curves, run THIS CELL ONLY

clf
incoming_pol_light=[1;0];
no=1.5; %Can be any number, does not affect the output
ne=no+0.220571429; % no+birefringence

lambdas=[500,600]*1e-9; %Wavelengths of light

%Cell gaps (can be varied or the same for all cases)
thicknesses=[3.5,3.5,3.5,3.5,3.5,3.5]*1e-6; 

%Colors for the graphs
colors=['b','c','g','y','r','m'];

%Define the shapes of the structures to be compared
%Thickness dependent amplitudes can be left out and included at a later
%step
shapes=[linspace(0,1,500),linspace(1,0,500);
        linspace(0,-0.2,100),linspace(-0.2,0.8,500),linspace(0.8,0,400);
        linspace(0,-0.4,200),linspace(-0.4,0.6,500),linspace(0.6,0,300);
        linspace(0,-0.6,300),linspace(-0.6,0.4,500),linspace(0.4,0,200);
        linspace(0,-0.8,400),linspace(-0.8,0.2,500),linspace(0.2,0,100);
        linspace(0,-1,500),linspace(-1,0,500)];

for m=1:6 %Go through all cases
    for i=1:2 %Go through the wavelengths
        subplot(2,1,i)
        hold on
    
        thickness=thicknesses(m);
        dz=thickness/1000; %Cell gap divided into 1000 equally thick uniform slabs
        mid_twist=thickness/4.7e-6*0.5; %twist angle across half the cell gap (radians). Here you can include thickness dependencies.
        lambda=lambdas(i);
        
        twist=-mid_twist*shapes(m,:);%Combine shape and twist angle
       
        gammas=linspace(0,pi);%angle between polarizers
        
        output=zeros(1,100);

        for k=1:100 %Go through gamma
            gamma=gammas(k);
            incoming_pol_light=[1;0]; %Incoming light
            for j=1:1000 %Let light pass through all slabs
                phi=twist(j);
                d1=2*pi*dz/lambda*no;
                d2=2*pi*dz/lambda*ne;
            
                LC_layer=[exp(1i*d2)*sin(phi)^2+exp(1i*d1)*cos(phi)^2, (exp(1i*d1)-exp(1i*d2))*sin(phi)*cos(phi);
                (exp(1i*d1)-exp(1i*d2))*sin(phi)*cos(phi), exp(1i*d1)*sin(phi)^2+exp(1i*d2)*cos(phi)^2];
            
                incoming_pol_light=LC_layer*incoming_pol_light;
            end
        
            polarizer=[cos(gamma)^2, cos(gamma)*sin(gamma);
                cos(gamma)*sin(gamma), sin(gamma)^2]; 
            
            pol_light = polarizer * incoming_pol_light; %Let light pass analyzer
            output(k)=abs(pol_light(1))^2 + abs(pol_light(2))^2; %Amplitude of transmitted light
        end
        
        plot(gammas*180/pi,output,'Color',colors(m))
    end
end

%Some plot settings

subplot(2,1,1)
xticks([0,45, 90,135, 180])
xlabel('\gamma [°]')
ylabel('T [%]')
axis([0,180,0,1])

subplot(2,1,2)
xticks([0,45, 90,135, 180])
xlabel('\gamma [°]')
ylabel('T [%]')

set(findall(gcf,'-property','FontSize'),'FontSize',20) % Increase font size for all text
set(findall(gcf,'-property','LineWidth'),'LineWidth',2) % Increase line width for all plots
axis([0,180,0,1])


%% To plot the director structures (run entire code, or this cell after the first)
clf

for m=1:6
    shape=-mid_twist*shapes(m,:);
    hold on
    plot(shape*180/pi,linspace(0,thickness,1000),'Color',colors(m))
end

set(findall(gcf,'-property','FontSize'),'FontSize',20) % Increase font size for all text
set(findall(gcf,'-property','LineWidth'),'LineWidth',2) % Increase line width for all plots

plot([0,0],[0,thickness],':','Color','black','LineWidth',1)

xlabel('\phi [°]')
ylabel('z [\mum]')
