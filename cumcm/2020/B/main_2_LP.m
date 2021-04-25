clear;clc;close all
clear;clc;close all
% 给定路线
data = common_tool.Help.get_data("data_input\data.mat", 1);
simple_road = [1, 15 12 15 27];
road = [1, 1, 25, 24, 24, 23, 21, 21, 9, 15, 14, 14, 12, 12, 12, 12, 12, 12, 12, 12, 14, 15, 9, 21, 27];
M = 1000;G = 1000;S0 = 10000;W1 = 3;W2 = 2;P1 = 5;P2 = 10;L = 1200;
C = [0,0,2,1,2,0,1,2,0,0,1,0,2,0,0,0,1,1,0,0,2,2,0,2];
Q  = [1,0,0,0,0,0,0,0,0,0,0,3,0,0,2,0,0,0,0,0,0,0,0,0,0,0,4];
T = numel(road);N = max(road);
X = full(sparse(1:T, road, 1));

sxh = [8 10 5];fxh = [6 10 7];
A = sxh(C + 1);B = fxh(C + 1);BK = +(Q == 1);
D = +(Q == 2);E = +(Q == 3);F = +(Q == 4);

a = X*D';
b = [0; X(1:end-1,:).*X(2:end,:)*E'];
c = [sum(X(1:end-1,:).*X(2:end,:),2); 0];

y = optimvar("y",T,"Type","integer","LowerBound",0);
z = optimvar("z",T,"Type","integer","LowerBound",0);
w = optimvar("w",T,"Type","integer","LowerBound",0, "UpperBound", b);
u1 = optimvar("u1",T,"Type","integer","LowerBound",0);
v1 = optimvar("v1",T,"Type","integer","LowerBound",0);
u2 = optimvar("u2",T,"Type","integer","LowerBound",0);
v2 = optimvar("v2",T,"Type","integer","LowerBound",0);
S = optimvar("S",T);
prob = optimproblem('ObjectiveSense','maximize');
prob.Constraints.c1 = y(2:end) <= M * a(2:end);
prob.Constraints.c2 = z(2:end) <= M * a(2:end);
prob.Constraints.c4 = u1(1) == 0;
prob.Constraints.c5 = v1(1) == 0;
prob.Constraints.c6 = u2 == u1 + y;
prob.Constraints.c7 = v2 == v1 + z;
c8e = optimeq(T-1,1);
c9e = optimeq(T-1,1);
for i = 2 : T
   c8e(i-1) = u1(i) == u2(i-1) - ((1+2*w(i-1))*b(i-1) + (2-c(i-1))*(1-b(i-1))) * A(i-1);
   c9e(i-1) = v1(i) == v2(i-1) - ((1+2*w(i-1))*b(i-1) + (2-c(i-1))*(1-b(i-1))) * B(i-1);
end
prob.Constraints.c8 = c8e;
prob.Constraints.c9 = c9e;
prob.Constraints.c10 = u2*W1 + v2*W2 <= L;
prob.Constraints.c11 = S(1) == S0 - P1 *y(1) - P2*z(1);
c12e = optimeq(T-1,1);
for i = 2 : T
    c12e(i-1) = S(i) == S(i-1) + G*w(i) - P1*y(i)*2 - P2*z(i)*2;
end
prob.Constraints.c12 = c12e;
prob.Objective = S(T) + P1 * u2(T)/2 + P2 * v2(T)/2;
[sol, fvl] = solve(prob);





