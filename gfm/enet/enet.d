module gfm.enet.enet;

import std.conv,
       std.string;

import derelict.enet.enet,
       derelict.util.exception;

import gfm.core.log,
       gfm.enet.host;

class ENetException : Exception
{
    public
    {
        this(string msg)
        {
            super(msg);
        }
    }
}

// library wrapper
final class ENet
{
    public
    {
        this(Log log)
        {
            _log = log is null ? new NullLog() : log;

            try
            {
                DerelictENet.load();
            }
            catch(DerelictException e)
            {
                throw new ENetException(e.msg);
            }

            int errCode = enet_initialize();

            if (errCode < 0)
                throw new ENetException("enet_initialize failed");

            _libInitialized = true;

            ENetVersion ver = enet_linked_version();

            int majorVersion = ENET_VERSION_GET_MAJOR(ver);
            int minorVersion = ENET_VERSION_GET_MINOR(ver);
            int patchVersion = ENET_VERSION_GET_PATCH(ver);

            _log.infof("ENet v%s.%s.%s initialized.", majorVersion, minorVersion, patchVersion);
        }

        ~this()
        {
            close();
        }

        void close()
        {
            if (_libInitialized)
            {
                enet_deinitialize();
                _libInitialized = false;
            }
        }

        // Create a server
        Host createServer(ushort port, int peerCount)
        {
            ENetAddress address;
            address.port = port;
            address.host = ENET_HOST_ANY;
            return new Host(this, &address, peerCount, 0, 0, 0);
        }
        
        // Create a client
        Host createClient(int peerCount) 
        {
            return new Host(this, null, peerCount, 0, 0, 0);
        }

        // try to resolve host address
        bool resolveHost(string hostName, out uint host)
        {
            ENetAddress address;
            int errCode = enet_address_set_host(&address, toStringz(hostName));
            if (errCode == 0)
            {
                host = address.host;
                return true;
            }
            else
                return false;
        }
    }

    package
    {
        Log _log;
    }

    private
    {
        bool _libInitialized;
    }
}
