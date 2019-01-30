from datetime import date
from lxml import etree
from xls2xml import XLSReader
from xls2xml import utils

def test_validate_xls():
    validation_schema = '../EGA_policy_xlsx.schema'
    xls_reader = XLSReader('data/example_EGA_policy.V1.0.xlsx', '../EGA_policy_xlsx.conf')
    assert xls_reader.is_valid()
    assert utils.validate_file(xls_reader, validation_schema)

    validation_schema = '../EGA_submission_xlsx.schema'
    xls_reader = XLSReader('data/example_EGA_submission.V5.xlsx', '../EGA_submission_xlsx.conf')
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

def test_xls2xml_experiment():
    xls_reader = XLSReader('data/example_EGA_submission.V5.xlsx', '../EGA_submission_xlsx.conf')
    conf_keys = ['Experiment', 'Sample']
    xls_readers = [(key, xls_reader) for key in conf_keys]
    output_xml = utils.multiple_objects_to_xml(xls_readers, '../EGA_submission_xlsx.schema',
                                               '../EGA_experiment_xls2xml.xslt')
    with open('data/example_EGA_experiment.xml', 'r') as experiment_example:
        assert experiment_example.readline()
        assert etree.tostring(output_xml, pretty_print=True) == experiment_example.read()

def test_xls2xml_run():
    xls_reader = XLSReader('data/example_EGA_submission.V5.xlsx', '../EGA_submission_xlsx.conf')
    conf_keys = ['Run', 'File']
    xls_readers = [(key, xls_reader) for key in conf_keys]
    output_xml = utils.multiple_objects_to_xml(xls_readers, '../EGA_submission_xlsx.schema',
                                               '../EGA_run_xls2xml.xslt')
    with open('data/example_EGA_run.xml', 'r') as run_example:
        assert run_example.readline()
        assert etree.tostring(output_xml, pretty_print=True) == run_example.read()

def test_xls2xml_sample():
    xls_reader = XLSReader('data/example_EGA_submission.V5.xlsx', '../EGA_submission_xlsx.conf')
    conf_keys = ['Sample']
    xls_readers = [(key, xls_reader) for key in conf_keys]
    output_xml = utils.multiple_objects_to_xml(xls_readers, '../EGA_submission_xlsx.schema',
                                               '../EGA_sample_xls2xml.xslt')
    with open('data/example_EGA_sample.xml', 'r') as sample_example:
        assert sample_example.readline()
        assert etree.tostring(output_xml, pretty_print=True) == sample_example.read()
