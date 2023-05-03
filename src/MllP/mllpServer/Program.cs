using mllpServer;
using mllpServer.Infrastructure;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddSingleton<IMllpServer, MllpServer>();
        services.AddHostedService<Worker>();
        services.AddCustomProbe();      
    })
    .Build();

host.Run();
