# metaopendatatoronto

Notes and code exploring data about the Toronto Open Data portal

Will be using data from https://open.toronto.ca/dataset/catalogue-quality-scores/

Info from portal:


About Catalogue quality scores

The Data Quality Score reflects, in the form of a Gold, Silver or Bronze badge, how valuable a dataset is based on a set of characteristics that increase its potential to be used for addressing civic issues such as how usable, timely, complete, and well-described it is. High quality data enables high quality impact.

This dataset contains the current and historic Data Quality Score results for the Open Data Toronto catalogue, as well as the versions of the algorithm used for scoring.

Collection Method: Querying the Open Data Portal via the CKAN API.

Limitations
Data Quality Score applies only to resources in the CKAN datastore, which is a SQL database. Static files are not scored due to lack of standardization and inability to readily read the data. This means datasets containing only files, such as Excel or Zip, are not scored.
There is no distinction between "Read Me" and "data" resources. They are both assessed and weighted equally when calculating the final score.

