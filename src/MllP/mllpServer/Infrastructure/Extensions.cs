namespace mllpServer.Infrastructure;

public static class Extensions 
{
    public static IServiceCollection AddCustomProbe(this IServiceCollection services)
    {

        return services.AddSingleton<IHostedService>(x => 
        {
            var customProbe = ActivatorUtilities.CreateInstance<CustomProbe>(x);
            return ActivatorUtilities.CreateInstance<HealthCheckService<CustomProbe>>(x, customProbe);
        });

        // var customProbe = ActivatorUtilities.CreateInstance<CustomProbe>(services.BuildServiceProvider());
        // services.AddSingleton<CustomProbe>();
        // return services;
    }
}

