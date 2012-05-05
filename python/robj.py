__module_name__ = "clementine-np"
__module_version__ = "1.0"
__module_description__ = "Get song information from Clementine"
from dbus import Bus, DBusException
import xchat
bus = Bus(Bus.TYPE_SESSION)
def get_clem():
    try:
        return bus.get_object('org.mpris.clementine', '/Player')
    except DBusException:
        print "\x02Either Clementine is not running or you have something wrong with your D-Bus setup."
        return None

def command_np(word, word_eol, userdata):
    clem = get_clem()
#    clemtl = bus.get_object('org.mpris.clementine', '/TrackList')
#    clemgl = clemtl.GetLength()
    clemp = bus.get_object('org.mpris.clementine', '/Player')
    clemmd = clemp.GetMetadata()
    if clem:
        pos = clem.PositionGet()
        xchat.command("say HD Audio Output: " + unicode(clemmd['title']).encode('utf-8') + " by " + unicode(clemmd['artist']).encode('utf-8'))
    return xchat.EAT_ALL

xchat.hook_command("NP",    command_np,                 help="Shows current song.")
print "clementine-np plugin loaded"
