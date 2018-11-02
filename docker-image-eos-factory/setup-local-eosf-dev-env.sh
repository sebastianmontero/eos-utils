sudo chmod a+rx /var/lib/docker/
sudo chmod a+rx /var/lib/docker/volumes
sudo chmod -R a+w /var/lib/docker/volumes/docker-image-eos-factory_eosfactory/_data/eosfactory.egg-info/
conda env create -f eosf-conda-env.yml
source activate eosf
pip install -e /var/lib/docker/volumes/docker-image-eos-factory_eosfactory/_data
source deactivate
