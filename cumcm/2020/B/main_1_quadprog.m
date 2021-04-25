clear;clc;close all
model = gurobi_read('model2.mps');
results = gurobi(model);
disp(results.objval)