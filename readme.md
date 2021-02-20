# （***Local使用が前提の***）Jupyterlab3.xの動作するDockerイメージができます。
python3.8のブラウザIDEが動作します。
仮想通貨の分析用のライブラリをいれてあります。  
私の環境では、30分程度でbuildされました。  
回線が遅い場合や、ダウンロードするイメージサーバーがダウンしているとエラーがでます。
環境を変えるか、時間をおいてbiuildしてください。  

***初回起動は、そこそこ時間がかかります。***

***build後***は、
```shell
docker-compose up -d
```
にて、すみやかに起動します。

***初期ユーザー***  
jovyan  
***ｐｗ***  
hirake  
なおsudoがｐｗなしで使用可能（Local使用が前提）  


## 必要な設定は一カ所　！！
docker-entrypoint.sh を編集してください。
ローカルとコンテナと同期させるために必要です。

①自身のPCで、コマンドidを実行
user id (UID)
group id (GID)
二つのID番号をメモ。

②docker-entrypoint.shを書き換える
```shell
#------------- ここを編集 -------------
#自身のPCでのUSER IDを設定。（win ubuntu は、1000：1000）
#調べるには、自身のPCで、コマンド $ idで、確認
USER_ID=1000
GROUP_ID=1000
#------------- ここを編集 ------------
```

③一回、イメージのビルド
```shell
docker-compose build --no-cache
最後まで、うまく通れば、Ctrl-C を二回で、終了可能。
```

## なおローカルのhome_jovyanが、共有dirに設定されています。
home_jovyanに、ローカル環境とドッカー環境の共有ディレクトリになります。
このディレクトリは、永続化されています。

## 使い方
### 起動は、***docker-compose.ymlのあるディレクトリで***、コマンドを実行
```shell
docker-compose up -d
```
***初回起動はそこそこ時間がかかります。***  
  
終了は、
```shell
docker-compose down
```
### 起動後にブラウザ上で、開発環境が使えます。
ブラウザでアクセス  
```shell
http://127.0.0.1:8888/
```

pythonのライブラリのインストールは、***Jupyterlab上のcell***では、！をつけて、  
```shell
!pip install hogehoge
```
できます。  

### ドッカー環境に入るには、
-デフォルトユーザーではいる方法  
***docker-compose.ymlのあるディレクトリで***  
```shell
docker-compose exec -u jovyan jupyterlab bash
```

-rootで入る方法  
***docker-compose.ymlのあるディレクトリで***  
```shell
docker-compose exec -u root jupyterlab bash
```

### ローカルのコマンドラインから、コンテナでの命令実行する方法
たとえば、ユーザーjovyanで、ホームに、hoge.txtの空ファイルを作るには  
***docker-compose.ymlのあるディレクトリで***  
```shell
docker-compose exec -u jovyan jupyterlab /bin/bash -c "touch /home/jovyan/hoge.txt"
```

## デバッグはptvsdをいれてあります
vscode 設定　検討中。下記で仮動作はするかと。  

launch.json 例  
```shell
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
    
        {
            "name": "Python: Attach",
            "type": "python",
            "request": "attach",
            "port": 5678,
            "host": "localhost",            
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}", 
                    "remoteRoot": "/home/jovyan"
                }
            ],
        }
    ]
}
```


# アンインストール；ドッカーイメージを削除するなら
```shell
docker-compose down --rmi all --volumes --remove-orphans
```
を実行して、ディレクトリを削除で、きれいになります。


## 追加
必要なときのみ、使用してください。  
afterbuild.shに、コンテナの外から、コンテナ内にインストール／設定を追加。  
```shell
chmod +x afterbuild.sh
```
して、実行。  
done がでるまで、待つ。開始されるまで。そこそこ時間かかります。  

