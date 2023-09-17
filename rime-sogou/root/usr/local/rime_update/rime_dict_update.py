#!/usr/bin/env python
# coding=utf-8
# ============================================================
#
# ============================================================
from glob import glob
import os
import shutil
import requests
import datetime
import feedparser
import tarfile
import re

#删除文件指定行前面内容
def delete_lines(filename, count):
    f1 = open(filename, 'r',encoding='utf-8')
    a = f1.readlines()
    f2 = open(filename, 'w',encoding='utf-8')
    b = ''.join(a[count:])
    f2.write(b)
#合并文件
def merge_file(filename_1, filename_2):
    f1 = open(filename_1,'a+',encoding='utf-8')
    with open(filename_2,'r',encoding='utf-8') as f2:
        for i in f2:
            f1.write(i)
#替换文本
def alter(filename,old_str,new_str):
    with open(filename, "r", encoding="utf-8") as f1,open("%s.bak" % filename, "w", encoding="utf-8") as f2:
        for line in f1:
            f2.write(re.sub(old_str,new_str,line))
    os.remove(filename)
    os.rename("%s.bak" % filename, filename)
#限制词库长度
def len_num(filename):
    m=0
    f1 = open(filename, 'r',encoding='UTF-8')
    f2 = open('tmp.txt','a+',encoding='utf-8')
    for line in f1.readlines():
        if m <= 22:
            f2.write(line)
        else:
            break
        m += 1
    f1.close()
    f2.close()
    delete_lines(filename, 23)
    f1 = open(filename, 'r',encoding='UTF-8')
    f2 = open('tmp.txt','a+',encoding='utf-8')
    for line in f1.readlines():
        tmp_data = line.replace("\n","").split("\t", 2)
        if len(tmp_data[0]) <= int(len_num_set):
            f2.write(line)
    f1.close()
    f2.close()
    os.remove(filename)
    os.rename("tmp.txt",filename)
#输出rime文件
def rime_yaml_output(filename_1,filename_2):
    #完善yaml文件输出格式
    data1 = '''# Rime dictionary
# encoding: utf-8
#
'''
    if filename_1.find("basic_dict") != -1:
        data2 = "#自定义基础词汇"+"\n"
        data3 = "#"
    elif filename_1.find("english_dict") != -1:
        data2 = "#自定义英语词汇"+"\n"
        data3 = "#"
    else:
        data2 = "#sogou输入法("+filename_2+")词汇"+"\n"
        data3 = "#"+sogou_nav_url
    data4 = '''
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
    data5 = "name: "+filename_1+"\n"
    #创建时间
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    data6 = "version: \""+now+"\""
    data7 = '''
sort: by_weight
use_preset_vocabulary: false
columns:
  - text #第一列字／词
  - code #第二列码
  - weight #第三列字／词频
...
'''
    output_file = open(filename_1+".dict.yaml", "r+")
    old = output_file.read()
    output_file.seek(0)
    output_file.write(data1)
    output_file.write(data2)
    output_file.write(data3)
    output_file.write(data4)
    output_file.write(data5)
    output_file.write(data6)
    output_file.write(data7)
    output_file.write(old)
    #opencc转换
    if rime_opencc:
            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(filename_1+".dict.yaml",filename_1+".dict.yaml",rime_opencc_config))
    os.chmod(filename_1+".dict.yaml", 0o0777)

#更新词库
def update(latest_version):
    #搜狗词库名
    sogou_dict_name_list = ["sogou_medicine_and_medicine", "sogou_video_games", "sogou_art_design", "sogou_life_encyclopedia", "sogou_sports_and_leisure", "sogou_humanities", "sogou_entertainment_and_leisure", "sogou_city_information", "sogou_natural_science", "sogou_social_sciences", "sogou_engineering_application", "sogou_agriculture_and_fishing_livestock"]
    #删除旧文件
    for root, dirs, files in os.walk('/usr/local/rimedictupdate'):
        for name in files:
                os.remove(os.path.join(root, name))
    #下载文件
    if rime_dict_non_tengxun_del_set:
        url_2 = github_proxy+'https://github.com/gshang2017/rime-dict/releases/download/'+latest_version+'/rime-dict-non-tengxun-del.yaml.tar.gz'
    else:
        url_2 = github_proxy+'https://github.com/gshang2017/rime-dict/releases/download/'+latest_version+'/rime-dict.yaml.tar.gz'
    r = requests.get(url_2)
    if rime_dict_non_tengxun_del_set:
        scel_file = open("rime-dict-non-tengxun-del.yaml.tar.gz", "wb+")
    else:
        scel_file = open("rime-dict.yaml.tar.gz", "wb+")
    scel_file.write(r.content)
    scel_file.close()
    if rime_dict_non_tengxun_del_set:
        filename = "rime-dict-non-tengxun-del.yaml.tar.gz"
    else:
        filename = "rime-dict.yaml.tar.gz"
    tf = tarfile.open(filename)
    tf.extractall('/usr/local/rimedictupdate')
    #英语词库
    if english_dict_set:
        #opencc转换
        if rime_opencc:
            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %("english_dict.dict.yaml","english_dict.dict.yaml"+"basic_dict.dict.yaml",rime_opencc_config))
        shutil.copy('english_dict.dict.yaml',"/output")
    #基础词库
    if basic_dict_set:
        file_name = "luna_pinyin_simp.basic_dict.dict.yaml"
        alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
        os.rename(file_name,prefix_dict_name+"basic_dict.dict.yaml")
        #词库长度
        if int(len_num_set) > 0:
            len_num(prefix_dict_name+"basic_dict.dict.yaml")
        #opencc转换
        if rime_opencc:
            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(prefix_dict_name+"basic_dict.dict.yaml",prefix_dict_name+"basic_dict.dict.yaml",rime_opencc_config))
        os.chmod(prefix_dict_name+"basic_dict.dict.yaml", 0o0777)
        shutil.copy(prefix_dict_name+"basic_dict.dict.yaml","/output")

    #维基词库
    if wiki_dict_set:
        file_name = "luna_pinyin_simp.wiki_dict.dict.yaml"
        alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
        os.rename(file_name,prefix_dict_name+"wiki_dict.dict.yaml")
        #词库长度
        if int(len_num_set) > 0:
            len_num(prefix_dict_name+"wiki_dict.dict.yaml")
        #opencc转换
        if rime_opencc:
            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(prefix_dict_name+"wiki_dict.dict.yaml",prefix_dict_name+"basic_dict.dict.yaml",rime_opencc_config))
        os.chmod(prefix_dict_name+"wiki_dict.dict.yaml", 0o0777)
        shutil.copy(prefix_dict_name+"wiki_dict.dict.yaml","/output")

    #字母词词库
    if lettered_word_dict_set:
        file_name = "luna_pinyin_simp.lettered_word_dict.dict.yaml"
        alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
        os.rename(file_name,prefix_dict_name+"lettered_word_dict.dict.yaml")
        #词库长度
        if int(len_num_set) > 0:
            len_num(prefix_dict_name+"lettered_word_dict.dict.yaml")
        #opencc转换
        if rime_opencc:
            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(prefix_dict_name+"lettered_word_dict.dict.yaml",prefix_dict_name+"basic_dict.dict.yaml",rime_opencc_config))
        os.chmod(prefix_dict_name+"lettered_word_dict.dict.yaml", 0o0777)
        shutil.copy(prefix_dict_name+"lettered_word_dict.dict.yaml","/output")

    #拆字词库
    if chaizi_dict_set:
        file_name = "luna_pinyin_simp.chaizi_dict.dict.yaml"
        alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
        os.rename(file_name,prefix_dict_name+"chaizi_dict.dict.yaml")
        #词库长度
        if int(len_num_set) > 0:
            len_num(prefix_dict_name+"chaizi_dict.dict.yaml")
        os.chmod(prefix_dict_name+"chaizi_dict.dict.yaml", 0o0777)
        shutil.copy(prefix_dict_name+"chaizi_dict.dict.yaml","/output")

    #搜狗官方推荐词库
    if sogou_total_official_dict_set:
        file_name = "luna_pinyin_simp.sogou_total_dict.official.dict.yaml"
        alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
        os.rename(file_name,prefix_dict_name+"sogou_total_dict.official.dict.yaml")
        #词库长度
        if int(len_num_set) > 0:
            len_num(prefix_dict_name+"sogou_total_dict.official.dict.yaml")
        #opencc转换
        if rime_opencc:
            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(prefix_dict_name+"sogou_total_dict.official.dict.yaml",prefix_dict_name+"sogou_total_dict.official.dict.yaml",rime_opencc_config))
        os.chmod(prefix_dict_name+"sogou_total_dict.official.dict.yaml", 0o0777)
        shutil.copy(prefix_dict_name+"sogou_total_dict.official.dict.yaml","/output")
    #非搜狗官方推荐词库
    if rime_dict_non_tengxun_del_set:
        if sogou_total_unofficial_dict_set:
            file_name = "luna_pinyin_simp.sogou_total_dict.unofficial.dict.yaml"
            alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
            os.rename(file_name,prefix_dict_name+"sogou_total_dict.unofficial.dict.yaml")
            #词库长度
            if int(len_num_set) > 0:
                len_num(prefix_dict_name+"sogou_total_dict.unofficial.dict.yaml")
            #opencc转换
            if rime_opencc:
                os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(prefix_dict_name+"sogou_total_dict.unofficial.dict.yaml",prefix_dict_name+"sogou_total_dict.unofficial.dict.yaml",rime_opencc_config))
            os.chmod(prefix_dict_name+"sogou_total_dict.unofficial.dict.yaml", 0o0777)
            shutil.copy(prefix_dict_name+"sogou_total_dict.unofficial.dict.yaml","/output")
    else:
        if sogou_unofficial_dict_set:
            #合并输出非搜狗官方推荐词库为单文件
            if sogou_single_file:
                for i in sogou_dict_name_list:
                    sogou_dict_name_env_set = os.getenv(i.upper(), default = 'True') == 'True'
                    if sogou_dict_name_env_set:
                        file_name = "luna_pinyin_simp."+i+".unofficial.dict.yaml"
                        delete_lines(file_name, 23)
                        merge_file(sogou_total_unofficial_file_name,file_name)
                #限制词频长度
                if not order_set and int(len_num_set) > 0:
                    f1 = open(sogou_total_unofficial_file_name, 'r',encoding='UTF-8')
                    f2 = open('tmp.txt','a+',encoding='utf-8')
                    for line in f1.readlines():
                        tmp_data = line.replace("\n","").split("\t", 2)
                        if len(tmp_data[0]) <= int(len_num_set):
                            f2.write(line)
                    f1.close()
                    f2.close()
                    os.remove(sogou_total_unofficial_file_name)
                    os.rename("tmp.txt",sogou_total_unofficial_file_name)
                #去重 Deduplication
                if deduplication_set:
                    lines = set()
                    outfile = open('order.txt', 'w',encoding='UTF-8')
                    with open(sogou_total_unofficial_file_name, 'r', encoding='utf-8') as f:
                        for line in f:
                            if line not in lines:
                                outfile.write(line)
                                lines.add(line)
                    outfile.close()
                    f.close()
                #排序
                if order_set:
                    n=0
                    if int(len_num_set) > 0:
                        for n in range(int(len_num_set)+1):
                            if deduplication_set:
                                f1 = open('order.txt', 'r',encoding='UTF-8')
                            else:
                                f1 = open(sogou_total_unofficial_file_name, 'r',encoding='UTF-8')
                            f2 = open('order2.txt','a+',encoding='utf-8')
                            for line in f1.readlines():
                                tmp_data = line.replace("\n","").split("\t", 2)
                                if len(tmp_data[0]) == n:
                                    f2.write(line)
                            n += 1
                            f1.close()
                            f2.close()
                    else:
                        for n in range(8):
                            if deduplication_set:
                                f1 = open('order.txt', 'r',encoding='UTF-8')
                            else:
                                f1 = open(sogou_total_unofficial_file_name, 'r',encoding='UTF-8')
                            f2 = open('order2.txt','a+',encoding='utf-8')
                            for line in f1.readlines():
                                tmp_data = line.replace("\n","").split("\t", 2)
                                if len(tmp_data[0]) == n:
                                    f2.write(line)
                            n += 1
                            f1.close()
                            f2.close()
                #输出文件
                if deduplication_set and not order_set:
                    shutil.copy('order.txt',sogou_total_unofficial_file_name)
                if order_set:
                    shutil.copy('order2.txt',sogou_total_unofficial_file_name)
                filename_1 = prefix_dict_name+'sogou_total_dict.unofficial'
                filename_2 = '非官方全部词汇'
                rime_yaml_output(filename_1,filename_2)
                #复制yaml文件到指定目录
                os.chmod(sogou_total_unofficial_file_name, 0o0777)
                shutil.copy(sogou_total_unofficial_file_name,"/output")
            else:
                #输出非搜狗官方推荐词库为多文件
                for i in sogou_dict_name_list:
                    sogou_dict_name_env_set = os.getenv(i.upper(), default = 'True') == 'True'
                    if sogou_dict_name_env_set:
                        file_name = "luna_pinyin_simp."+i+".unofficial.dict.yaml"
                        alter(file_name, "luna_pinyin_simp.", prefix_dict_name)
                        os.rename(file_name,prefix_dict_name+i+".unofficial.dict.yaml")
                        #词库长度
                        if int(len_num_set) > 0:
                            len_num(prefix_dict_name+i+".unofficial.dict.yaml")
                        #opencc转换
                        if rime_opencc:
                            os.system('''opencc  --noflush 1 -i %s -o %s -c %s''' %(prefix_dict_name+i+".unofficial.dict.yaml",prefix_dict_name+i+".unofficial.dict.yaml",rime_opencc_config))
                        os.chmod(prefix_dict_name+i+".unofficial.dict.yaml", 0o0777)
                        shutil.copy(prefix_dict_name+i+".unofficial.dict.yaml","/output")

#创建目录
if not os.path.exists('/output'):
    os.mkdir('/output')
if not os.path.exists('/config'):
    os.mkdir('/config')
if not os.path.exists('/usr/local/rimedictupdate'):
    os.mkdir('/usr/local/rimedictupdate')
#指定工作目录
os.chdir('/usr/local/rimedictupdate')
#环境变量设定
english_dict_set = os.getenv('ENGLISH_DICT_SET',default = 'True') == 'True'
basic_dict_set = os.getenv('BASIC_DICT_SET',default = 'True') == 'True'
wiki_dict_set = os.getenv('WIKI_DICT_SET',default = 'True') == 'True'
lettered_word_dict_set = os.getenv('LETTERED_WORD_DICT_SET',default = 'True') == 'True'
chaizi_dict_set = os.getenv('CHAIZI_DICT_SET',default = 'True') == 'True'
sogou_total_official_dict_set = os.getenv('SOGOU_TOTAL_OFFICIAL_DICT_SET',default = 'True') == 'True'
sogou_total_unofficial_dict_set = os.getenv('SOGOU_TOTAL_UNOFFICIAL_DICT_SET',default = 'True') == 'True'
sogou_unofficial_dict_set = os.getenv('SOGOU_UNOFFICIAL_DICT_SET',default = 'True') == 'True'
order_set = os.getenv('ORDER',default = 'True') == 'True'
deduplication_set = os.getenv('DEDUPLICATION',default = 'True') == 'True'
len_num_set = os.getenv('LEN_NUM',default = '0')
rime_opencc = os.getenv('RIME_OPENCC',default = 'False')== 'True'
rime_opencc_config = os.getenv('RIME_OPENCC_CONFIG',default = 's2t.json')
prefix_dict_name = os.getenv('PREFIX_DICT_NAME',default = 'luna_pinyin_simp.')
sogou_nav_url = 'https://pinyin.sogou.com/dict/cate/index'
sogou_total_unofficial_file_name = prefix_dict_name+'sogou_total_dict.unofficial.dict.yaml'
sogou_single_file = os.getenv('SOGOU_SINGLE_FILE',default = 'True') == 'True'
rime_dict_non_tengxun_del_set = os.getenv('RIME_DICT_NON_TENGXUN_DEL_SET',default = 'False') == 'True'
github_proxy = os.getenv('GITHUB_PROXY',default = '')
#提取版本号
url='https://github.com/gshang2017/rime-dict/releases.atom'
d=feedparser.parse(url)
latest_version=d.entries[0].title
#输出词库
if not os.path.exists('/config/version.txt'):
    file = open("/config/version.txt", "wb+")
    file.write(str(latest_version).encode('utf-8'))
    file.close()
    update(latest_version)
else:
    old_version = open('/config/version.txt', 'r',encoding='UTF-8').read()
    if old_version != latest_version:
        os.remove('/config/version.txt')
        file = open("/config/version.txt", "wb+")
        file.write(str(latest_version).encode('utf-8'))
        file.close()
        update(latest_version)
#删除旧文件
for root, dirs, files in os.walk('/usr/local/rimedictupdate'):
    for name in files:
        os.remove(os.path.join(root, name))
