using mllpServer;
using TinyHealthCheck;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddSingleton<IMllpServer, MllpServer>();
        services.AddHostedService<Worker>();
        // services.AddBasicTinyHealthCheck(config => 
        // {
        //     config.Port = 8080;
        //     config.UrlPath = "/health";
        //     return config;
        // });
    })
    .Build();
host.Run();
