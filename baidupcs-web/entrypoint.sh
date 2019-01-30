cd /
date -R
curl -s https://api.github.com/repos/liuzhuoling2011/baidupcs-web/releases/latest \
  | grep browser_download_url \
  | grep linux-amd64 \
  | cut -d '"' -f 4 \
  | wget -qi - && \
  unzip BaiduPCS-Go-*.zip && \
  mv BaiduPCS-Go-*/BaiduPCS-Go /usr/local/bin/BaiduPCS-Go && \
  rm -rf BaiduPCS-Go-* && \
  chmod a+x /usr/local/bin/BaiduPCS-Go && \
  /init
