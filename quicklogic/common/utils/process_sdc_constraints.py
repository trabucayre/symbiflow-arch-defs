#!/usr/bin/env python3
"""
This script processes an SDC constraint file and replaces all references to
pin names in place of net names with actual net names that are mapped to those
pins. Pin-to-net mapping is read from a PCF constraint file.

Note that this script does not check whether the net names in the input PCF
file are actually present in a design and whether the pin names are valid.
"""
import argparse
import re

from lib.parse_pcf import parse_simple_pcf

# =============================================================================


def process_get_ports(match, pad_to_net):
    """
    Used as a callback in re.sub(). Responsible for substition of net names
    for pin names.
    """

    # Strip any spurious whitespace chars
    arg = match.group("arg").strip()

    # A helper mapping func.
    def map_pad_to_net(pad):
        assert pad in pad_to_net, \
            "The pin '{}' is not associated with any net".format(pad)
        net = pad_to_net[pad].net

        # Escape square brackets
        net = net.replace("[", "\\[")
        net = net.replace("]", "\\]")
        return net

    # We have a list of ports, map each of them individually
    if arg[0] == "{" and arg[-1] == "}":
        arg = arg[1:-1].split()
        nets = ", ".join([map_pad_to_net(p) for p in arg])
        new_arg = "{{{}}}".format(nets)

    # We have a single port, map it directly
    else:
        new_arg = map_pad_to_net(arg)

    # Format the new statement
    return "[get_ports {}]".format(new_arg)


def main():

    # Parse arguments
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        "--sdc-in", type=str, required=True, help="Input SDC file"
    )
    parser.add_argument(
        "--pcf", type=str, required=True, help="Input PCF file"
    )
    parser.add_argument(
        "--sdc-out", type=str, required=True, help="Output SDC file"
    )

    args = parser.parse_args()

    # Read the input PCF file
    with open(args.pcf, "r") as fp:
        pcf_constraints = list(parse_simple_pcf(fp))

    # Build a pad-to-net map
    pad_to_net = {}
    for constr in pcf_constraints:
        assert constr.pad not in pad_to_net, \
            "Multiple nets constrained to pin '{}'".format(constr.pad)
        pad_to_net[constr.pad] = constr

    # Read the input SDC file
    with open(args.sdc_in, "r") as fp:
        sdc = fp.read()

    # Process the SDC
    def sub_cb(match):
        return process_get_ports(match, pad_to_net)

    sdc = re.sub(r"\[\s*get_ports\s+(?P<arg>.*)\]", sub_cb, sdc)

    # Write the output SDC file
    with open(args.sdc_out, "w") as fp:
        fp.write(sdc)


# =============================================================================

if __name__ == "__main__":
    main()
