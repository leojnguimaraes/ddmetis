# DDMETIS: Domain Decompositian using Metis

## Pré-requisitos:
- Instalar o intel fortran (oneAPI):
[Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?operatingsystem=linux&distributions=aptpackagemanager)
[HPC Toolkit (opcional)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?operatingsystem=linux&distributions=aptpackagemanager)
- Instalar a biblioteca fmetis (para compilador ifx, ver nas instruções): 
[Biblioteca fmetis](https://github.com/ivan-pi/fmetis)
- Instalar ctags:
```
sudo apt-get -y install exuberant-ctags
```

## Instalação:

- Editar o arquivo Makefile e indicar na variável FMETISDIR onde se instalou a biblioteca fmetis
- No diretório raiz do projeto ddmetis, dar o comando:
```
make
```


## Próximos passos:
- Leitura dos modelo a ser particionado pelo ddmetis.dat
- Colocar as subrotinas chamadas pelo main.f90 em um módulo
- Alocar dinamicamente os vetores e matrizes
- Cuidado, dimensões diferentes nas declarações das subrrotinas
