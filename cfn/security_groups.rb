require_relative './tags-subnets.rb'

CloudFormation {
  Description 'Creates security groups'

  def create_security_groups
    Resource(SecurityGroupName) {
      Type 'AWS::EC2::SecurityGroup'
      Property 'GroupDescription', GroupDescription
      Property 'SecurityGroupIngress', [ IngressRules ]
      Property 'VpcId', VpcId
    }
    Output(SecurityGroupName, Ref(SecurityGroupName))

    end
}