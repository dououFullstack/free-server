# free-server

Gain more freedom with my free-server for Chinese (mainland), Iranians, North Koreans, and the kind.

## News and Change logs
* Important fix: [Bug] fix restart dead processes bug 
  (for SPDY and Shadowsocks process healthy monitoring, tested passed on Ubuntu 15, Digital Ocean)

-------

* 2015-08-12 Testing passed on Digital Ocean Ubuntu Server 15
* 2015-08-10 Many datacenters of Linode are getting unstable due to China GFW policies. Digital Ocean or Amazon EC2 may be better candidates.
* 2015-08-10 Shadowsocks and SPDY installation is well tested on Linode Ubuntu 15 now.
* 2015-08-10 Will work on OpenVPN later

## Description

* This script is to assist you setup a Linux Server hosting proxy/VPN service of Shadowsocks, SPDY and OpenVPN, within Ubuntu Server 15.
* Still in progress, not done yet.
* It has been tested within Linode Ubuntu Server 15. It should be running well on all latest Ubuntu Server releases.

## Installation

* You need to obtain a HTTPS SSL Certificate before you install SPDY server. Get one for free from [StartSSL](https://www.startssl.com/?app=12).
* Note that you can't use self-signed SSL cert. It must be issued by third-party authorities thanks to Chrome SPDY SSL validation.

```bash
rm install-shadowsocks-spdy-openvpn.sh
wget --no-cache -q https://raw.githubusercontent.com/lanshunfang/free-server/master/install-shadowsocks-spdy-openvpn.sh
bash install-shadowsocks-spdy-openvpn.sh
```

Note that, the script could be redeployed/reinstalled on your Ubuntu without worries on losing any old Shadowsocks/SPDY account or password.
It backs them up if found any before execute re-installation.

## Create User

```bash
Shadowsocks+SPDY: ~/free-server/createuser User Pass ShadowsocksPort SPDYPort 

Shadowsocks Only: ~/free-server/createuser-shadowsocks Port Pass 

SPDY Only: ~/free-server/createuser-spdy User Pass Port 
```

## How to setup clients

* All the pages are password protected. To get the password, pls email to lanshunfang#gmail.com with email title: "free-server password" (Auto respond)
* [SPDY (Chinese only)](http://www.xiaofang.me/2014/12/20/windowsmaclinux-%E4%BD%BF%E7%94%A8%E5%AE%88%E6%9C%9B%E6%97%A0%E5%A2%99%E8%AE%A1%E5%88%92%E7%9A%84-spdy-%E9%AB%98%E9%80%9F%E7%BF%BB%E5%A2%99%E8%AE%BE%E7%BD%AE/ "Chinese only")
* [Shadowsocks--Windows/Mac/Android (Chinese only)](http://www.xiaofang.me/2013/05/17/%E5%B0%8F%E6%96%B9%E6%97%A0%E5%A2%99%E8%AE%A1%E5%88%92%E5%9F%BA%E4%BA%8Eshadowsocks%E7%9A%84%E7%BF%BB%E5%A2%99%E5%AE%A2%E6%88%B7%E7%AB%AF%E8%AE%BE%E7%BD%AE/ "Chinese only")
* [Shadowsocks--OpenWRT Router (Chinese only)](http://www.xiaofang.me/2015/05/05/%E5%AE%88%E6%9C%9B%E6%97%A0%E5%A2%99%E8%AE%A1%E5%88%92%E5%AE%B6%E5%BA%AD%E4%BC%81%E4%B8%9Abeta1%E7%89%88-%E6%99%BA%E8%83%BD%E8%B7%AF%E7%94%B1%E5%99%A8%E6%9E%84%E5%BB%BA%E6%96%B9/ "Chinese only")
* OpenVPN for IOS (In-progress)

## Donation
Chinese:  

------

兄弟们，最近 Linode 新加坡、Fremont节点都不稳定，间歇性 IP 屏蔽中断，我搬迁到 Digital Ocean 上面就基本稳定。

得到一个邀请码：[http://www.digitalocean.com/?refcode=1708d0551741](http://www.digitalocean.com/?refcode=1708d0551741)
 
邀请使用～～你得10美金优惠，我得25美金返券 ：）谢谢哈～～

小方的翻墙服务器一键安装教程： [https://github.com/lanshunfang/free-server](https://github.com/lanshunfang/free-server)

软件工程师，翻墙是基本技能 ：）


English:  

------

Hey there,

Here is my Digital Ocean initation link. [http://www.digitalocean.com/?refcode=1708d0551741](http://www.digitalocean.com/?refcode=1708d0551741) You get $10 back, I get $25. 

I would be very grateful if you use my code to register and use Digital Ocean Ubuntu/Linux. It's much more stable than Linode for China Mainland Internet connection those days.

## More

* This script will add several crontab configurations to `/etc/cron.d` and `/etc/cron.daily` to monitor Shadowsocks / SPDY service running healthy.
* For more stability, both Shadowsocks and SPDY are running in multiple instances, one per user, not single process.