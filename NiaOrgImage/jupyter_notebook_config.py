# Distributed under the terms of the Modified BSD License.

from jupyter_core.paths import jupyter_data_dir

c = get_config()

c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.enable_mathjax = True
# https://github.com/jupyter/notebook/issues/3130
c.FileContentsManager.delete_to_trash = False
