using System.Net;
using System.Net.Sockets;
using System.Text;

try
{
    var tcpListener = new TcpListener(IPAddress.Any, 1080);
    tcpListener.Start();
    Console.WriteLine("Server started");
    // TcpClient acceptedClient = null;
    // NetworkStream networkStream = null;

    while (true)
    {
        if (tcpListener.Pending())
        {
            Console.WriteLine("Listener pending");
            await HandleClient(await tcpListener.AcceptTcpClientAsync());
        }            
        else
        {
            Console.WriteLine("Listener not pending");
            await Task.Delay(100); //<--- timeout
        }
            
            



        // Console.WriteLine("Waiting for client to connect...");

        // acceptedClient = await tcpListener.AcceptTcpClientAsync(); // Get client connection
        // networkStream = acceptedClient.GetStream(); // Get client stream

        // Console.WriteLine("Client connected");
    }

}
catch (System.Exception ex)
{
    Console.WriteLine(ex.Message);
    throw;    
}

 async Task HandleClient(TcpClient clt)
{
    Console.WriteLine("Client connected");

    using NetworkStream ns = clt.GetStream();
    using StreamReader sr = new StreamReader(ns);
    string msg = await sr.ReadToEndAsync();

    Console.WriteLine($"Received new message ({msg.Length} bytes):\n{msg}");
}
