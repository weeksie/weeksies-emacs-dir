# -*- coding: iso-8859-1 -*->
# ruby2draftTeX
# Copyright Ruby Dos Zapatas 2004
# Ruby releases this file under the 
# GNU GPL license. See COPYING.
#
# created: March 27, 2004
#

import os, string, sys

CHAR = {
	"�":"\\'a",
	"�":"\\'e",
	"�":"\\'i",
	"�":"\\'o",
	"�":"\\'u",
	"�":"\\'A",
	"�":"\\'E",
	"�":"\\'I",
	"�":"\\'O",
	"�":"\\'U",
	"�":"\\~N",
	"�":"\\~n",
	"�":"?`",
	"�":"!`",
	}

HEAD = '''%% Created by Ruby\'s ruby2draftTeX - http://python.org/pypi/ruby2shoes

\\tolerance = 10000
\\hbadness = 10000
\\baselineskip = 9 pt
\\font\\df = cmtt8
\\df
\\hoffset = 0.0 in
\\hsize = 6.5 in
\\voffset = 0.25 in
\\vsize = 9.0 in

'''

NI = "\\noindent\n"
BS = "\\bigskip\n"
MS = "\\medskip\n"
SS = "\\smallskip\n"
BYE = "\\bye\n"

ELEMENTS = [
	"Title: ",
	"Author(s): ",
	"Copyright: ",
	"Part: ",
	"chapter: ",
	"section: ",
	"subsection: ",
	"::"
	]

BEFORE = {
	"Title: ":BS + NI,
	"Author(s): ":MS + NI,
	"Copyright: ":SS + NI + "Copyright: ",
	"Part: ":BS + NI + "-- ",
	"chapter: ":MS + NI,
	"section: ":SS + NI,
	"subsection: ":SS + NI,
	"::":SS + NI + "::",
	}

AFTER = {
	"Title: ":BS,
	"Author(s): ":SS,
	"Copyright: ":MS,
	"Part: ":"--" + BS,
	"chapter: ":MS,
	"section: ":SS,
	"subsection: ":"",
	"::":SS,
	}

class ruby2draftTeX:

	def tex_chars(self, name,tex):
		f = open(name)
		g = open(tex,'w')
		keys = CHAR.keys()
		c = f.read(1)
		while (c != ""):
			if (c in keys):
				g.write(CHAR[c])
			else:
				g.write(c)
			c = f.read(1)
		g.close()
		f.close()
		return

	def tex_lines(self, tex):
		f = open(tex)
		lines = f.readlines()
		f.close()
		f = open(tex,'w')
		f.write(HEAD)
		for line in lines:
			for element in ELEMENTS:
				if (string.find(line,element) == 0):
					line = string.replace(line,element,"")
					f.write(BEFORE[element])
					f.write(line)
					f.write(AFTER[element])
					break
			else:
				f.write(line)
		f.write(BYE)
		f.close()
		return

	def convert(self, name):
		sys.stdout.write(name)
		tex = string.replace(name, "txt", "tex")
		self.tex_chars(name,tex)
		self.tex_lines(tex)
		print " converted to "+tex
		return
