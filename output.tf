output "ec2" {
    value = {
        public_ip = [ for v in aws_instance.ec2 : v.public_ip ] 
    }
}
