namespace mllpServer.Infrastructure;

public class HealthCheckService<T> : BackgroundService where T : IHealthCheck
{
    private readonly ILogger<HealthCheckService<T>> _logger;
    private readonly T _healthCheck;

    public HealthCheckService(ILogger<HealthCheckService<T>> logger, T healthCheck)
    {
        _logger = logger;
        _healthCheck = healthCheck;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        try
        {
            _logger.LogInformation($"Starting HealthCheckService<{typeof(T).Name}>");
            while (!stoppingToken.IsCancellationRequested)
            {
                await _healthCheck.ExecuteAsync(stoppingToken);
            }
            
        }
        catch (System.Exception ex)
        {
            _logger.LogError(ex.Message);            
        }
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        try
        {
             _healthCheck.Stop();
             return Task.CompletedTask;
        }
        catch (System.Exception ex)
        {            
            _logger.LogError("Error in StopAsync HealthCheckService");
            _logger.LogError(ex.Message); 
        }

        return base.StopAsync(cancellationToken);
    }
}