#!/bin/bash

########################################
# CAN Utils
########################################
# Enable Socket vcan0
evcan0(){
  sudo ip link add dev vcan0 type vcan
  sudo ip link set up vcan0
  ip link show vcan0
}

evcan1(){
  sudo ip link add dev vcan1 type vcan
  sudo ip link set up vcan1
  ip link show vcan1
}

# Enable Socket can0
ecan0(){
  sudo modprobe can_dev
  sudo modprobe can
  sudo modprobe can_raw
  sudo ip link set can0 type can bitrate 500000
  sudo ip link set up can0
}

