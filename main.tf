terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.58.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_firewall" "res-0" {
  dns_proxy_enabled   = false
  dns_servers         = []
  firewall_policy_id  = azurerm_firewall_policy.res-1.id
  location            = "eastus"
  name                = "ent-net-firewall-dev"
  private_ip_ranges   = []
  resource_group_name = "Cadmux_rg01"
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  tags                = {}
  threat_intel_mode   = "Alert"
  zones               = []
  ip_configuration {
    name                 = "ent-net-fw-pip-dev"
    public_ip_address_id = azurerm_public_ip.res-4.id
    subnet_id            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/AzureFirewallSubnet"
  }
  management_ip_configuration {
    name                 = "ent-net-fw-pip-mgmt-dev"
    public_ip_address_id = azurerm_public_ip.res-5.id
    subnet_id            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/AzureFirewallManagementSubnet"
  }
}
resource "azurerm_firewall_policy" "res-1" {
  auto_learn_private_ranges_enabled = false
  base_policy_id                    = ""
  location                          = "eastus"
  name                              = "ent-net-fw-policy-dev"
  private_ip_ranges                 = []
  resource_group_name               = "Cadmux_rg01"
  sku                               = "Premium"
  tags                              = {}
  threat_intelligence_mode          = "Alert"
  dns {
    proxy_enabled = true
    servers       = []
  }
  intrusion_detection {
    mode           = "Alert"
    private_ranges = []
  }
  threat_intelligence_allowlist {
    fqdns        = []
    ip_addresses = []
  }
}
resource "azurerm_network_security_group" "res-2" {
  location            = "eastus"
  name                = "nsg-AzureBastionSubnet"
  resource_group_name = "Cadmux_rg01"
  security_rule = [{
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "*"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "DenyAllOutBound"
    priority                                   = 1020
    protocol                                   = "*"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "AllowAzureLB"
    priority                                   = 120
    protocol                                   = "Tcp"
    source_address_prefix                      = "AzureLoadBalancer"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "AllowGatewayMgr"
    priority                                   = 110
    protocol                                   = "Tcp"
    source_address_prefix                      = "GatewayManager"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "AllowHttpsInbound"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = "Internet"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "AzureCloud"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "AllowAzureCloud"
    priority                                   = 110
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "Internet"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "80"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "AllowGetSessionOut"
    priority                                   = 1010
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["22", "3389"]
    direction                                  = "Outbound"
    name                                       = "AllowSshRdpOut"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["5701", "8080"]
    direction                                  = "Inbound"
    name                                       = "AllowBastionComm"
    priority                                   = 130
    protocol                                   = "Tcp"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["5701", "8080"]
    direction                                  = "Outbound"
    name                                       = "AllowBastionCommOut"
    priority                                   = 120
    protocol                                   = "*"
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Deny"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "*"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "DenyAllInbound"
    priority                                   = 1000
    protocol                                   = "*"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
  }]
  tags = {}
}
resource "azurerm_network_security_group" "res-3" {
  location            = "eastus"
  name                = "nsg-DataSubnet"
  resource_group_name = "Cadmux_rg01"
  security_rule = [{
    access                                     = "Allow"
    description                                = "DBA accesss via Bastion"
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = ""
    destination_port_ranges                    = ["22", "3389"]
    direction                                  = "Inbound"
    name                                       = "AllowBastionAdmin"
    priority                                   = 200
    protocol                                   = "*"
    source_address_prefix                      = "10.0.30.0/26"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = "SQLfrom app tier only"
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "1433"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "AllowSwlFromApp"
    priority                                   = 100
    protocol                                   = "*"
    source_address_prefix                      = "10.1.2.0/24"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
  }]
  tags = {}
}
resource "azurerm_public_ip" "res-4" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "eastus"
  name                    = "ent-net-fw-pip-dev"
  resource_group_name     = "Cadmux_rg01"
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}
resource "azurerm_public_ip" "res-5" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "eastus"
  name                    = "ent-net-fw-pip-mgmt-dev"
  resource_group_name     = "Cadmux_rg01"
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}
resource "azurerm_virtual_network" "res-6" {
  address_space                  = ["10.0.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "eastus"
  name                           = "ent-net-hub-vnet-dev"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = "Cadmux_rg01"
  subnet = [{
    address_prefixes                              = ["10.0.1.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/AzureFirewallSubnet"
    name                                          = "AzureFirewallSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.2.0/27"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/GatewaySubnet"
    name                                          = "GatewaySubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.3.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/AzureBastionSubnet"
    name                                          = "AzureBastionSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = azurerm_network_security_group.res-2.id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.4.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/ManagementSubnet"
    name                                          = "ManagementSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.5.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-hub-vnet-dev/subnets/AzureFirewallManagementSubnet"
    name                                          = "AzureFirewallManagementSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_virtual_network" "res-7" {
  address_space                  = ["10.1.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "eastus"
  name                           = "ent-net-spoke1-web-vnet-dev"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = "Cadmux_rg01"
  subnet = [{
    address_prefixes                              = ["10.1.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-spoke1-web-vnet-dev/subnets/WebSubnet"
    name                                          = "WebSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.1.2.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-spoke1-web-vnet-dev/subnets/AppSubnet"
    name                                          = "AppSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_virtual_network" "res-8" {
  address_space                  = ["10.2.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "eastus"
  name                           = "ent-net-spoke2-data-vnet-dev"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = "Cadmux_rg01"
  subnet = [{
    address_prefixes                              = ["10.2.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-spoke2-data-vnet-dev/subnets/DataSubnet"
    name                                          = "DataSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.2.2.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-spoke2-data-vnet-dev/subnets/PrivateEndpointSubnet"
    name                                          = "PrivateEndpointSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_virtual_network" "res-9" {
  address_space                  = ["10.3.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "eastus"
  name                           = "ent-net-spoke3-dmz-vnet-dev"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = "Cadmux_rg01"
  subnet = [{
    address_prefixes                              = ["10.3.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-spoke3-dmz-vnet-dev/subnets/DMZSubnet"
    name                                          = "DMZSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.3.2.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/875d9e8d-901f-472f-ad98-1a8157ac7b11/resourceGroups/Cadmux_rg01/providers/Microsoft.Network/virtualNetworks/ent-net-spoke3-dmz-vnet-dev/subnets/JumpSubnet"
    name                                          = "JumpSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_log_analytics_workspace" "res-10" {
  allow_resource_only_permissions         = true
  cmk_for_query_forced                    = false
  daily_quota_gb                          = -1
  data_collection_rule_id                 = ""
  immediate_data_purge_on_30_days_enabled = false
  internet_ingestion_enabled              = true
  internet_query_enabled                  = true
  location                                = "eastus"
  name                                    = "ent-net-law-dev"
  primary_shared_key                      = "" # Masked sensitive attribute
  resource_group_name                     = "Cadmux_rg01"
  retention_in_days                       = 30
  secondary_shared_key                    = "" # Masked sensitive attribute
  sku                                     = "PerGB2018"
  tags                                    = {}
}
