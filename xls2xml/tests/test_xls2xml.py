from datetime import date
from lxml import etree
from xls2xml import XLSReader
from xls2xml import utils

def test_validate_xls():
    validation_schema = '../EGA_policy_xlsx.schema'
    xls_reader = XLSReader('data/example_EGA_policy.V1.0.xlsx', '../EGA_policy_xlsx.conf')
    assert xls_reader.is_valid()
    assert utils.validate_file(xls_reader, validation_schema)

def test_xls2xml_DAC():
    xls_reader = XLSReader('data/example_EGA_policy.V1.0.xlsx', '../EGA_policy_xlsx.conf')
    conf_keys = ['DAC', 'Contact']
    xls_readers = [ (key, xls_reader) for key in conf_keys ]
    output_xml = utils.multiple_objects_to_xml(xls_readers, '../EGA_policy_xlsx.schema',
                                               '../EGA_policy_xls2xml.xslt')
    with open('data/example_EGA_DAC.xml', 'r') as dac_example:
        assert dac_example.readline()
        assert etree.tostring(output_xml, pretty_print=True) == dac_example.read()

def test_xls2xml_policy():
    xls_reader = XLSReader('data/example_EGA_policy.V1.0.xlsx', '../EGA_policy_xlsx.conf')
    conf_keys = ['Policy', 'DUO']
    xls_readers = [ (key, xls_reader) for key in conf_keys ]
    output_xml = utils.multiple_objects_to_xml(xls_readers, '../EGA_policy_xlsx.schema',
                                               '../EGA_policy_xls2xml.xslt')
    today = date.today().isoformat()
    date20180921 = "2018-09-21"
    with open('data/example_EGA_policy.xml', 'r') as policy_example:
        assert policy_example.readline()
        assert etree.tostring(output_xml, pretty_print=True) ==\
               policy_example.read().replace(date20180921, today)
