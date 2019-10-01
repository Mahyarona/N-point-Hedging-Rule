# N-point-Hedging-Rule

A platform has been developed to find the optimal coordinates of n-point hedging rule for an agricultural reservoir using the genetic algorithm (GA). This platform written in MATLAB can be modified for any agricultural reservoir considering different objective function. The Hyrum Reservoir as the agricultural reservoir in the Bear River system is considered as the case study and the platform is executed for different values for n-point (1, 5, 10, 20, and 40) under minimizing the vulnerability indicator. In addition, the values for vulnerability achieved by the GA are compared to the standard linear operation policy (SLOP). Results indicated that there are no differences between the optimal n-point hedging rule found by GA and the SLOP in terms of vulnerability. After analyzing the results, the author found that the water availability is more than the amount of demand related to the demand sites of the Hyrum reservoir in all period of the operation. In other words, there is a spill from the reservoir for all the period of operation. That’s why the vulnerability for all n-point hedging rule achieved by the GA is similar to the vulnerability calculated based on the SLOP. Therefore, it is recommended that the operators of the Hyrum reservoir keep using the SLOP until there is a development in the agricultural field that leads to increasing the amount of the demand. In developing situation, they can run the platform to achieve the optimal n-point hedging rule in terms of minimizing the vulnerability or even other objective functions.

## Hedging Rule in the Reservoir System

The importance and the rule of hedging rule policy are discussed and shown in the reservoir operation system section and Fig 3. Recall that the simplest form that links AW to RV is SLOP described in the introduction section and Fig 1. Although SLOP is based on releases to stratify demands in each period as much as there is water in the reservoir storage, when there is no sufficient water ($S_t<Demand_t$) in the reservoir storage, all the water storage should be released which means that the reservoir will be empty in the next period. That’s why SLOP doesn’t preserve water for the future requirements and system faces a big failure to meet the demand in the next periods. To cope this issue, some researchers use the non-linear forms of hedging rule and evaluate it using performance indicators. Others try to find the optimal values of both 45o slopes and the threshold of the spill. Moreover, there is another approach to modifying SLOP using breaking the lines (AB, BC, and CD in Fig 2) into more lines with different slopes called n-point hedging rule. Regardless of these approaches to modify the hedging rule, usually, the modification of the hedging rule is considered under a specific objective function (convert to an optimization problem). The objective function can be an improvement in the performance criteria such as reliability, resiliency or vulnerability or even minimizing the deficit.


| <img src="https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig1.jpg" width="548">|
|:--:| 
| *Fig 1. A layout of SLOP* |

| <img src="https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig2.jpg" width="548">| 
|:--:| 
| *Fig 2. A layout of two-point hedging rule* |

| <img src="https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig3.jpg" width="548">| 
|:--:| 
| *Fig 3. The simulation process of an agricultural reservoir operation* |
## Performance Criteria of the Reservoir System

To evaluate the performance of a water resources system, it is necessary to develop and use indices. The most famous indices have been introduced by Hashimoto et al. (1982) and developed by many researchers (Loucks et al. 1981 and Sandoval-Solis et al. 2011). The Hashimoto's risk-based indicators are reliability, vulnerability, and resiliency that quantify the frequency, size, and length of the system failures, respectively. The sustainability is another index that shows the efficiency of the system calculated based on reliability, vulnerability, and resiliency. According to demerit feature of SLOP (poor performance regarding the vulnerability), the vulnerability indicator is considered as the objective function in GA to find the optimal coordinate for n-point hedging rule and its formulations is as follows:


![Eq.1 \label{Eq:1}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Eq1.png) <br />
![Eq.1 \label{Eq:1}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Eq2.png) <br />

## Evolutionary Algorithm
The evolutionary algorithms such as GA are methods to solve an optimization problem. These algorithms can reach to the near optimal solution using an intelligent searching algorithm. They start with a randomly guess as a preliminary solution and then correct the solution in an iterative process using modification functions. GA uses the mutation and cross-over function inspired by the nature process of the human evolution to correct the guess in each iterative. Moreover, the mutation function enables GA to escape of trapping in local optima. This iterative continues until the stopping criterion (number of iteration) is satisfied. Therefore, GA has four different parameters that should be defined before running, including the number of population (in this study, 20), the crossover rate (70%), the mutation rate (30%) and the number of iteration (in this study, 100). There is trade-off between the number of population and the number of iteration. For example, to have a convergence in the results, we can consider either the size of population equal to 20 and the number of iteration equal to 1000 or the size of population equal to 1000 and the number of iteration equal to 20. As it is evident, in both case the number of evaluation of the objective function which is the multiplying the population size and number of iteration is the same (20 x 1000 or 1000 x 20).
      
## Optimization problem for n-point hedging rule
As discussed before, in this project, the optimization problem is solved using the GA considering minimizing the vulnerability as the objective function (Eq. 12). In the optimization problem, the coordinate location of hedging points (such as B and C in Fig 2) are the decision variables that determine the function f in Eq. 12. The optimization model of the agriculture reservoir based on the hedging rule is as follows. 
 
Subject to: 
![Eq.3 \label{Eq:3}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Eq3.PNG) <br />
 
The optimization problem runs for several values of n (1, 5, 10, 20, and 40) and for each of those, the vulnerability is calculated once for Hyrum reservoir with the hedging rule provided by GA and once based on the SLOP. The procedure of these steps is illustrated in Fig 4.   

<!--
| ![The procedure of the GA to optimize n-hedging rule\label{fig:4}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig4.jpg)| 
|:--:| 
| *Fig 4. The procedure of the GA to optimize n-point hedging rule* |
-->


|<img src="https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig4.jpg" width="548">|
|:--:| 
| *Fig 4. The procedure of the GA to optimize n-point hedging rule* |



As it is shown in Fig 4, in the first loop, n value will be set (i.e. n=1) and in the second loop GA randomly guess a preliminary solution (i.e. coordinate location of points B and C in Fig 2 because of n=2). In other words, GA produces a bunch of monthly n-point hedging rule which means that each population in each iteration consists of 12 different hedging rules and each of those is related to the specific month. Next, the reservoir releases will be simulated based on the hedging rule that is a function of the coordinate location of those points and the objective function will be calculated. Then, the preliminary solution will be modified using the cross-over and mutation function until the stopping criterion is satisfied. In this moment, the vulnerability indicator is calculated based on the optimal coordinate location found by GA for the Hyrum reservoir and for the entire system. The indicator will be compared with the indicator calculated under SLOP rule. Afterward, the outer loop will be reset, n will be set to other values for n (i.e. 5) and the same procedure for inner loop will be executed until stopping criterion for the outer loop is satisfied (i.e. n <40). 

## Results

### 1-point Hedging Rule vs SLOP
|<img src="https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/1-point.gif" width="2000">|
|:--:| 
| *Fig 5. The procedure of the GA to optimize n-point hedging rule* |


