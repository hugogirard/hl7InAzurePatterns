using mllpServer;
using TinyHealthCheck;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddSingleton<IMllpServer, MllpServer>();
        services.AddHostedService<Worker>();
    })
    .Build();
host.Run();
