#!/bin/bash
cat >/usr/local/etc/xray/config.json <<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": ${PORT},
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${UUID}",
                        "flow": "xtls-rprx-direct",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 52000,
                        "xver": 1
                    },
                    {
                        "path": "/${VLESS_WS_PATH}/",
                        "dest": 52001,
                        "xver": 1
                    },
                    {
                        "path": "/${VMESS_TCP_PATH}/",
                        "dest": 52002,
                        "xver": 1
                    },
                    {
                        "path": "/${VMESS_WS_PATH}/",
                        "dest": 52003,
                        "xver": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "http/1.2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/xray/self_signed_cert.pem",
                            "keyFile": "/usr/local/etc/xray/self_signed_key.pem"
                       },
                        {
                            "certificateFile": "/ssl/xray.crt",
                            "keyFile": "/ssl/xray.key"
                       }
                    ]
                }
            }
        },
        {
            "port": 52000,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "${QJPASS}",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ],
                "fallbacks": [
                    {
                        "dest": 80
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none",
                "tcpSettings": {
                    "acceptProxyProtocol": true
                }
            }
        },
        {
            "port": 52001,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${UUID}",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "/${VLESS_WS_PATH}/"
                }
            }
        },
        {
            "port": 52002,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${UUID}",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none",
                "tcpSettings": {
                    "acceptProxyProtocol": true,
                    "header": {
                        "type": "http",
                        "request": {
                            "path": [
                                "/${VMESS_TCP_PATH}/"
                            ]
                        }
                    }
                }
            }
        },
        {
            "port": 52003,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${UUID}",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "/${VMESS_WS_PATH}/"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF
