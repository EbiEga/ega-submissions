EGA submission xls2xml conversion configuration
=====================

### What is This?
This directory contains configuration files for validating the EGA submission pack and converting the XLS spreadsheets to XML objects.

### Prerequisites
To play with these configuration files or use them for actually producing XML objects that are ready for submitting to the EGA, you will need to have the following repository checked out and install dependencies. 
```commandline
git clone https://github.com/EBIvariation/amp-t2d-submissions
git clone https://github.com/EbiEga/ega-submissions
cd amp-t2d-submissions/xls2xml
virtualenv -p python2.7 venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
```

### Running the Tests
```commandline
cd ega-submissions/xls2xml
source ../../amp-t2d-submissions/xls2xml/venv/bin/activate
cd tests/
pytest
deactivate
```

### Converting Submission XLS
You can validate the submission xlsx file and generate XML objects using the example commands as below.
```commandline
cd ega-submissions/xls2xml
source ../../amp-t2d-submissions/xls2xml/venv/bin/activate
# validating the submission xlsx file
python ../../amp-t2d-submissions/xls2xml/xls2xml/validate_xls.py --conf EGA_policy_xlsx.conf --schema EGA_policy_xlsx.schema tests/data/example_EGA_policy.V1.0.xlsx 
# generating EGA DAC xml
python ../../amp-t2d-submissions/xls2xml/xls2xml/xls2xml.py --conf EGA_policy_xlsx.conf --schema EGA_policy_xlsx.schema --conf-key DAC,Contact --xslt EGA_policy_xls2xml.xslt tests/data/example_EGA_policy.V1.0.xlsx  output_EGA_DAC.xml
# generating EGA policy xml
python ../../amp-t2d-submissions/xls2xml/xls2xml/xls2xml.py --conf EGA_policy_xlsx.conf --schema EGA_policy_xlsx.schema --conf-key Policy,DUO --xslt EGA_policy_xls2xml.xslt tests/data/example_EGA_policy.V1.0.xlsx  output_EGA_policy.xml
deactivate
```
After this, you will find the XML files are generated in output_*.xml

### Making change
You may need to make change to the configuration files so that they work for new requirements. You should find some references at the top of each configuration file. Please make sure you update the test cases as well so that the test cases still work.