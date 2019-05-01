"""Print wireless state. Interface is designed to mimic options passed to
the Wireless plugin for Xmobar. """


from __future__ import print_function

# constant for now - it seems to always be in the same location
_IWCONFIG_BINARY = "/sbin/iwconfig"


class IWConfigNotFoundError():
    pass


if __name__ == "__main__":
    import argparse
    
    # Initialize arg parser. Note since we override -h, add_help must be false
    p = argparse.ArgumentParser(description='Print wireless status for xmobar',
                                add_help=False)
    p.add_argument('-t', '--template',
                   default="<essid>:<quality>", type=str, metavar='str',
                   help=('Set template for output. Template definition is a '
                         'subset of the standard xmobarr Wireless plugin. '
                         'Allowed values: essid, quality, qualitybar, '
                         'qualityvbar, qualityipat'))
    p.add_argument('-H', '--High', default=66, type=int, metavar='number',
                   help=('The high threshold. Values higher than number will '
                         'be displayed with the color specified by -h'))
    p.add_argument('-L', '--Low', default=33, type=int, metavar='number',
                   help=('The low threshold. Values lower than number will '
                         'be displayed with the color specified by -l'))
    p.add_argument('-h', '--high', default=None, metavar='color',
                   help='Color for showing values over the high threshold.')
    p.add_argument('-n', '--normal', default=None, metavar='color',
                   help=('Color for showing values greater than the low '
                        'threshold but lower than the high one.'))
    p.add_argument('-l', '--low', default=None, metavar='color',
                   help='Color for showing values below the low threshold.')
    p.add_argument('-S', '--suffix', default=False, action='store_true',
                   help='When true show optional suffixes such as % or units')
    # not implemented: -p --ppad
    # not implemented: -d --ddigits
    # not implemented: -m --minwidth
    # not implemented: -M --maxwidth
    # not implemented: -e --maxwidthellipsis
    # not implemented: -w --width
    # not implemented: -T --maxtwidth
    # not implemented: -E --maxtwidthellipsis
    # not implemented: -c --padchars
    # not implemented: -a --align
    # not implemented: -b --bback
    # not implemented: -f --bfore
    # not implemented: -W --bwidth
    # not implemented: -x --nastring
    p.add_argument('--quality-icon-pattern',
                   help=('Dynamic string for connection quality in '
                         'qualityipat. Not currently implemented.'))
    # Add explicit --help arg, since -h arg is disabled.
    # TODO: figure out why this does not work
    #p.add_argument('--help', action='help', help='show this help message and exit')
    args = p.parse_args()
    
    print('parsed args:')
    print(args)


