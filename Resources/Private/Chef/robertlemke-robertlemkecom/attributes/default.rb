default['typo3-singlesignon']['demoinstance']['repository'] = "https://github.com/chlu/TYPO3.SingleSignOn.DemoInstance-Distribution.git"
default['typo3-singlesignon']['demoinstance']['revision'] = "629608e589721559b0f3fa7cfded94183dd40ee8"

default['typo3-singlesignon']['demoserver']['repository'] = "https://github.com/chlu/TYPO3.SingleSignOn.DemoServer-Distribution.git"
default['typo3-singlesignon']['demoserver']['revision'] = "b03481df0aff68d34afeb7a04ad16ee493b1503c"

# More lightweight apache setup for the demo
include_attribute "apache2"
node.set['apache']['prefork']['startservers'] = 2
node.set['apache']['prefork']['minspareservers'] = 3
node.set['apache']['prefork']['maxspareservers'] = 3
node.set['apache']['prefork']['serverlimit'] = 75
node.set['apache']['prefork']['maxclients'] = 75

# More lightweight mysql setup for the demo
include_attribute "mysql::server"
node.set['mysql']['tunable']['key_buffer'] = "32M"
node.set['mysql']['tunable']['max_heap_table_size'] = "16M"
node.set['mysql']['tunable']['innodb_buffer_pool_size'] = "32M"
node.set['mysql']['tunable']['innodb_additional_mem_pool_size'] = "1M"
node.set['mysql']['tunable']['query_cache_size'] = "4M"
