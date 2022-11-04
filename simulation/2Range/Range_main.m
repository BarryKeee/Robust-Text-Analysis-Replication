clear all
clc

%% N = 10
N = 10;          %Total Number of words in each document
I_sim = 1000;         %Number of Posterior Draws from (p1,p2)

Range(N, I_sim);
Algo2Range(N, I_sim);
CredibleSet90_Range(N, I_sim);

%% N = 100
N = 100;          %Total Number of words in each document
I_sim = 1000;         %Number of Posterior Draws from (p1,p2)

Range(N, I_sim);
Algo2Range(N, I_sim);
CredibleSet90_Range(N, I_sim);
