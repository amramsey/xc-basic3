module compiler.petscii;

import std.string, std.conv, std.array, std.algorithm.searching;
import std.regex;

private char[] petscii = [
    0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    ' ', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/',
    '0', '1', '2', '3', '4', '5', '6', '7' , '8', '9', ':', ';', '<', '=', '>', '?',
    '@', 'a', 'b', 'c', 'd', 'e', 'f', 'g' , 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w' , 'x', 'y', 'z', '[', '\x5c', ']', '\x5e', '\x5f',
    0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x8f,
    0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
    0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
    0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
    0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
    0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,  
    '\xc0', 'A', 'B', 'C', 'D', 'E', 'F', 'G' , 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W' , 'X', 'Y', 'Z', '\xdb', '\xdc', '\xdd', '\xde', '\xdf',
    0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,  
    0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff
];

private string[string] escapeSequences;

static this()
{
    escapeSequences = [
    "{CLR}":        "\x93",
    "{CLEAR}":      "\x93",
    "{HOME}":       "\x13",
    "{INSERT}":     "\x94",
    "{INS}":        "\x94",
    "{DELETE}":     "\x14",
    "{DEL}":        "\x14",
    "{CR}":         "\x0d",
    "{RETURN}":     "\x0d",
    "{REV_ON}":     "\x12",
    "{REVERSE ON}": "\x12",
    "{REV_OFF}":    "\x92",
    "{REVERSE OFF}":"\x92",
    "{CRSR_UP}":    "\x91",
    "{UP}":         "\x91",
    "{CRSR_DOWN}":  "\x11",
    "{DOWN}":       "\x11",
    "{CRSR_LEFT}":  "\x9d",
    "{LEFT}":       "\x9d",
    "{CRSR_RIGHT}": "\x1d",
    "{RIGHT}":      "\x1d",
    "{SPACE}":      "\x20",
    "{WHITE}":      "\x05",
    "{RED}":        "\x1c",
    "{GREEN}":      "\x1e",
    "{BLUE}":       "\x1f",
    "{ORANGE}":     "\x81",
    "{BLACK}":      "\x90",
    "{BROWN}":      "\x95",
    "{LIGHT_RED}":  "\x96",
    "{PINK}":       "\x96",
    "{DARK_GRAY}":  "\x97",
    "{DARK GRAY}":  "\x97",
    "{MED_GRAY}":   "\x98",
    "{GRAY}":       "\x98",
    "{LIGHT_GREEN}":"\x99",
    "{LIGHT GREEN}":"\x99",
    "{LIGHT_BLUE}": "\x9a",
    "{LIGHT BLUE}": "\x9a",
    "{LIGHT_GRAY}": "\x9b",
    "{LIGHT GRAY}": "\x9b",
    "{PURPLE}":     "\x9c",
    "{YELLOW}":     "\x9e",
    "{CYAN}":       "\x9f",
    "{LOWER_CASE}": "\x0e",
    "{UPPER_CASE}": "\x8e",
    "{F1}":         "\x85",
    "{F2}":         "\x86",
    "{F3}":         "\x87",
    "{F4}":         "\x88",
    "{F5}":         "\x89",
    "{F6}":         "\x8a",
    "{F7}":         "\x8b",
    "{F8}":         "\x8c",
    "{POUND}":      "\x5c",
    "{ARROW UP}":   "\x5e",
    "{ARROW_UP}":   "\x5e",
    "{ARROW LEFT}": "\x5f",
    "{ARROW_LEFT}": "\x5f",
    "{PI}":         "\xff"
    ];
}

private ubyte asciiToPetscii(char asciiChar)
{
    return to!ubyte(indexOf(petscii, asciiChar));
}

private char[] replacePetsciiEscapes(string s)
{
    string ret = s.dup;
    foreach(key, value; escapeSequences) {
        ret = replace(ret, key, value);
    }
    return ret.dup;
}

private char[] replaceNumericEscapes(char[] s) {
    char[] r;
    bool esc = false;
    string num = "";
    for (ubyte i = 0; i < s.length; i++) {
        if(!esc && s[i] != '{' && s[i] != '}') {
            r ~= s[i];
        }
        else if(s[i] == '{') {
            esc = true;
        }
        else if(s[i] == '}') {
            r ~= to!ubyte(num);
            esc = false;
            num = "";
        }
        else {
            num = num ~ to!string(s[i]);
        }
    }
    
    return r;
}

/** Translates ASCII string to PETSCII HEX series */
string asciiToPetsciiHex(string asciiString, bool newline = true)
{
    char[] asciiRepl = replaceNumericEscapes(replacePetsciiEscapes(asciiString));
    immutable ulong length = asciiRepl.length + (newline ? 1 : 0);
    string hex = "HEX " ~ rightJustify(to!string(length, 16), 2, '0') ~ " ";

    int counter = 0;
    for(ubyte i = 0; i < asciiRepl.length; i++) {
        hex ~= rightJustify(to!string(asciiToPetscii(asciiRepl[i]), 16), 2, '0') ~ " ";
        counter++;
        if(counter == 16 && (i + 1 < asciiRepl.length)) {
            hex ~= "\n\tHEX ";
            counter = 0;
        }
    }

    if(newline) {
        hex ~= "0D ";
    }
    
    return hex;
}
/*
string ascii_to_screencode_hex(string asciiString)
{
    string hex = "HEX ";
    int counter=0;
    for(ubyte i=0; i<asciiS
tring.length; i++) {
        hex ~= rightJustify(to!string(petscii_to_screencode(ascii_to_petscii(asciiS
    tring[i])), 16), 2, '0') ~ " ";
        counter++;
        if(counter == 16 && i < asciiS
    tring.length-1) {
            hex ~= "\n\tHEX ";
            counter = 0;
        }
    }
    hex ~= "00";
    return hex;
}

int petscii_to_screencode(ubyte petscii_code)
{
    if(petscii_code < 32) {
        return petscii_code + 128;
    }

    if(petscii_code < 64) {
        return petscii_code;
    }

    if(petscii_code < 96) {
        return petscii_code - 64;
    }

    if(petscii_code < 128) {
        return petscii_code - 32;
    }

    if(petscii_code < 160) {
        return petscii_code + 64;
    }

    if(petscii_code < 192) {
        return petscii_code - 64;
    }

    if(petscii_code < 255) {
        return petscii_code - 128;
    }

    return petscii_code - 94;
}
*/