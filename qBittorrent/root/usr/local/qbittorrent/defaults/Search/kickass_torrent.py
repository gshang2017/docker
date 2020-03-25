#VERSION: 2.0
#AUTHORS: mauricci

from helpers import retrieve_url
from helpers import download_file, retrieve_url
from novaprinter import prettyPrinter
import re

try:
    #python3
    from html.parser import HTMLParser
    from urllib.parse import unquote
except ImportError:
    #python2
    from HTMLParser import HTMLParser
         
class kickass_torrent(object):
    url = 'https://kickass2.biz'
    name = 'KickAss torrent'
    supported_categories = {'all': 'all'}
    
    class MyHTMLParser(HTMLParser):

        def __init__(self):
            HTMLParser.__init__(self)
            self.url = 'https://kickass2.biz'
            self.TABLE_INDEX = 1
            self.insideDataTd = False
            self.tdCount = -1
            self.tableCount = -1
            self.insideTitle = False
            self.infoMap = {'name':0,'size':1,'seeds':3,'leech':4}
            self.fullResData = []
            self.singleResData = self.getSingleData()
            
        def getSingleData(self):
            return {'name':'-1','seeds':'-1','leech':'-1','size':'-1','link':'-1','desc_link':'-1','engine_url':self.url}
        
        def handle_starttag(self, tag, attrs):
            #print("Encountered a start tag:", tag)
            if tag == 'table':
                self.tableCount += 1
            if tag == 'td':
                self.tdCount += 1
                if self.tableCount == self.TABLE_INDEX:
                    self.insideDataTd = True
            if self.insideDataTd and tag == 'a' and len(attrs) > 0:
                 Dict = dict(attrs)
                 if self.infoMap['name'] == self.tdCount and 'href' in Dict \
                    and Dict.get('class','').find('cellMainLink') != -1:
                     self.insideTitle = True
                     self.singleResData['desc_link'] = self.url + Dict['href']
                 elif self.infoMap['name'] == self.tdCount and 'href' in Dict \
                    and Dict.get('href', '').find('magnet') != -1:
                        magnet = Dict.get('href', '')
                        magnet = magnet.partition('?url=')[2]
                        self.singleResData['link'] = magnet

        def handle_endtag(self, tag):
            if tag == 'td':
                self.insideDataTd = False
            if tag == 'tr':
                self.tdCount = -1
                if len(self.singleResData) > 0:
                    #ignore trash stuff
                    if self.singleResData['name'] != '-1' and self.isValidSize(self.singleResData['size']):
                        prettyPrinter(self.singleResData) 
                        self.fullResData.append(self.singleResData)
                    self.singleResData = self.getSingleData()

        def handle_data(self, data):
            if self.insideDataTd:
                for key,val in self.infoMap.items():
                    if self.tdCount == val:
                        currKey = key
                        #torrent's title is an exception
                        if currKey == 'name' and self.insideTitle:
                            self.singleResData[currKey] = data.strip()
                            self.insideTitle = False
                        if currKey != 'name':
                            if currKey in self.singleResData and data.strip() != '':
                                if self.singleResData[currKey] == '-1':
                                    self.singleResData[currKey] = data.strip()
                                else:
                                    self.singleResData[currKey] += data.strip()

        def feed(self,html):
            HTMLParser.feed(self,html)
            self.insideDataTd = False
            self.insideTitle = False
            self.tdCount = -1
            self.tableCount = -1

        #true if the size is valid (must contain number and no ',')
        def isValidSize(self, size):
            return size.find(',') == -1 and bool(re.search(r'\d', size))

    # DO NOT CHANGE the name and parameters of this function
    # This function will be the one called by nova2.py
    def search(self, what, cat='all'):
        currCat = self.supported_categories[cat]
        #what = what.replace('%20','-')
        parser = self.MyHTMLParser()
        #analyze 10 pages
        pageNum = 10
        currPage = 1
        while currPage <= pageNum:
            url = self.url+'/usearch/{0}/{1}/'.format(what,currPage)
            print(url)
            html = retrieve_url(url)
            parser.feed(html)
            currPage += 1
            if len(parser.fullResData) <= 0:
                break
        #print(parser.fullResData)   
        data = parser.fullResData
        print(len(data))
        parser.close()

    def download_torrent(self, info):
        """ Downloader """
        magnet = url = unquote(info)
        print(magnet + ' ' + info)

if __name__ == "__main__":
    k = kickass_torrent()
    k.search('tomb%20raider')
    #k.download_torrent('magnet%3A%3Fxt%3Durn%3Abtih%3Aa3888d1acc2e25a41c76d7a5befb4234b1f62640%26dn%3DLegendary.Tomb.of.the.Dragon.2013.1080p.BluRay.H264.AAC%26tr%3Dudp%253A%252F%252Ftracker.leechers-paradise.org%253A6969%26tr%3Dudp%253A%252F%252Ftracker.openbittorrent.com%253A80%26tr%3Dudp%253A%252F%252Fopen.demonii.com%253A1337%26tr%3Dudp%253A%252F%252Ftracker.coppersurfer.tk%253A6969%26tr%3Dudp%253A%252F%252Fexodus.desync.com%253A6969')
