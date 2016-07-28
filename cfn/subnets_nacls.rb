require_relative './tags-subnets.rb'

CloudFormation {
  Description 'Creates subnets based on the number of CIDR blocks sent to this template'

  def create_subnets
    x = 0
    CidrBlocks.each do |cidr_block|
      Resource(SubnetName + x.to_s) {
        Type 'AWS::EC2::Subnet'
        Property 'AvailabilityZone', AvailabilityZones[x % AvailabilityZones.size]
        Property 'VpcId', VpcId
        Property 'CidrBlock', cidr_block
        Property 'Tags', generate_tags("#{SubnetType}-subnets", "#{SubnetType}-subnets")
      }
      Output(SubnetName + x.to_s, Ref(SubnetName + x.to_s))
      x += 1
    end
  end

  def create_nacl
    Resource (NaclName) {
      Type 'AWS::EC2::NetworkAcl'
      Property 'VpcId', VpcId
      Property 'Tags', generate_tags("#{SubnetType}-subnets", "#{SubnetType}-subnets")
    }
    Output(NaclName, Ref(NaclName))
  end

  def create_nacl_rules_ingress
    x = 0
    IngressRules.each do |rule|
      Resource (NaclRuleIngressName + x.to_s) {
        Type 'AWS::EC2::NetworkAclEntry'
        Property 'CidrBlock', rule['cidr']
        Property 'Egress', rule['egress']
        Property 'NetworkAclId', Ref(NaclName)
        Property 'PortRange', { 'From' => rule['from'], 'To' => rule['to'] }
        Property 'RuleAction', 'allow'
        Property 'RuleNumber', rule['rulenum']
        Property 'Protocol', rule['protocol']
      }
      x += 1
    end
  end

  def create_nacl_rules_egress
    x = 0
    EgressRules.each do |rule|
      Resource (NaclRuleEgressName + x.to_s) {
        Type 'AWS::EC2::NetworkAclEntry'
        Property 'CidrBlock', rule['cidr']
        Property 'Egress', rule['egress']
        Property 'NetworkAclId', Ref(NaclName)
        Property 'PortRange', { 'From' => rule['from'], 'To' => rule['to'] }
        Property 'RuleAction', 'allow'
        Property 'RuleNumber', rule['rulenum']
        Property 'Protocol', rule['protocol']
      }
      x += 1
    end
  end

  def associate_nacl_to_subnets
    x = 0
    CidrBlocks.each do |temp|
      Resource (AssocNaclToSubnetName + x.to_s) {
        Type 'AWS::EC2::SubnetNetworkAclAssociation'
        Property 'SubnetId', Ref(SubnetName + x.to_s)
        Property 'NetworkAclId', Ref(NaclName)
      }
      x += 1
    end
  end

  def create_route_table_assoc_subnet
    Resource (RouteTableName) {
      Type 'AWS::EC2::RouteTable'
      Property 'VpcId', VpcId
      Property 'Tags', generate_tags("#{SubnetType}-subnets", "#{SubnetType}-subnets")
    }

    Resource(RouteName) {
      Type 'AWS::EC2::Route'
      Property 'DestinationCidrBlock', '0.0.0.0/0'
      if SubnetType == "public"
        Property 'GatewayId', InternetGateway
      elsif SubnetType == "private"
        Property 'NetworkInterfaceId', InternetGateway
      else
        raise "Unsupported Subnet type: '#{SubnetType}'"
      end
      Property 'RouteTableId', Ref(RouteTableName)
    }

    x = 0
    CidrBlocks.each do |temp|
      Resource (RouteTableSubnetAssocName + x.to_s) {
        Type 'AWS::EC2::SubnetRouteTableAssociation'
        Property 'RouteTableId', Ref(RouteTableName)
        Property 'SubnetId', Ref(SubnetName + x.to_s)
      }
      x += 1
    end

  end

  create_subnets
  create_nacl
  create_nacl_rules_ingress
  create_nacl_rules_egress
  associate_nacl_to_subnets
  create_route_table_assoc_subnet

}
