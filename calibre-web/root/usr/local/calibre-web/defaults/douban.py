# -*- coding: utf-8 -*-
#来源 https://github.com/fugary/simple-boot-douban-api/issues/7

import requests
import os
from cps.services.Metadata import Metadata

class Douban(Metadata):
    __name__ = "Douban"
    __id__ = "douban"

    def search(self, query, __):
        if self.active:
            val = list()
            headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"}
            result = requests.get(os.getenv('DOUBANIP')+"/v2/book/search?q="+query.replace(" ","+"),headers = headers )
            for r in result.json()['books']:
                v = dict()
                v['id'] = r['id']
                v['title'] = r['title']
                v['authors'] = r.get('author', [])
                v['description'] = r['summary']
                v['publisher'] = r['publisher']
                v['publishedDate'] = r['pubdate']
                tmp_tags =[]
                for tag in r.get('tags',[]):
                    tmp_tags.append(tag['name'])
                v['tags'] = tmp_tags
                try:
                    v['rating'] = float(r['rating'].get('average', '0')) / 2.0
                except:
                     v['rating'] = 0
                v['cover'] = r['image']
                v['source'] = {
                    "id": self.__id__,
                    "description": "Douban Books",
                    "link": os.getenv('DOUBANIP')+"/v2/book/"}
                v['url'] = "https://book.douban.com/subject/" + r['id']
                val.append(v)
            return val
