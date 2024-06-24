#!/bin/bash


#sudo useradd -Ng wheel --create-home --no-log-init chatgpt
#sudo passwd chatgpt

sudo usermod -aG sys chatgpt
groups chatgpt
sudo usermod -aG network chatgpt
groups chatgpt
sudo usermod -aG power chatgpt
groups chatgpt
sudo usermod -aG rfkill chatgpt
groups chatgpt
sudo usermod -aG users chatgpt
groups chatgpt
sudo usermod -aG video chatgpt
groups chatgpt
sudo usermod -aG storage chatgpt
groups chatgpt
sudo usermod -aG optical chatgpt
groups chatgpt
sudo usermod -aG scanner chatgpt
groups chatgpt
sudo usermod -aG lp chatgpt
groups chatgpt
sudo usermod -aG audio chatgpt
groups chatgpt
sudo usermod -aG wheel chatgpt
groups chatgpt

