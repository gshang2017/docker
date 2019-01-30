cd /
date -R
rm -rf BaiduPCS-Go-* && \
curl --silent "https://api.github.com/repos/liuzhuoling2011/baidupcs-web/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/' |
  xargs -I {} curl -sOL "https://github.com/liuzhuoling2011/baidupcs-web/releases/download/"{}/BaiduPCS-Go-{}'-linux-amd64.zip'&& \
  unzip BaiduPCS-Go-*.zip && \
  rm -rf /usr/local/bin/BaiduPCS-Go && \
  mv BaiduPCS-Go-*/BaiduPCS-Go /usr/local/bin/BaiduPCS-Go && \
  rm -rf BaiduPCS-Go-* && \
  chmod a+x /usr/local/bin/BaiduPCS-Go && \
  /init
