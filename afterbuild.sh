#!/bin/sh


#必要なときに利用のこと。必須ではありません。

#jupyterlab拡張をインストール
docker-compose exec -u root jupyterlab /bin/bash -c "jupyter labextension install @lckr/jupyterlab_variableinspector"
docker-compose exec -u root jupyterlab /bin/bash -c "jupyter labextension install @arbennett/base16-monokai"

#jupytextを有効化
#注意！　二重に登録すると動きません（シェルを二回走らせると）
arg='"ipynb,py"'

docker-compose exec -u jovyan jupyterlab /bin/bash -c "touch /home/jovyan/.jupyter/jupyter_notebook_config.py"
docker-compose exec -u jovyan jupyterlab /bin/bash -c "echo 'c.ContentsManager.default_jupytext_formats = $arg' >> /home/jovyan/.jupyter/jupyter_notebook_config.py"

#テーマの有効化
theme_name='"theme": "JupyterLab Dark"'

docker-compose exec -u jovyan jupyterlab /bin/bash -c "mkdir -p /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension"
docker-compose exec -u jovyan jupyterlab /bin/bash -c "touch /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings"
docker-compose exec -u jovyan jupyterlab /bin/bash -c "echo '{$theme_name}' > /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings"

#イメージ再起動
docker-compose restart