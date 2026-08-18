# -*- coding: utf-8 -*-

import sys

from com.pnfsoftware.jeb.client import HeadlessClientContext
from com.pnfsoftware.jeb.client.mcp import JebMcpServerInstance
from java.lang import String
from java.util.concurrent import CountDownLatch
from jarray import array


host = 'localhost'
port = int(sys.argv[1]) if len(sys.argv) > 1 else 8425
ctx = HeadlessClientContext()
server = None
try:
  ctx.initialize(array([], String))
  ctx.start()
  server = JebMcpServerInstance.start(host, port, '/mcp')
  if server is None or server.getPort() != port:
    raise RuntimeError('JEB MCP could not bind %s:%d' % (host, port))
  print('JEB_MCP_READY:%s:%d%s' % (server.getHostname(), server.getPort(), server.getEndpoint()))
  getattr(CountDownLatch(1), 'await')()
finally:
  if server is not None:
    JebMcpServerInstance.stop()
  ctx.stop()
