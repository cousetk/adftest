#
# ConfigurationData.psd1
#

@{ 
    AllNodes = @( 
        @{ 
            NodeName                    = 'LocalHost' 
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true

            # IncludesAllSubfeatures
            WindowsFeaturePresent       = 'RSAT', 'DNS', 'FS-DFS-Namespace', 'RSAT-ADDS', 'RSAT-DNS-Server'

            # Blob copy with Managed Identity - Oauth2
            AZCOPYDSCDirPresentSource   = @(

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/PSModules/'
                    DestinationPath   = 'F:\Source\PSModules\'
                },

                @{
                    SourcePathBlobURI = 'https://{0}.blob.core.windows.net/source/PSCore/'
                    DestinationPath   = 'F:\Source\PSCore\'
                }

            )

            ConditionalForwarderPresent = @(
                @{Name = 'psthing.com'; MasterServers = '168.63.129.16' },
                @{Name = 'windows.net'; MasterServers = '168.63.129.16' },
                @{Name = 'azure.com'; MasterServers = '168.63.129.16' },
                @{Name = 'azurecr.io'; MasterServers = '168.63.129.16' },
                @{Name = 'azmk8s.io'; MasterServers = '168.63.129.16' },
                @{Name = 'windowsazure.com'; MasterServers = '168.63.129.16' },
                @{Name = 'azconfig.io'; MasterServers = '168.63.129.16' },
                @{Name = 'azure.net'; MasterServers = '168.63.129.16' },
                @{Name = 'azurewebsites.net'; MasterServers = '168.63.129.16' },
                @{Name = 'azuresynapse.net'; MasterServers = '168.63.129.16' },
                @{Name = 'azure-api.net'; MasterServers = '168.63.129.16' }
            )

            RegistryKeyPresent          = @(
                
                @{ Key = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; 
                    ValueName = 'DontUsePowerShellOnWinX'; ValueData = 0 ; ValueType = 'Dword'
                },

                @{ Key = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; 
                    ValueName = 'TaskbarGlomLevel'; ValueData = 1 ; ValueType = 'Dword'
                }
                
            )

            SoftwarePackagePresent2     = @(
                
                @{
                    Name      = 'PowerShell 7-x64'
                    Path      = 'F:\Source\PSCore\PowerShell-7.1.2-win-x64.msi'
                    ProductId = '{357A3946-1572-4A21-9B60-4C7BD1BB9761}' # '{357A3946-1572-4A21-9B60-4C7BD1BB9761}'
                    Arguments = 'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 REGISTER_MANIFEST=1'  # ENABLE_PSREMOTING=1
                }

            )
        } 
    )
}



































