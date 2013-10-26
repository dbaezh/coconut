# These get replaced with the actual contents when we drush rsync @prod @dev
# places links back in place for easy github pulling to update. 
# 
sudo ln -s /home/bitnami/apps/coconut/form_tagger /home/bitnami/apps/drupal/htdocs/sites/all/modules/
sudo ln -s /home/bitnami/apps/coconut/module /home/bitnami/apps/drupal/htdocs/sites/all/modules/
