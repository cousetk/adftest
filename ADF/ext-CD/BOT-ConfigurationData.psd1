#
# ConfigurationData.psd1
#

@{
    AllNodes = @(
        @{
            NodeName                    = 'LocalHost'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true

            DisksPresent                = @{DriveLetter = 'F'; DiskID = '2' }

            ServiceSetStopped           = 'ShellHWDetection'

            # IncludesAllSubfeatures
            WindowsFeaturePresent2      = 'RSAT'

            # given this is for a lab and load test, just always pull down the latest App config
            DSCConfigurationMode        = 'ApplyAndAutoCorrect'

            DisableIEESC                = $True

            FWRules                     = @(
                @{
                    Name      = 'EchoBot'
                    LocalPort = ('8445', '9442', '9441')
                }
            )
            
            DirectoryPresent            = @(
                'F:\Source\InstallLogs', 'F:\API\EchoBot', 'F:\Build\EchoBot'
            )
            
            # Port Mappings from NAT Pools on Azure Load Balancer
            # Dynamically set from Azure Metadata Service
            EnvironmentVarPresentVMSS   = @(
                @{
                    Name             = 'AzureSettings:MediaExternalPort'
                    BackendPortMatch = '8445'
                    Value            = '{0}'
                },
                @{
                    Name             = 'AzureSettings:BotNotificationExternalPort'
                    BackendPortMatch = '9441'
                    Value            = '{0}'
                }
            )

            EnvironmentVarPresent       = @(
                @{
                    Name  = 'AzureSettings:CallSignalingInternalPort'
                    Value = '9442'
                },
                @{
                    Name  = 'AzureSettings:BotNotificationInternalPort'
                    Value = '9441'
                },
                @{
                    Name  = 'AzureSettings:MediaInternalPort'
                    Value = '8445'
                },
                @{
                    Name  = 'AzureSettings:UseCognitiveServices'
                    Value = 'false'
                },
                @{
                    Name  = 'AzureSettings:SpeechConfigRegion'
                    Value = 'eastus2'
                },
                @{
                    Name  = 'AzureSettings:BotLanguage'
                    Value = 'en-US'
                },
                @{
                    Name  = 'AzureSettings:BotKeyword'
                    Value = 'hello'
                }
            )
            
            EnvironmentVarSet           = @(
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'BotName' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'AadAppId' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'AadAppSecret' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'ServiceDnsName' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'SpeechConfigKey' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'CertificateThumbprint' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'Prefix' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'OrgName' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'App' },
                @{Prefix = 'AzureSettings:'; KVName = '{0}-kvAPP01'; Name = 'Environment' }
            )

            # Blob copy with Managed Identity - Oauth2
            # Commented out for Lab, using RemoteFilePresent instead
            AZCOPYDSCDirPresentSource2  = @(
                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/GIT/'
                    DestinationPath   = 'F:\Source\GIT\'
                },
                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/dotnet/'
                    DestinationPath   = 'F:\Source\dotnet\'
                },
                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/VisualStudio/'
                    DestinationPath   = 'F:\Source\VisualStudio\'
                }
            )

            # this downloads the files each time, you can use AZCOPYDSCDirPresentSource above
            # As an alternative if you stage the files
            RemoteFilePresent           = @(
                @{
                    Uri             = 'https://github.com/git-for-windows/git/releases/download/v2.33.1.windows.1/Git-2.33.1-64-bit.exe'
                    DestinationPath = 'F:\Source\GIT\Git-2.33.1-64-bit.exe'
                },
                @{
                    Uri             = 'https://aka.ms/vs/16/release/vc_redist.x64.exe'
                    DestinationPath = 'F:\Source\dotnet\vc_redist.x64.exe'
                },
                @{
                    Uri             = 'https://download.visualstudio.microsoft.com/download/pr/5a50b8ac-2c22-47f1-ba60-70d4257a78fa/d662d2f23b4b523f30e24cbd7e5e651c7c6a712f21f48e032f942dc678f08beb/vs_Community.exe'
                    DestinationPath = 'F:\Source\VisualStudio\vs_community.exe'
                }
            )

            SoftwarePackagePresent      = @(
                @{
                    Name      = 'Git'
                    Path      = 'F:\Source\GIT\Git-2.33.1-64-bit.exe'
                    ProductId = ''
                    Arguments = '/VERYSILENT'
                },
                @{
                    Name      = 'Microsoft Visual C++ 2015-2019 Redistributable (x64) - 14.29.30135'
                    Path      = 'F:\Source\dotnet\VC_redist.x64.exe'
                    ProductId = ''
                    Arguments = '/install /q /norestart'
                }
                @{  
                    Name      = 'Visual Studio Community 2019'
                    Path      = 'F:\Source\VisualStudio\vs_community.exe'
                    ProductId = ''
                    Arguments = '--installPath F:\VisualStudio\2019\Community --addProductLang en-US  --includeRecommended --quiet --wait --norestart' #--config "F:\Source\VisualStudio\.vsconfig"
                }
            )

            # Blob copy with Managed Identity - Oauth2
            AppReleaseDSCAppPresent     = @(
                @{
                    ComponentName     = 'EchoBot'
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/builds/'
                    DestinationPath   = 'F:\API\'
                    ValidateFileName  = 'CurrentBuild.txt'
                    BuildFileName     = 'F:\Build\EchoBot\componentBuild.json'
                    SleepTime         = '10'
                }
            )

            NewServicePresent           = @(
                @{
                    Name        = 'EchoBotService'
                    Path        = 'F:\API\EchoBot\EchoBot.WindowsService.exe'
                    State       = 'Running'
                    StartupType = 'Automatic'
                    Description = 'Echo Bot Service'
                }
            )

            CertificatePortBinding      = @(
                @{
                    Name  = 'MediaControlPlane'
                    Port  = '8445'
                    AppId = '{7c64d8a0-4cbb-42b6-85a8-de0e00f6a9c6}'
                },
                @{
                    Name  = 'BotCalling'
                    Port  = '9442'
                    AppId = '{7c64d8a0-4cbb-42b6-85a8-de0e00f6a9c6}'
                },
                @{
                    Name  = 'BotNotification'
                    Port  = '9441'
                    AppId = '{7c64d8a0-4cbb-42b6-85a8-de0e00f6a9c6}'
                }
            )
        }
    )
}
