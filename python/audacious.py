__module_name__ = "Audacious Shout"
__module_version__ = "1.2"
__module_description__ = "Script that binds /audacious to show currently playing information using audtool."
__module_author__ = "firesock serwalek"

#Sorted for Aud2 compat

import xchat
#*nix specific module, doesn't matter, audacious is *nix specific anyway. (I think)
import commands

audtool_prog = "audtool2"
audtool_alternative = "audtool"
prog_check = "which"
bold_char = '\002'

#does audtool exist
def audacious_check():
     global audtool_prog, prog_check, audtool_alternative
     exists = commands.getstatusoutput(prog_check + " " + audtool_prog)
     if (exists[0] == 0):
         return True
     #check for aud 1
     exists = commands.getstatusoutput(prog_check + " " + audtool_alternative)
     if (exists[0] == 0):
         audtool_prog = audtool_alternative
         return True
     return False

#perform shout
def shout(word, word_eol, userdata):
     global bold_char, audtool_prog
     current = xchat.get_context()
     if audacious_check():
     #playing?
         playing = commands.getstatusoutput(audtool_prog + " playback-playing")
         if (playing[0] == 0):
             song = commands.getoutput(audtool_prog + " current-song")
             artist = commands.getoutput(audtool_prog + " current-song-tuple-data artist")

             total = commands.getoutput(audtool_prog + " current-song-length")
             output = commands.getoutput(audtool_prog + " current-song-output-length")
             final = bold_char + "Now Playing: " + bold_char + song + (" - ") + artist + " (" + output + "/" + total + ")"
             #make sure it's not in a server window
             if ((current.get_info("channel") != current.get_info("server")) and (current.get_info("channel") != current.get_info("network"))):
                 #Say it.
                 xchat.command("msg " + current.get_info("channel") + " " + final)
             else:
                 #Print it
                 current.prnt(final)
         else:
             current.prnt("Check that Audacious is playing!")
     else:
         current.prnt("Check that you have Audacious installed and audtool_prog set properly!")
     #accept the command no matter what happens, to prevent unknown command messages
     return xchat.EAT_XCHAT

if audacious_check():
     xchat.hook_command("audacious", shout, help="/audacious - Sends currently playing information to current context.")
     xchat.prnt("Audacious Shout plugin loaded!")
else:
     xchat.prnt("Please check that Audacious is installed and audtool_prog is set properly. Plugin not loaded!")
