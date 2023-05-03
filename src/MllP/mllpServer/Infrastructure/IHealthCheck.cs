namespace mllpServer.Infrastructure;

public interface IHealthCheck
{
    Task ExecuteAsync(CancellationToken cancellationToken);

    void Stop();
}