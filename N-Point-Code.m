%% Step 1:
clc;
clear;
close all;

%% Step 2: Data : Q,Demand,Ev,Smin,Smax,Rmin,Rmax,S(1),nVar,VarSize,VarRnage
Q=xlsread('Q.xlsx');
Demand=xlsread('Demand.xlsx');	
EV=xlsread('EV.xlsx');

Smin=10;                                         %AF
Smax=150;                                        %AF
SizeVar=numel(Demand);

VarMin=0;
for i=1:12
VarMaxDemand(i)=max(Demand(i:12:SizeVar));
end
VarMax=VarMaxDemand+Smax;


NPoint=1;                                      %Number of Point in each month (1-point Hedgign or more) Max=41 according to the DemandSize

S(1)=50;                                        %AF
nVar=12;                                        %12 Hedgigng Rule
VarSize=[1 nVar];
VarRange1=[VarMin VarMax];                      %Variation Range of Variables
VarMax=repmat(VarMax,[1 NPoint]);

%% Step 3: GA Parameters

MaxIt=1000;                             % Maximum Number of Iterations
nPop=40;                                % Population Size
pCrossover=0.9;                         % Crossover Percentage
nCrossover=round(pCrossover*nPop/2)*2;  % Number of Parents (Offsprings)
pMutation=0.5;                          % Mutation Percentage
nMutation=round(pMutation*nPop);        % Number of Mutants

%% Step 4: Initialization
empty_individual.Position=[];           % Empty Structure to Hold Individuals Data
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);    % Create Population Matrix

%% Step 5: Simulation
figure
for i=1:nPop
    XValues=unifrnd(VarMin,VarMax(1:NPoint*nVar),[1 NPoint*nVar]);
    
    for j=1:NPoint*nVar
        MonthNumber01=mod(j,12);
        if MonthNumber01==0
            MonthNumber01=12;
        end
        
        if XValues(j)<=VarMax(MonthNumber01)
            YValues(j)=unifrnd(VarMin,min(XValues(j),VarMaxDemand(MonthNumber01)),[1 1]);                  %In Region 1, 0<Y<Demand
        else
            YValues(j)=unifrnd(VarMin,VarMaxDemand(MonthNumber01),[1 1]);                                  %In Region 2, 0<Y<Demand
        end
    end
     
    pop(i).Position=[XValues YValues];
    
    figure;
    scatter(XValues,YValues)
    X=[0 XValues(12) Smax+Demand(12) 2*(Smax+Demand(12))];
    Y=[0 YValues(12) Demand(12) 2*(Smax+Demand(12))];
    
    pop(i).Cost=Simulation(pop(i).Position,S(1),EV,Q,Smin,Smax,Demand,XValues,YValues,NPoint,VarMaxDemand);     %Cost = Max Vulnerability
    
    figure;
    Color=rand(1,3);
    for k=1:12
    subplot(4,3,k);
    
    Size=numel(XValues); 
    
    [MatriXval IndeXval]=sort(XValues(k:12:Size));
    IndeXval=k+(IndeXval-1)*12;
    MatriYval=YValues(IndeXval);
    
    X=[0 MatriXval Smax+VarMaxDemand(k) 1.1*(Smax+VarMaxDemand(k))];                         % Integration of X Points
    Y=[0 MatriYval VarMaxDemand(k)      VarMaxDemand(k)+0.1*(Smax+VarMaxDemand(k))];         % Integration of Y Points
    
    XSop=[0 VarMaxDemand(k) Smax+VarMaxDemand(k) 1.1*(Smax+VarMaxDemand(k))];
    YSop=[0 VarMaxDemand(k) VarMaxDemand(k)      VarMaxDemand(k)+0.1*(Smax+VarMaxDemand(k))];

    set(gcf,'name',['Intial Guess for pop(' num2str(i) ')'],'numbertitle','off','WindowStyle','docked')
    plot(X,Y,'-*','color',Color,'LineWidth',1);
    title({['Reservoir Operation Rule for Month(' num2str(k) ')'];['Vulnerability=' num2str(pop(i).Cost)]})
    hold on
    plot(XSop,YSop,'--','color','r','LineWidth',0.9);
    legend('GA Rule','SLOP','Location','westoutside','Orientation','vertical')
    xlabel('Available Water (AF)')
    ylabel('Releases (AF)')
    
    hold off
    drawnow
    
    end    
end

%% Step 6: BestSol

pop=SortPopulation(pop);           % Sort Population
BestSol=pop(1);                    % Store Best Solution
BestCost=zeros(MaxIt,1);           % Vector to Hold Best Cost Values

%% Step 7: Main Loop
for it=1:MaxIt

%% Step 7.1: Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        i2=randi([1 nPop]);
        
        p1=pop(i1);
        p2=pop(i2);
        
        [popc(k,1).Position(1:NPoint*nVar), popc(k,2).Position(1:NPoint*nVar)]=Crossover(p1.Position(1:NPoint*nVar),p2.Position(1:NPoint*nVar));
        [popc(k,1).Position(NPoint*nVar+1:2*NPoint*nVar), popc(k,2).Position(NPoint*nVar+1:2*NPoint*nVar)]=Crossover(p1.Position(NPoint*nVar+1:2*NPoint*nVar),p2.Position(NPoint*nVar+1:2*NPoint*nVar));
        
        popc(k,1).Cost=Simulation(popc(k,1).Position,S(1),EV,Q,Smin,Smax,Demand,XValues,YValues,NPoint,VarMaxDemand);
        
        %figure;
        XValues=popc(k,1).Position(1:NPoint*nVar);
        YValues=popc(k,1).Position(NPoint*nVar+1:end);
        Color=rand(1,3);
        for mm=1:12
            subplot(4,3,mm);
            Size=numel(XValues);
            [MatriXval IndeXval]=sort(XValues(mm:12:Size));
            IndeXval=mm+(IndeXval-1)*12;
            MatriYval=YValues(IndeXval);
            
            X=[0 MatriXval Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];                          % Integration of X Points
            Y=[0 MatriYval VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];         % Integration of Y Points
            
            XSop=[0 VarMaxDemand(mm) Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];
            YSop=[0 VarMaxDemand(mm) VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];
            
            set(gcf,'name',['Crossover Result for pop(' num2str(k) ')'],'numbertitle','off','WindowStyle','docked')
            plot(X,Y,'-*','color',Color,'LineWidth',1);
            title({['Reservoir Operation Rule for Month(' num2str(mm) ')'];['Vulnerability=' num2str(popc(k,1).Cost)]})
            hold on
            plot(XSop,YSop,'--','color','r','LineWidth',0.9);
            legend('GA Rule','SLOP','Location','westoutside','Orientation','vertical')
            xlabel('Available Water (AF)')
            ylabel('Releases (AF)')
            
            hold off
            drawnow
        end
        
        popc(k,2).Cost=Simulation(popc(k,2).Position,S(1),EV,Q,Smin,Smax,Demand,XValues,YValues,NPoint,VarMaxDemand);
        %figure;
        XValues=popc(k,2).Position(1:NPoint*nVar);
        YValues=popc(k,2).Position(NPoint*nVar+1:end);
        Color=rand(1,3);
        
        for mm=1:12
            subplot(4,3,mm);
            Size=numel(XValues);
            [MatriXval IndeXval]=sort(XValues(mm:12:Size));
            IndeXval=mm+(IndeXval-1)*12;
            MatriYval=YValues(IndeXval);
            
            X=[0 MatriXval Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];    % Integration of X Points
            Y=[0 MatriYval VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];         % Integration of Y Points
            
            XSop=[0 VarMaxDemand(mm) Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];
            YSop=[0 VarMaxDemand(mm) VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];
            
            set(gcf,'name',['Crossover Result for pop(' num2str(k) ')'],'numbertitle','off','WindowStyle','docked')
            plot(X,Y,'-*','color',Color,'LineWidth',1);
            title({['Reservoir Operation Rule for Month(' num2str(mm) ')'];['Vulnerability=' num2str(popc(k,2).Cost)]})
            hold on
            plot(XSop,YSop,'--','color','r','LineWidth',0.9);
            legend('GA Rule','SLOP','Location','westoutside','Orientation','vertical')
            xlabel('Available Water (AF)')
            ylabel('Releases (AF)')
            
            hold off
            drawnow
        end
        
     end
    popc=popc(:);
    
  %% Step 7.2: Mutation
  
      popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        
        p=pop(i);
        
        popm(k).Position=Mutate(p.Position,VarRange1,NPoint,Smax,nVar);
        
        
        popm(k).Cost=Simulation(popm(k).Position,S(1),EV,Q,Smin,Smax,Demand,XValues,YValues,NPoint,VarMaxDemand);
        
       
        XValues=popm(k).Position(1:NPoint*nVar);
        YValues=popm(k).Position(NPoint*nVar+1:end);
        Color=rand(1,3);
        for mm=1:12
            subplot(4,3,mm);
            Size=numel(XValues);
            [MatriXval IndeXval]=sort(XValues(mm:12:Size));
            IndeXval=mm+(IndeXval-1)*12;
            MatriYval=YValues(IndeXval);
            
            X=[0 MatriXval Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];                          % Integration of X Points
            Y=[0 MatriYval VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];         % Integration of Y Points
            
            XSop=[0 VarMaxDemand(mm) Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];
            YSop=[0 VarMaxDemand(mm) VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];
            
            set(gcf,'name',['Mutation Result for pop(' num2str(k) ')'],'numbertitle','off','WindowStyle','docked')
            plot(X,Y,'-*','color',Color,'LineWidth',1);
            title({['Reservoir Operation Rule for Month(' num2str(mm) ')'];['Vulnerability=' num2str(popm(k).Cost)]})
            hold on
            plot(XSop,YSop,'--','color','r','LineWidth',0.9);
            legend('GA Rule','SLOP','Location','westoutside','Orientation','vertical')
            xlabel('Available Water (AF)')
            ylabel('Releases (AF)')
            
            hold off
            drawnow
        end
        
    end
    
 %% Step 7.3: Merge Population
    pop=[pop
         popc
         popm];  %#ok
     
%% Step 7.4: Selection Function     
    
    pop=SortPopulation(pop);   % Sort Population
    pop=pop(1:nPop);           % Truncate Individuals
    BestSol=pop(1);            % Update Best Solution
    BestCost(it)=BestSol.Cost; % Store Best Cost
    
    
       %figure;
        XValues=BestSol.Position(1:NPoint*nVar);
        YValues=BestSol.Position(NPoint*nVar+1:end);
        Color=rand(1,3);
        
        
        XSop1= VarMaxDemand;
        YSop1= VarMaxDemand;
        NSLOP=1;
        SLOPCost=Simulation_SLOP([XSop1 YSop1],S(1),EV,Q,Smin,Smax,Demand,XSop1,YSop1,NSLOP,VarMaxDemand);
        
        figure
        for mm=1:12
            
            subplot(4,3,mm);
            Size=numel(XValues);
            [MatriXval IndeXval]=sort(XValues(mm:12:Size));
            IndeXval=mm+(IndeXval-1)*12;
            MatriYval=YValues(IndeXval);
            
            X=[0 MatriXval Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];                          % Integration of X Points
            Y=[0 MatriYval VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];         % Integration of Y Points
            
            XSop=[0 VarMaxDemand(mm) Smax+VarMaxDemand(mm) 1.1*(Smax+VarMaxDemand(mm))];
            YSop=[0 VarMaxDemand(mm) VarMaxDemand(mm)      VarMaxDemand(mm)+0.1*(Smax+VarMaxDemand(mm))];
            
            set(gcf,'name',['Bestsol Result'],'numbertitle','off','WindowStyle','docked')
            plot(X,Y,'-*','color',Color,'LineWidth',1);
            title({['Reservoir Operation Rule for Month (' num2str(mm) ')'];['Vulnerability GA=' num2str(BestSol.Cost)];['Vulnerability SLOP=' num2str(SLOPCost)];['Iteration =' num2str(it)]})
            hold on
            plot(XSop,YSop,'--','color','r','LineWidth',0.9);
            legend('GA Rule','SLOP','Location','westoutside','Orientation','vertical')
            xlabel('Available Water (AF)')
            ylabel('Releases (AF)')
            
            hold off
            drawnow
        end
    
%% Step 7.5: Result
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) ': SLOP Cost = ' num2str(SLOPCost)]); % Show Iteration Information
    saveas(gcf,strcat('Results_',num2str(it),'.png'))
end
