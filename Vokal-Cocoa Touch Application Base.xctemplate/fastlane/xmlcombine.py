#!/usr/bin/env python

from __future__ import division, print_function

import argparse
import xml.etree.ElementTree as ET
from sys import stdout, stderr

parser = argparse.ArgumentParser(description='Combine some Slather-generated cobertura-style XML.')
parser.add_argument('files', metavar='FILE', type=unicode, nargs='+', help='an XML file to combine')
parser.add_argument('--output-file', type=unicode, default=stdout, help='destination for combined XML')
parser.add_argument('--ignore-source', action='store_true', help='Ignore mismatched source elements')
args = parser.parse_args()

filenames = args.files
if len(filenames) == 0:
    parser.print_help()
    exit()

def update_coverage(el):
    lines = len(el.findall('.//line'))
    el.attrib['lines-valid'] = str(lines)
    misses = len(el.findall('.//line[@hits="0"]'))
    hits = lines - misses
    el.attrib['lines-covered'] = str(hits)
    el.attrib['line-rate'] = str(hits / lines)

print('Loading {}...'.format(filenames[0]), file=stderr)
tree = ET.parse(filenames[0])
root = tree.getroot()

for filename in filenames[1:]:
    print('Adding {}...'.format(filename), file=stderr)
    add_tree = ET.parse(filename)
    add_root = add_tree.getroot()
    if not args.ignore_source:
        source = root.find('.//source').text
        add_source = add_root.find('.//source').text
        if source != add_source:
            print('Source of this file ({}) does not match source of first file ({}).'.format(add_source, source), file=stderr)
    for package in add_root.iterfind('.//package'):
        #print(package.get('name'), file=stderr)
        package_xpath = 'packages/package[@name="{}"]'.format(package.get('name'))
        existing_package = root.find(package_xpath)
        if existing_package is None:
            #print('Adding a package...', file=stderr)
            packages = root.find('packages')
            if packages is None:
                packages = ET.SubElement(root, 'packages')
            existing_package = ET.SubElement(packages, 'package')
            existing_package.attrib['name'] = package.get('name')
        for class_node in package.iterfind('.//class'):
            #print('>', class_node.get('name'), file=stderr)
            class_xpath = '{}/classes/class[@name="{}"][@filename="{}"]'.format(package_xpath, class_node.get('name'), class_node.get('filename'))
            existing_class = root.find(class_xpath)
            if existing_class is None:
                #print('Adding a class...', file=stderr)
                classes = existing_package.find('classes')
                if classes is None:
                    classes = ET.SubElement(existing_package, 'classes')
                existing_class = ET.SubElement(classes, 'class')
                existing_class.attrib['name'] = class_node.get('name')
                existing_class.attrib['filename'] = class_node.get('filename')
            for line in class_node.iterfind('.//line'):
                #print('>', '>', line.get('number'), file=stderr)
                if not line.get('number'):
                    #print('Line without a number? {} [{}]'.format(line, line.attrib), file=stderr)
                    exit()
                xpath = '{}/lines/line[@number="{}"]'.format(class_xpath, line.get('number'))
                # Look for line with matching XPath.
                existing_line = root.find(xpath)
                if existing_line is None:
                    #print('Adding a line...', file=stderr)
                    lines = existing_class.find('lines')
                    if lines is None:
                        lines = ET.SubElement(existing_class, 'lines')
                    existing_line = ET.SubElement(lines, 'line')
                    existing_line.attrib['hits'] = line.get('hits')
                # Add the hit count from the current line to the existing (or newly-created) node.
                hit_count = int(existing_line.get('hits', 0)) + int(line.get('hits', 0))
                existing_line.attrib['hits'] = str(hit_count)

map(update_coverage, root.iterfind('.//class'))
map(update_coverage, root.iterfind('.//package'))
update_coverage(root)

print('Writing to {}...'.format(args.output_file), file=stderr)
tree.write(args.output_file)

print('Done.', file=stderr)
