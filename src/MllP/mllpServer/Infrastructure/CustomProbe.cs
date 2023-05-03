using System.Net;
using System.Net.Sockets;
using System.Text;

namespace mllpServer.Infrastructure;


public class CustomProbe : IHealthCheck
{
    private readonly ILogger<CustomProbe> _logger;
    private readonly TcpListener _tcpListener;

    private TcpClient _tcpClient;

    private NetworkStream _networkStream;

    public CustomProbe(ILogger<CustomProbe> logger)
    {
        _logger = logger;
            
        _tcpListener = new TcpListener(IPAddress.Any, 1200);

        _tcpListener.Start();
            
        _logger.LogInformation($"Custom probe listening on port 1200");        
    }

    public async Task ExecuteAsync(CancellationToken cancellationToken)
    {
        try
        {
            _tcpClient = await _tcpListener.AcceptTcpClientAsync();
            _logger.LogInformation("Client connected to custom probe");
            _networkStream = _tcpClient.GetStream();
            var response = Encoding.ASCII.GetBytes("ACK");
            await _networkStream.WriteAsync(response, 0, response.Length);
            _logger.LogInformation("Response sent custom probe");
            _tcpClient.Close();                                     
        }
        catch (System.Exception ex)
        {
            _logger.LogError(ex.Message);            
        }
        finally 
        {
            _networkStream?.Close();
            _networkStream?.Dispose();
            _tcpClient?.Close();
                    
        }
    }

    public void Stop()
    {
        try        
        {            
            if (_tcpListener != null)
                _tcpListener.Stop();

            _logger.LogInformation("Custom probe stopped");            
        }
        catch (System.Exception ex)
        {
            _logger.LogError(ex.Message);            
        }
    }
}
