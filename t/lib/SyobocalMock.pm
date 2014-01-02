package SyobocalMock;
use strict;
use warnings;

use LWP::UserAgent;
use LWP::Protocol::PSGI;

use Router::Simple;
use Plack::Request;

use Data::Section::Simple qw(get_data_section);

my $router = Router::Simple->new();
$router->connect('/rss2.php', {target => 'rss2'});
$router->connect('/json.php', {target => 'json'});
$router->connect('/usr',      {target => 'login'});
$router->connect('/find',     {target => 'search'});

sub register {
    my ($class) = @_;
    my $self = bless { }, $class;

    my $psgi_app = sub {
        my $env = shift;
        my $result = [404, [], ['not found']];
        if (my $p = $router->match($env)) {
            my $req = Plack::Request->new($env);
            my $target = $p->{target};

            my $content = $self->$target($req);

            $result = [200, [], [$content]];
        }
        return $result;
    };
    LWP::Protocol::PSGI->register($psgi_app);

    return $self;
}

sub rss2 {
    my ($self, $req) = @_;
    get_data_section('rss2');
}

sub json {
    my ($self, $req) = @_;
    my $result = '';
    if ($req->param('TID')) {
        $result = get_data_section('json_tid');
    }
    elsif ($req->param('PID')) {
        $result = get_data_section('json_pid');
    }
    elsif ($req->param('Req') eq 'TitleSearch') {
        $result = get_data_section('search_tiny');
    }
    return $result;
}

sub search {
    my ($self, $req) = @_;
}

1;

__DATA__
@@ rss2
{
   "chInfo" : {
      "6" : {
         "ChURL" : "http://www.tv-asahi.co.jp/bangumi/",
         "ChName" : "テレビ朝日",
         "ChiEPGName" : "テレビ朝日",
         "ChID" : "6",
         "ChComment" : "http://jk.nicovideo.jp/watch/jk5\r\n",
         "ChGID" : "1"
      },
      "128" : {
         "ChURL" : "http://www.bs11.jp/program/today.php",
         "ChName" : "BS11デジタル",
         "ChiEPGName" : "ＢＳ１１",
         "ChID" : "128",
         "ChComment" : "2007年12月1日より開局",
         "ChGID" : "2"
      },
      "20" : {
         "ChURL" : "http://www.at-x.com/program",
         "ChName" : "AT-X",
         "ChiEPGName" : "",
         "ChID" : "20",
         "ChComment" : "",
         "ChGID" : "6"
      }
   },
   "items" : [
      {
         "ChURL" : "http://www.bs11.jp/program/today.php",
         "Flag" : "8",
         "Revision" : "0",
         "ChID" : "128",
         "ChGID" : "2",
         "Cat" : "10",
         "Title" : "TIGER & BUNNY",
         "Warn" : "0",
         "LastUpdate" : "1324397652",
         "ShortTitle" : "",
         "Urls" : "http://www.tigerandbunny.net/\t公式\nhttp://www.mbs.jp/tigerandbunny/\tMBS\nhttp://www.ustream.tv/channel/tigerandbunny\tUSTREAM\nhttp://www.bs11.jp/anime/1367/\tBS11デジタル\nhttp://www.mxtv.co.jp/tiger_bunny/\tTOKYO MX\nhttp://www.b-ch.com/ttl/index.php?ttl_c=2963\tバンダイチャンネル",
         "SubTitle" : "There's no way out. (袋の鼠)",
         "ProgComment" : "",
         "StOffset" : "0",
         "PID" : "210905",
         "ChName" : "BS11デジタル",
         "EdTime" : "1329472800",
         "TID" : "2148",
         "Count" : "19",
         "Deleted" : "0",
         "AllDay" : "0",
         "StTime" : "1329471000"
      },
      {
         "ChURL" : "http://www.tv-asahi.co.jp/bangumi/",
         "Flag" : "0",
         "Revision" : "0",
         "ChID" : "6",
         "ChGID" : "1",
         "Cat" : "1",
         "Title" : "ドラえもん(新)",
         "Warn" : "0",
         "LastUpdate" : "1326519537",
         "ShortTitle" : "ドラえもん",
         "Urls" : "http://hanaballoon.com/dorachan/data/anime/mizuta/list/index.html\t[1]\nhttp://anime_list.at.infoseek.co.jp/\t[2]\nhttp://www.geocities.co.jp/Athlete-Crete/9483/gdc/2005/st_index.html\t[3]\nhttp://www.tv-asahi.co.jp/doraemon/\tテレビ朝日\nhttp://dora-world.com/\tどらえもんチャンネル\nhttp://www.shin-ei-animation.jp/modules/products/index.php?id=5\tシンエイ動画",
         "SubTitle" : "あったか～い雪合戦／スネ夫が剛田商店でアルバイト",
         "ProgComment" : "",
         "StOffset" : "0",
         "PID" : "214354",
         "ChName" : "テレビ朝日",
         "EdTime" : "1329474600",
         "TID" : "636",
         "Count" : "239",
         "Deleted" : "0",
         "AllDay" : "0",
         "StTime" : "1329472800"
      },
      {
         "ChURL" : "http://www.at-x.com/program",
         "Flag" : "8",
         "Revision" : "0",
         "ChID" : "20",
         "ChGID" : "6",
         "Cat" : "10",
         "Title" : "がくえんゆーとぴあ まなびストレート！",
         "Warn" : "0",
         "LastUpdate" : "1328328726",
         "ShortTitle" : "まなびストレート！",
         "Urls" : "http://www.starchild.co.jp/special/manabi/\tスターチャイルド\nhttp://www.tv-tokyo.co.jp/anime/manabi/\tテレビ東京\nhttp://www.mediaworks.co.jp/contents/manabi/index.php\tメディアワークス",
         "SubTitle" : "月曜日じゃ遅すぎる",
         "ProgComment" : "",
         "StOffset" : "0",
         "PID" : "215317",
         "ChName" : "AT-X",
         "EdTime" : "1329521400",
         "TID" : "748",
         "Count" : "3",
         "Deleted" : "0",
         "AllDay" : "0",
         "StTime" : "1329519600"
      }
   ]
}

@@ json_tid

{"Titles":{"2077":{"TID":"2077","Title":"\u9b54\u6cd5\u5c11\u5973\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","ShortTitle":"\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","TitleYomi":"\u307e\u307b\u3046\u3057\u3087\u3046\u3058\u3087\u307e\u3069\u304b\u307e\u304e\u304b","TitleEN":"PUELLA MAGI MADOKA MAGICA","Cat":"10","FirstCh":"MBS","FirstYear":"2011","FirstMonth":"1","FirstEndYear":"2011","FirstEndMonth":"4","TitleFlag":"0","Keywords":"wikipedia:\u9b54\u6cd5\u5c11\u5973\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","UserPoint":"416","UserPointRank":"53","TitleViewCount":"0","Comment":"*\u30ea\u30f3\u30af\r\n-[[\u516c\u5f0f http:\/\/www.madoka-magica.com\/tv\/]]\r\n-[[MBS http:\/\/www.mbs.jp\/madoka-magica\/]]\r\n-[[\u30cb\u30b3\u30cb\u30b3\u30c1\u30e3\u30f3\u30cd\u30eb http:\/\/ch.nicovideo.jp\/ch260]]\r\n-[[TOKYO MX http:\/\/www.mxtv.co.jp\/madoka_magica\/]]\r\n-[[BS11\u30c7\u30b8\u30bf\u30eb http:\/\/www.bs11.jp\/anime\/2360\/]]\r\n*\u30e1\u30e2\r\n-\u30a2\u30cb\u30de\u30c3\u30af\u30b9\u3067\u306e\u30ea\u30d4\u30fc\u30c8\u653e\u9001\u306f\u653e\u9001\u65e5\u306e27:00\uff5e\u3068\u65e5\u66dc26:00\uff5e\r\n*\u30b9\u30bf\u30c3\u30d5\r\n:\u539f\u4f5c:Magica Quartet\r\n:\u76e3\u7763:\u65b0\u623f\u662d\u4e4b\r\n:\u30ad\u30e3\u30e9\u30af\u30bf\u30fc\u539f\u6848:\u84bc\u6a39\u3046\u3081\r\n:\u30ad\u30e3\u30e9\u30af\u30bf\u30fc\u30c7\u30b6\u30a4\u30f3:\u5cb8\u7530\u9686\u5b8f\r\n:\u30b7\u30ea\u30fc\u30ba\u69cb\u6210\u30fb\u811a\u672c:\u865a\u6df5\u7384(\u30cb\u30c8\u30ed\u30d7\u30e9\u30b9)\r\n:\u30b7\u30ea\u30fc\u30ba\u30c7\u30a3\u30ec\u30af\u30bf\u30fc:\u5bae\u672c\u5e78\u88d5\r\n:\u7dcf\u4f5c\u753b\u76e3\u7763:\u8c37\u53e3\u6df3\u4e00\u90ce\u3001\u9ad8\u6a4b\u7f8e\u9999\r\n:\u30a2\u30af\u30b7\u30e7\u30f3\u30c7\u30a3\u30ec\u30af\u30bf\u30fc:\u963f\u90e8\u671b\u3001\u795e\u8c37\u667a\u5927\r\n:\u30ec\u30a4\u30a2\u30a6\u30c8\u8a2d\u8a08:\u7267\u5b5d\u96c4\r\n:\u7570\u7a7a\u9593\u8a2d\u8a08:\u5287\u56e3\u30a4\u30cc\u30ab\u30ec\u30fc\r\n:\u7f8e\u8853\u76e3\u7763:\u7a32\u8449\u90a6\u5f66\u3001\u91d1\u5b50\u96c4\u53f8\r\n:\u7f8e\u8853\u8a2d\u5b9a:\u5927\u539f\u76db\u4ec1\r\n:\u8272\u5f69\u8a2d\u8a08:\u65e5\u6bd4\u91ce\u4ec1\u3001\u6edd\u6ca2\u3044\u3065\u307f\r\n:\u30d3\u30b8\u30e5\u30a2\u30eb\u30a8\u30d5\u30a7\u30af\u30c8:\u9152\u4e95\u57fa\r\n:\u64ae\u5f71\u76e3\u7763:\u6c5f\u85e4\u614e\u4e00\u90ce\r\n:\u7de8\u96c6:\u677e\u539f\u7406\u6075\r\n:\u97f3\u97ff\u76e3\u7763:\u9db4\u5ca1\u967d\u592a\r\n:\u97f3\u97ff\u5236\u4f5c:\u697d\u97f3\u820e\r\n:\u97f3\u697d:\u68b6\u6d66\u7531\u8a18\r\n:\u97f3\u697d\u5236\u4f5c:\u30a2\u30cb\u30d7\u30ec\u30c3\u30af\u30b9\r\n:\u30a2\u30cb\u30e1\u30fc\u30b7\u30e7\u30f3\u5236\u4f5c:SHAFT\r\n:\u88fd\u4f5c:Magica Partners(\u30a2\u30cb\u30d7\u30ec\u30c3\u30af\u30b9\u3001\u82b3\u6587\u793e\u3001\u535a\u5831\u5802DY\u30e1\u30c7\u30a3\u30a2\u30d1\u30fc\u30c8\u30ca\u30fc\u30ba\u3001\u30cb\u30c8\u30ed\u30d7\u30e9\u30b9\u3001\u30e0\u30fc\u30d3\u30c3\u30af\u3001SHAFT)\u3001\u6bce\u65e5\u653e\u9001\r\n*\u30aa\u30fc\u30d7\u30cb\u30f3\u30b0\u30c6\u30fc\u30de\u300c\u30b3\u30cd\u30af\u30c8\u300d\r\n:\u4f5c\u8a5e\u30fb\u4f5c\u66f2:\u6e21\u8fba\u7fd4\r\n:\u4e3b\u984c\u6b4c\u5354\u529b:\u5916\u6751\u656c\u4e00\r\n:\u6b4c:ClariS\r\n:\u4f7f\u7528\u8a71\u6570:#1\uff5e#9\u3001#11\r\n-#10\u3001#12\u306f\u30aa\u30fc\u30d7\u30cb\u30f3\u30b0\u30c6\u30fc\u30de\u306a\u3057\u3001\u30a8\u30f3\u30c7\u30a3\u30f3\u30b0\u30c6\u30fc\u30de\u3068\u3057\u3066\u4f7f\u7528\r\n*\u30a8\u30f3\u30c7\u30a3\u30f3\u30b0\u30c6\u30fc\u30de\u300cMagia\u300d\r\n:\u4f5c\u8a5e\u30fb\u4f5c\u66f2\u30fb\u7de8\u66f2:\u68b6\u6d66\u7531\u8a18\r\n:\u97f3\u697d\u30d7\u30ed\u30c7\u30e5\u30fc\u30b5\u30fc:\u68ee\u5eb7\u54f2\r\n:\u6b4c:Kalafina\r\n:\u4f7f\u7528\u8a71\u6570:#3\uff5e#8\u3001#11(Blu-ray\/DVD\u306e\u307f)\r\n-#1\u3001#2\u3001#9\u3001#11(\u653e\u9001\u7248)\u306f\u30a8\u30f3\u30c7\u30a3\u30f3\u30b0\u30c6\u30fc\u30de\u306a\u3057\r\n-#1\u3001#2\u3001#10\u306f\u633f\u5165\u6b4c\u3068\u3057\u3066\u4f7f\u7528\r\n*\u30ad\u30e3\u30e9\u30af\u30bf\u30fc\u30a8\u30f3\u30c7\u30a3\u30f3\u30b0\u30bd\u30f3\u30b01\u300c\u307e\u305f \u3042\u3057\u305f\u300d\r\n:\u4f5c\u8a5e\u30fb\u4f5c\u66f2:hanawaya\r\n:\u7de8\u66f2:\u6d41\u6b4c\u3001\u7530\u53e3\u667a\u5247\r\n:\u6b4c:\u9e7f\u76ee\u307e\u3069\u304b(\u60a0\u6728\u78a7)\r\n:\u4f7f\u7528\u8a71\u6570:#1\uff5e#2(Blu-ray\/DVD\u306e\u307f)\r\n*\u30ad\u30e3\u30e9\u30af\u30bf\u30fc\u30a8\u30f3\u30c7\u30a3\u30f3\u30b0\u30bd\u30f3\u30b02\u300cand I'm home\u300d\r\n:\u4f5c\u8a5e\u30fb\u4f5c\u66f2:wowaka\r\n:\u7de8\u66f2:\u3069\u304f\u3001wowaka\r\n:\u6b4c:\u7f8e\u6a39\u3055\u3084\u304b(\u559c\u591a\u6751\u82f1\u68a8)\u3001\u4f50\u5009\u674f\u5b50(\u91ce\u4e2d\u85cd)\r\n:\u4f7f\u7528\u8a71\u6570:#9(Blu-ray\/DVD\u306e\u307f)\r\n*\u633f\u5165\u6b4c\u300c\u30b3\u30cd\u30af\u30c8 (\u30b2\u30fc\u30e0\u30a4\u30f3\u30b9\u30c8)\u300d\r\n:\u4f5c\u66f2:\u6e21\u8fba\u7fd4\r\n:\u4f7f\u7528\u8a71\u6570:#6\r\n*\u30ad\u30e3\u30b9\u30c8\r\n:\u9e7f\u76ee\u307e\u3069\u304b:\u60a0\u6728\u78a7\r\n:\u6681\u7f8e\u307b\u3080\u3089:\u658e\u85e4\u5343\u548c\r\n:\u5df4\u30de\u30df\uff0f\u9e7f\u76ee\u30bf\u30c4\u30e4:\u6c34\u6a4b\u304b\u304a\u308a\r\n:\u7f8e\u6a39\u3055\u3084\u304b:\u559c\u591a\u6751\u82f1\u68a8\r\n:\u4f50\u5009\u674f\u5b50:\u91ce\u4e2d\u85cd\r\n:\u30ad\u30e5\u30a5\u3079\u3048:\u52a0\u85e4\u82f1\u7f8e\u91cc\r\n:\u5fd7\u7b51\u4ec1\u7f8e:\u65b0\u8c37\u826f\u5b50\r\n:\u9e7f\u76ee\u8a62\u5b50:\u5f8c\u85e4\u9091\u5b50\r\n:\u9e7f\u76ee\u77e5\u4e45:\u5ca9\u6c38\u54f2\u54c9\r\n:\u4e0a\u6761\u606d\u4ecb:\u5409\u7530\u8056\u5b50\r\n:\u65e9\u4e59\u5973\u548c\u5b50:\u5ca9\u7537\u6f64\u5b50\r\n*\u4e88\u544a\u30a4\u30e9\u30b9\u30c8\r\n:#1:\u30cf\u30ce\u30ab\u30b2\r\n:#2:\u6c37\u5ddd\u3078\u304d\u308b\r\n:#3:\u6d25\u8def\u53c2\u6c70(\u30cb\u30c8\u30ed\u30d7\u30e9\u30b9)\r\n:#4:\u5c0f\u6797\u5c3d\r\n:#5:\u3086\u30fc\u307d\u3093(\u30cb\u30c8\u30ed\u30d7\u30e9\u30b9)\r\n:#6:\u30a6\u30a8\u30c0\u30cf\u30b8\u30e1\r\n:#7:\u5929\u6749\u8cb4\u5fd7\r\n:#8:\u85e4\u771f\u62d3\u54c9\r\n:#9:\u306a\u307e\u306b\u304fATK(\u30cb\u30c8\u30ed\u30d7\u30e9\u30b9)\r\n:#10:\u30e0\u30e9\u9ed2\u6c5f\r\n:#11:\u30d6\u30ea\u30ad\r\n*\u30a8\u30f3\u30c9\u30a4\u30e9\u30b9\u30c8\r\n:#12:\u84bc\u6a39\u3046\u3081","SubTitles":"*01*\u5922\u306e\u4e2d\u3067\u4f1a\u3063\u305f\u3001\u3088\u3046\u306a\u30fb\u30fb\u30fb\u30fb\u30fb\r\n*02*\u305d\u308c\u306f\u3068\u3063\u3066\u3082\u5b09\u3057\u3044\u306a\u3063\u3066\r\n*03*\u3082\u3046\u4f55\u3082\u6050\u304f\u306a\u3044\r\n*04*\u5947\u8de1\u3082\u3001\u9b54\u6cd5\u3082\u3001\u3042\u308b\u3093\u3060\u3088\r\n*05*\u5f8c\u6094\u306a\u3093\u3066\u3001\u3042\u308b\u308f\u3051\u306a\u3044\r\n*06*\u3053\u3093\u306a\u306e\u7d76\u5bfe\u304a\u304b\u3057\u3044\u3088\r\n*07*\u672c\u5f53\u306e\u6c17\u6301\u3061\u3068\u5411\u304d\u5408\u3048\u307e\u3059\u304b\uff1f\r\n*08*\u3042\u305f\u3057\u3063\u3066\u3001\u307b\u3093\u3068\u30d0\u30ab\r\n*09*\u305d\u3093\u306a\u306e\u3001\u3042\u305f\u3057\u304c\u8a31\u3055\u306a\u3044\r\n*10*\u3082\u3046\u8ab0\u306b\u3082\u983c\u3089\u306a\u3044\r\n*11*\u6700\u5f8c\u306b\u6b8b\u3063\u305f\u9053\u3057\u308b\u3079\r\n*12*\u308f\u305f\u3057\u306e\u3001\u6700\u9ad8\u306e\u53cb\u9054"}}}

@@ json_pid
{"Programs":{"180784":{"PID":"180784","TID":"2077","ChID":"48","ChName":"MBS\u6bce\u65e5\u653e\u9001","ChEPGURL":"http:\/\/www.mbs.jp\/timetable\/","Count":"12","StTime":"1303409400","EdTime":"1303411200","SubTitle2":"","ProgComment":"!2\u8a71\u9023\u7d9a\u653e\u9001 http:\/\/www.madoka-magica.com\/news\/index.html#n218554","ConfFlag":null}}}

@@ search_tiny
{"Titles":{"2077":{"TID":"2077","Title":"\u9b54\u6cd5\u5c11\u5973\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","ShortTitle":"\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","TitleYomi":"\u307e\u307b\u3046\u3057\u3087\u3046\u3058\u3087\u307e\u3069\u304b\u307e\u304e\u304b","TitleEN":"PUELLA MAGI MADOKA MAGICA","Cat":"10","FirstCh":"MBS","FirstYear":"2011","FirstMonth":"1","FirstEndYear":"2011","FirstEndMonth":"4","TitleFlag":"0","Comment":"","Search":2,"Programs":[{"PID":"275192","TID":"2077","StTime":"1389186000","EdTime":"1389187800","ChID":"21","StOffset":"0","Count":"11","ProgComment":"","SubTitle":"","ChName":"\u30a2\u30cb\u30de\u30c3\u30af\u30b9"},{"PID":"275193","TID":"2077","StTime":"1389790800","EdTime":"1389792600","ChID":"21","StOffset":"0","Count":"12","ProgComment":"","SubTitle":"","ChName":"\u30a2\u30cb\u30de\u30c3\u30af\u30b9"}]},"3216":{"TID":"3216","Title":"\u5287\u5834\u7248 \u9b54\u6cd5\u5c11\u5973\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","ShortTitle":"\u5287\u5834\u7248 \u307e\u3069\u304b\u2606\u30de\u30ae\u30ab","TitleYomi":"\u3052\u304d\u3058\u3087\u3046\u3070\u3093\u307e\u307b\u3046\u3057\u3087\u3046\u3058\u3087\u307e\u3069\u304b\u307e\u304e\u304b","TitleEN":"PUELLA MAGI MADOKA MAGICA","Cat":"8","FirstCh":"","FirstYear":"2012","FirstMonth":"10","FirstEndYear":null,"FirstEndMonth":null,"TitleFlag":"0","Comment":"","Search":1},"3219":{"TID":"3219","Title":"\u3072\u3060\u307e\u308a\u30b9\u30b1\u30c3\u30c1 \u6c99\u82f1\u30fb\u30d2\u30ed \u5352\u696d\u7de8","ShortTitle":"","TitleYomi":"\u3072\u3060\u307e\u308a\u3059\u3051\u3063\u3061\u3055\u3048\u3072\u308d\u305d\u3064\u304e\u3087\u3046\u3078\u3093","TitleEN":"Hidamari Sketch","Cat":"7","FirstCh":"","FirstYear":"2013","FirstMonth":"11","FirstEndYear":"2013","FirstEndMonth":"11","TitleFlag":"0","Comment":"-2013\u5e7410\u670825\u65e5\u306b\u6620\u753b\u9928\u3067\u6700\u901f\u4e0a\u6620\u4f1a\u3092\u5b9f\u65bd\u3001\u540c\u6642\u4e0a\u6620\u306f\u300c\u30b3\u30bc\u30c3\u30c8\u306e\u8096\u50cf\u300d\u300c\u5287\u5834\u7248 \u9b54\u6cd5\u5c11\u5973\u307e\u3069\u304b\u2606\u30de\u30ae\u30ab[\u65b0\u7de8]\u53db\u9006\u306e\u7269\u8a9e\u300d\r","Search":0}}}

