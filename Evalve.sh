#!/bin/bash


meep results_before.ctl | tee results_before.out
meep results_after.ctl | tee results_after.out

h5topng results_before-eps-000000.00.h5
h5topng -S3 -Zc dkbluered -a yarg -A results_before-eps-000000.00.h5 results_before-ez-000150.10.h5
grep flux1: results_before.out > flux_before.dat
grep flux1: results_after.out > flux_after.dat



