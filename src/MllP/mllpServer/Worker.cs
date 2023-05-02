namespace mllpServer;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly IMllpServer _mlpServer;

    public Worker(ILogger<Worker> logger, IMllpServer mllpServer)
    {
        _logger = logger;
        mllpServer.Initialize();
        _mlpServer = mllpServer;        
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Starting MLLP Server");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await _mlpServer.WaitingForClientAsync();    
            }
            catch (System.Exception ex)
            {                
                _logger.LogError("Error in ExecyuteAsync");
                _logger.LogError(ex.Message);
                await StopAsync(stoppingToken);
            }
            
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Stopping MLLP Server");
        _mlpServer.Stop();
        return base.StopAsync(cancellationToken);
    }
}
