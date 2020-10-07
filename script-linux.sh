set -e -o pipefail
shopt -s failglob
export LC_ALL=C

pip3 install wheel
pip3 install conan --upgrade
pip3 install conan_package_tools bincrafters_package_tools
conan user
conan remote add altairwei https://api.bintray.com/conan/altairwei/conan --insert

if [[ "$TRAVIS_PYTHON_VERSION" == "2.7" ]]; then
  wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh;
else
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
fi
bash miniconda.sh -b -p $HOME/miniconda
source "$HOME/miniconda/etc/profile.d/conda.sh"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda info -a
conda init bash
source $HOME/.bashrc
conda create -y -n build-v8 python=2.7
conda activate build-v8

git clone https://github.com/altairwei/conan-v8.git
cd conan-v8
conan create . altairwei/testing

