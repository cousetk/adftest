param Prefix string

@allowed([
  'I'
  'D'
  'T'
  'U'
  'P'
  'S'
  'G'
  'A'
])
param Environment string = 'D'

@allowed([
  '0'
  '1'
  '2'
  '3'
  '4'
  '5'
  '6'
  '7'
  '8'
  '9'
  '10'
  '11'
  '12'
  '13'
  '14'
  '15'
  '16'
])
param DeploymentID string
#disable-next-line no-unused-params
param Stage object
#disable-next-line no-unused-params
param Extensions object
param Global object
#disable-next-line no-unused-params
param DeploymentInfo object

var Deployment = '${Prefix}-${Global.OrgName}-${Global.Appname}-${Environment}${DeploymentID}'
var DeploymentURI = toLower('${Prefix}${Global.OrgName}${Global.Appname}${Environment}${DeploymentID}')

resource OMS 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: '${DeploymentURI}LogAnalytics'
}

var rgName_Monitoring = resourceGroup().name

#disable-next-line decompiler-cleanup
var prefix_var = '${Prefix}${Global.AppName}${Environment}${DeploymentID}'
var ApplicationList = [
  {
    AppServerQuery: 'Computer startswith "${prefix_var}"'
    WebServerQuery: 'Computer startswith "${prefix_var}"'
    SQLServerQuery: 'Computer startswith "${prefix_var}"'
    AppName: Global.AppName
  }
]

resource Dashboard 'Microsoft.Portal/dashboards@2015-08-01-preview' = [for item in ApplicationList: {
  name: '${Prefix}-${Global.OrgName}-${item.AppName}-${Environment}${DeploymentID}-Default-Dashboard'
  location: resourceGroup().location
  tags: {
    'hidden-title': '${Prefix}-${Global.OrgName}-${item.AppName}-${Environment}${DeploymentID}-Default-Dashboard'
  }
  properties: {
    lenses: {
      '0': {
        order: 0
        parts: {
          '0': {
            position: {
              x: 0
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: rgName_Monitoring
                    Name: OMS.name
                  }
                }
                {
                  name: 'Query'
                  value: '''
                          Perf
                          | where TimeGenerated > ago(1h)
                          | where ${item.AppServerQuery}
                          | where CounterName == @"% Processor Time"
                          | summarize avg(CounterValue) by Computer, bin(TimeGenerated, 1m)
                          | render timechart
                          '''
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'TimeGenerated'
                      type: 'DateTime'
                    }
                    yAxis: [
                      {
                        name: 'avg_CounterValue'
                        type: 'Double'
                      }
                    ]
                    splitBy: [
                      {
                        name: 'Computer'
                        type: 'String'
                      }
                    ]
                    aggregation: 'Sum'
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
                {
                  name: 'DashboardId'
                  value: '/subscriptions/c48f5cd5-8dd0-4eaa-b46e-a351002cdabd/resourceGroups/FNF-RG-Monitoring-Prod/providers/Microsoft.Portal/dashboards/c19faec1-fed6-4ab4-96bf-fbac2f31d2e0'
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                }
                {
                  name: 'PartSubTitle'
                  value: OMS.name
                }
                {
                  name: 'resourceTypeMode'
                  value: 'workspace'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AnalyticsLineChartPart'
              settings: {
                content: {
                  dashboardPartTitle: '${item.AppName} App Server CPU'
                  dashboardPartSubTitle: OMS.name
                }
              }
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          '1': {
            position: {
              x: 6
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: rgName_Monitoring
                    Name: OMS.name
                  }
                }
                {
                  name: 'Query'
                  value: '''
                          Perf 
                          | where TimeGenerated > ago(1h)
                          | where ${item.AppServerQuery}
                          | where ObjectName == @"Memory"\nand CounterName == @"Available MBytes"
                          | summarize avg(CounterValue) by Computer, bin(TimeGenerated, 1m)
                          | render timechart
                          '''
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'TimeGenerated'
                      type: 'DateTime'
                    }
                    yAxis: [
                      {
                        name: 'avg_CounterValue'
                        type: 'Double'
                      }
                    ]
                    splitBy: [
                      {
                        name: 'Computer'
                        type: 'String'
                      }
                    ]
                    aggregation: 'Sum'
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
                {
                  name: 'DashboardId'
                  value: '/subscriptions/c48f5cd5-8dd0-4eaa-b46e-a351002cdabd/resourceGroups/FNF-RG-Monitoring-Prod/providers/Microsoft.Portal/dashboards/c19faec1-fed6-4ab4-96bf-fbac2f31d2e0'
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                }
                {
                  name: 'PartSubTitle'
                  value: OMS.name
                }
                {
                  name: 'resourceTypeMode'
                  value: 'workspace'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AnalyticsLineChartPart'
              settings: {
                content: {
                  dashboardPartTitle: '${item.AppName} Available Memory in MB'
                  dashboardPartSubTitle: OMS.name
                }
              }
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          '2': {
            position: {
              x: 0
              y: 4
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: rgName_Monitoring
                    Name: OMS.name
                  }
                }
                {
                  name: 'Query'
                  value: 'Perf\n| where TimeGenerated > ago(1h)\n| where ${item.AppServerQuery}\n and ObjectName == @"LogicalDisk"\nand CounterName == @"Disk Writes/sec"\nand InstanceName == @"_Total"\n| summarize avg(CounterValue) by Computer, bin(TimeGenerated, 1m)\n| render timechart'
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'TimeGenerated'
                      type: 'DateTime'
                    }
                    yAxis: [
                      {
                        name: 'avg_CounterValue'
                        type: 'Double'
                      }
                    ]
                    splitBy: [
                      {
                        name: 'Computer'
                        type: 'String'
                      }
                    ]
                    aggregation: 'Sum'
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
                {
                  name: 'DashboardId'
                  value: '/subscriptions/c48f5cd5-8dd0-4eaa-b46e-a351002cdabd/resourceGroups/FNF-RG-Monitoring-Prod/providers/Microsoft.Portal/dashboards/c19faec1-fed6-4ab4-96bf-fbac2f31d2e0'
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                }
                {
                  name: 'PartSubTitle'
                  value: OMS.name
                }
                {
                  name: 'resourceTypeMode'
                  value: 'workspace'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AnalyticsLineChartPart'
              settings: {
                content: {
                  dashboardPartTitle: '${item.AppName} Logical Disk I/O Total'
                  dashboardPartSubTitle: OMS.name
                }
              }
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          '3': {
            position: {
              x: 6
              y: 4
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: rgName_Monitoring
                    Name: OMS.name
                  }
                }
                {
                  name: 'Query'
                  value: 'Perf\n| where TimeGenerated > ago(1h)\n| where ${item.AppServerQuery}\n and ObjectName == @"PhysicalDisk"\nand CounterName == @"Avg. Disk Read Queue Length"\nand InstanceName == @"_Total"\n| summarize avg(CounterValue) by Computer, bin(TimeGenerated, 1m)\n| render timechart'
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'TimeGenerated'
                      type: 'DateTime'
                    }
                    yAxis: [
                      {
                        name: 'avg_CounterValue'
                        type: 'Double'
                      }
                    ]
                    splitBy: [
                      {
                        name: 'Computer'
                        type: 'String'
                      }
                    ]
                    aggregation: 'Sum'
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
                {
                  name: 'DashboardId'
                  value: '/subscriptions/c48f5cd5-8dd0-4eaa-b46e-a351002cdabd/resourceGroups/FNF-RG-Monitoring-Prod/providers/Microsoft.Portal/dashboards/c19faec1-fed6-4ab4-96bf-fbac2f31d2e0'
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                }
                {
                  name: 'PartSubTitle'
                  value: OMS.name
                }
                {
                  name: 'resourceTypeMode'
                  value: 'workspace'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AnalyticsLineChartPart'
              settings: {
                content: {
                  dashboardPartTitle: '${item.AppName} Disk Queue Length'
                  dashboardPartSubTitle: OMS.name
                }
              }
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          '4': {
            position: {
              x: 12
              y: 4
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: rgName_Monitoring
                    Name: OMS.name
                  }
                }
                {
                  name: 'Query'
                  value: 'Perf| where TimeGenerated > ago(1h)| where ${item.AppServerQuery}| where ObjectName == "Network Adapter"  and CounterName == @"Bytes Total/sec" and CounterValue > 500000| summarize avg(CounterValue) by Computer, bin(TimeGenerated, 1m)| render timechart'
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'TimeGenerated'
                      type: 'DateTime'
                    }
                    yAxis: [
                      {
                        name: 'avg_CounterValue'
                        type: 'Double'
                      }
                    ]
                    splitBy: [
                      {
                        name: 'Computer'
                        type: 'String'
                      }
                    ]
                    aggregation: 'Sum'
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
                {
                  name: 'DashboardId'
                  value: '/subscriptions/c48f5cd5-8dd0-4eaa-b46e-a351002cdabd/resourceGroups/FNF-RG-Monitoring-Prod/providers/Microsoft.Portal/dashboards/c19faec1-fed6-4ab4-96bf-fbac2f31d2e0'
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                }
                {
                  name: 'PartSubTitle'
                  value: OMS.name
                }
                {
                  name: 'resourceTypeMode'
                  value: 'workspace'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AnalyticsLineChartPart'
              settings: {
                content: {
                  dashboardPartTitle: '${item.AppName} Top Network Utilization Servers'
                  dashboardPartSubTitle: OMS.name
                }
              }
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          '5': {
            position: {
              x: 12
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: {
                    SubscriptionId: subscription().subscriptionId
                    ResourceGroup: rgName_Monitoring
                    Name: OMS.name
                  }
                }
                {
                  name: 'Query'
                  value: 'Perf| where TimeGenerated > ago(1h)| where ${item.AppServerQuery}| where ObjectName == "Network Adapter"  and CounterName == @"Bytes Total/sec"  and  CounterValue > 200000| sort by CounterValue desc| summarize arg_max(CounterValue, *) by Computer| distinct  Computer, CounterValue| top 10 by CounterValue  desc nulls last| render barchart'
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'Computer'
                      type: 'String'
                    }
                    yAxis: [
                      {
                        name: 'CounterValue'
                        type: 'Double'
                      }
                    ]
                    splitBy: []
                    aggregation: 'Sum'
                  }
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
                {
                  name: 'DashboardId'
                  value: '/subscriptions/c48f5cd5-8dd0-4eaa-b46e-a351002cdabd/resourceGroups/FNF-RG-Monitoring-Prod/providers/Microsoft.Portal/dashboards/c19faec1-fed6-4ab4-96bf-fbac2f31d2e0'
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                }
                {
                  name: 'PartSubTitle'
                  value: OMS.name
                }
                {
                  name: 'resourceTypeMode'
                  value: 'workspace'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AnalyticsBarChartPart'
              settings: {
                content: {
                  dashboardPartTitle: '${item.AppName} Top Network Utilization Servers'
                  dashboardPartSubTitle: OMS.name
                }
              }
              asset: {
                idInputName: 'ComponentId'
                type: 'ApplicationInsights'
              }
            }
          }
          '6': {
            position: {
              x: 18
              y: 5
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/HubsExtension/PartType/VideoPart'
              settings: {
                content: {
                  settings: {
                    title: 'Testing in Production'
                    subtitle: 'DevOps'
                    src: 'https://www.youtube.com/watch?v=jFXTryMp5KY'
                    autoplay: false
                  }
                }
              }
            }
          }
          '7': {
            position: {
              x: 0
              y: 8
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'China Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          '8': {
            position: {
              x: 2
              y: 8
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  content: {
                    settings: {
                      timezoneId: 'UTC'
                      timeFormat: 'h:mma'
                      version: 1
                    }
                  }
                }
              }
            }
          }
          '12': {
            position: {
              x: 4
              y: 8
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Eastern Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          '9': {
            position: {
              x: 6
              y: 8
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Mountain Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          '10': {
            position: {
              x: 8
              y: 8
              rowSpan: 2
              colSpan: 2
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/HubsExtension/PartType/ClockPart'
              settings: {
                content: {
                  settings: {
                    timezoneId: 'Pacific Standard Time'
                    timeFormat: 'h:mma'
                    version: 1
                  }
                }
              }
            }
          }
          '11': {
            position: {
              x: 14
              y: 8
              rowSpan: 2
              colSpan: 4
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '__Azure Deployment Framework__\n\n<span style="color:green">No *Testing* in Production</span>.\n\n\n<img width=\'10\' src=\'https://preview.portal.azure.com/favicon.ico\'/> and <a href=\'https://azure.microsoft.com\' target=\'_blank\'>Azure Preview Dashboard - Preview.Portal.Azure.com</a>\n\n'
                    title: 'Azure Operations Dashboard'
                    subtitle: 'Operations Management Suite'
                  }
                }
              }
            }
          }
          '13': {
            position: {
              x: 18
              y: 0
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    subscriptions: '{subscriptionguid}'
                    regions: 'AustraliaEast;AustraliaSoutheast;CentralUS;EastUS;EastUS2;Global;Multi-Region;NorthCentralUS;SouthCentralUS;WestCentralUS;WestUS;WestUS2'
                    services: ''
                    resourceGroupId: 'all'
                    timeSpan: '5'
                    startTime: '4/3/2018 3:29:31 AM'
                    endTime: '4/6/2018 3:29:31 AM'
                    queryName: 'Service Health'
                    queryId: 'a5b30ff6-c9ea-4f5a-8f21-3f0ae3eb4c55'
                    loadFromCache: false
                    communicationType: 'incident'
                    statusFilter: 'active'
                  }
                }
              ]
              type: 'Extension/Microsoft_Azure_Health/PartType/ServiceIssuesTilePart'
            }
          }
          '14': {
            position: {
              x: 18
              y: 3
              rowSpan: 2
              colSpan: 4
            }
            metadata: {
              inputs: []
              type: 'Extension[azure]/Microsoft_AAD_IAM/PartType/OrganizationIdentityPart'
            }
          }
          '15': {
            position: {
              x: 10
              y: 8
              rowSpan: 2
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: '${OMS.id}/views/Updates(${OMS.name})'
                }
                {
                  name: 'solutionId'
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/ViewTileIFramePart'
            }
          }
        }
      }
    }
    metadata: {
      model: {
        timeRange: {
          value: {
            relative: {
              duration: 24
              timeUnit: 1
            }
          }
          type: 'MsPortalFx.Composition.Configuration.ValueTypes.TimeRange'
        }
      }
    }
  }
}]
