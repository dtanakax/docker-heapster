![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

docker-heapster
=====================

Base Docker Image
---------------------

[dtanakax/debianjp:wheezy](https://registry.hub.docker.com/u/dtanakax/debianjp/)

説明
---------------------

Heapster Dockerコンテナ作成設定

使用方法
---------------------

- cAdvisor IPアドレス直接指定する場合  
環境変数`CADVISOR_SERVICE_IPS`へカンマ区切りで設定します。

        $ docker run -d \
                --name heapster \
                -e CADVISOR_SERVICE_IPS="10.1.x.xxx;10.1.x.xxx" \
            dtanakax/heapster \
                 --sink=influxdb:http://<influxdb_ip>:8086/ --source=cadvisor:external

- CoreOSのFleet使用する場合  

        $ docker run -d \
                --name heapster \
            dtanakax/heapster
                --sink=influxdb:http://<influxdb_ip>:8086/ \
                --source=cadvisor:coreos?fleetEndpoint=http://<fleet_ip>:4001

- その他のオプションについては以下のURLを参考にして下さい。

    [https://github.com/GoogleCloudPlatform/heapster/blob/master/docs/source-configuration.md](https://github.com/GoogleCloudPlatform/heapster/blob/master/docs/source-configuration.md)

トラブルシューティング
---------------------

正常に動作しない場合は
[https://docs.docker.com/installation/ubuntulinux/#memory-and-swap-accounting](https://docs.docker.com/installation/ubuntulinux/#memory-and-swap-accounting)
を参考にOSのMemorySwapを有効にする。

- CoreOSの場合

    Units作成 (user_dataへ追記)

        units:
            - name: swap.service
              command: start
              content: |
                [Unit]
                Description=Turn on swap

                [Service]
                Type=oneshot
                Environment="SWAPFILE=/2GiB.swap"
                RemainAfterExit=true
                ExecStartPre=/usr/sbin/losetup -f ${SWAPFILE}
                ExecStart=/usr/bin/sh -c "/sbin/swapon $(/usr/sbin/losetup -j ${SWAPFILE} | /usr/bin/cut -d : -f 1)"
                ExecStop=/usr/bin/sh -c "/sbin/swapoff $(/usr/sbin/losetup -j ${SWAPFILE} | /usr/bin/cut -d : -f 1)"
                ExecStopPost=/usr/bin/sh -c "/usr/sbin/losetup -d $(/usr/sbin/losetup -j ${SWAPFILE} | /usr/bin/cut -d : -f 1)"

                [Install]
                WantedBy=local.target

    Swapファイル作成

        $ sudo fallocate -l 2048m /2GiB.swap
        $ sudo chmod 600 /2GiB.swap
        $ sudo chattr +C /2GiB.swap
        $ sudo mkswap /2GiB.swap

    OSリブート
        
        $ sudo reboot

License
---------------------

The MIT License
Copyright (c) 2015 Daisuke Tanaka

以下に定める条件に従い、本ソフトウェアおよび関連文書のファイル（以下「ソフトウェア」）の複製を取得するすべての人に対し、ソフトウェアを無制限に扱うことを無償で許可します。これには、ソフトウェアの複製を使用、複写、変更、結合、掲載、頒布、サブライセンス、および/または販売する権利、およびソフトウェアを提供する相手に同じことを許可する権利も無制限に含まれます。

上記の著作権表示および本許諾表示を、ソフトウェアのすべての複製または重要な部分に記載するものとします。

ソフトウェアは「現状のまま」で、明示であるか暗黙であるかを問わず、何らの保証もなく提供されます。ここでいう保証とは、商品性、特定の目的への適合性、および権利非侵害についての保証も含みますが、それに限定されるものではありません。 作者または著作権者は、契約行為、不法行為、またはそれ以外であろうと、ソフトウェアに起因または関連し、あるいはソフトウェアの使用またはその他の扱いによって生じる一切の請求、損害、その他の義務について何らの責任も負わないものとします。

The MIT License
Copyright (c) 2015 Daisuke Tanaka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.