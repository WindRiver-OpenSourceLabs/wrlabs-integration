#!/bin/sh

#* Copyright (c) 2018 Wind River Systems, Inc.
#* 
#* This program is free software; you can redistribute it and/or modify
#* it under the terms of the GNU General Public License version 2 as
#* published by the Free Software Foundation.
#* 
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#* See the GNU General Public License for more details.
#* 
#* You should have received a copy of the GNU General Public License
#* along with this program; if not, write to the Free Software
#* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

partbase=`mount |grep "sysroot " | awk '{print $1}' | awk -F 'p' '{print $1}'`
part=${partbase}'p1'
mkdir -p /tmp/realboot
mount ${part} /tmp/realboot
rm -rf /tmp/realboot/boot_cnt
umount /tmp/realboot
rm -rf /tmp/realboot

