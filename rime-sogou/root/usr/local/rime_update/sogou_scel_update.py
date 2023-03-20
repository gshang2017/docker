#!/usr/bin/env python
# coding=utf-8
# ============================================================
#依赖requests
# ============================================================
from glob import glob
import os
import shutil
import requests
import hashlib
import datetime

#创建目录
if not os.path.exists('/output'):
    os.mkdir('/output')
if not os.path.exists('/usr/local/sogouscelupdate'):
    os.mkdir('/usr/local/sogouscelupdate')
#指定工作目录
os.chdir('/usr/local/sogouscelupdate')

#下载细胞词文件temp.scel
url = 'https://pinyin.sogou.com/d/dict/download_cell.php?id=4&name=%E7%BD%91%E7%BB%9C%E6%B5%81%E8%A1%8C%E6%96%B0%E8%AF%8D%E3%80%90%E5%AE%98%E6%96%B9%E6%8E%A8%E8%8D%90%E3%80%91&f=detail'
r = requests.get(url)
scel_file = open("temp.scel", "wb+")
scel_file.write(r.content)
scel_file.close()

#计算md5
md5_file = open("temp.scel", 'rb')
data = md5_file.read()
md5 = hashlib.md5(data).hexdigest()
md5_file.close()
print(md5)

#判断文件是否更新（md5）
if os.path.exists(md5+".scel"):
    os.remove("temp.scel")
    os._exit(0)
else:
    os.rename("temp.scel",md5+".scel")

#删除多余.scel文件
n = 0
for root, dirs, files in os.walk('./'):
    for name in files:
        if(not name.startswith(md5) and name.endswith(".scel")):
         n += 1
         print(n)
         os.remove(os.path.join(root, name))


#转换.scel文件
scel_md5_file = glob("*.scel")
dict_name = os.getenv('SOGOU_DICT_NAME')
if dict_name is None:
   dict_name = 'luna_pinyin_simp.sogou_pop'
elif len(dict_name) == 0:
   dict_name = 'luna_pinyin_simp.sogou_pop'
scel_output_file = '{name}.dict.yaml'.format(name=dict_name)
command='''dotnet /usr/local/imewlconverter/ImeWlConverterCmd.dll -i:scel %s -ft:"rm:eng|rm:num|rm:space|rm:pun" -o:rime "%s"''' % (str(scel_md5_file).strip('[]').replace(',',''),scel_output_file)
os.system(command)

#完善yaml文件输出格式
data1 = '''
# Rime dictionary
# encoding: utf-8
#
#sogou输入法网络流行新词
#https://pinyin.sogou.com/dict/detail/index/4

# 部署位置：
# ~/.config/ibus/rime  (Linux ibus)
# ~/.config/fcitx/rime  (Linux fcitx)
# ~/Library/Rime  (Mac OS)
# %APPDATA%\Rime  (Windows)
#
# 于重新部署后生效
#

---
'''
#创建名称
data2 = "name: "+dict_name+"\n"
#创建时间
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
data3 = "version: \""+now+"\""
data4 = '''
sort: by_weight
use_preset_vocabulary: false
columns:
  - text #第一列字／词
  - code #第二列码
  - weight #第三列字／词频
...

'''
output_file = open(scel_output_file, "r+")
old = output_file.read()
output_file.seek(0)
output_file.write(data1)
output_file.write(data2)
output_file.write(data3)
output_file.write(data4)
output_file.write(old)

#删除多余.yaml文件
n = 0
for root, dirs, files in os.walk('./'):
    for name in files:
        if(not name.startswith(scel_output_file) and name.endswith(".yaml")):
         n += 1
         print(n)
         os.remove(os.path.join(root, name))

#复制yaml文件到指定目录
os.chmod(scel_output_file, 0o0777)
shutil.copy(scel_output_file,"/output")
