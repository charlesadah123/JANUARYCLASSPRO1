resource "aws_instance" "jenkins_slave" {
  count = 2

  ami           = "ami-0b6c6ebed2801a5cb" # Ubuntu AMI
  instance_type = "t2.small"
  key_name      = "publickpec2"

  vpc_security_group_ids = [aws_security_group.jenkins_slave_sg.id]

  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    tags = {
      Name = "jenkins-slave-${count.index + 1}-root"
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update system
    apt-get update -y
    apt-get upgrade -y

    # Install Java 21, Maven, Git, and Docker
    apt-get install -y openjdk-21-jdk maven git docker.io wget curl

    # Set Java environment variables
    echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" >> /etc/profile
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
    source /etc/profile

    # Start Docker
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ubuntu

    # Create swap space
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

    # Configure Maven for Java 21
    mkdir -p /home/ubuntu/.m2
    cat > /home/ubuntu/.m2/settings.xml << 'SETTINGS'
    <settings>
      <profiles>
        <profile>
          <id>jenkins</id>
          <properties>
            <maven.compiler.source>21</maven.compiler.source>
            <maven.compiler.target>21</maven.compiler.target>
            <maven.compiler.release>21</maven.compiler.release>
          </properties>
        </profile>
      </profiles>
      <activeProfiles>
        <activeProfile>jenkins</activeProfile>
      </activeProfiles>
    </settings>
    SETTINGS

    chown -R ubuntu:ubuntu /home/ubuntu/.m2

    echo "Slave setup complete with Java 21" > /home/ubuntu/setup-complete.txt
    java -version >> /home/ubuntu/setup-complete.txt 2>&1
  EOF

  tags = {
    Name        = "jenkins-slave-${count.index + 1}"
    Role        = "jenkins-slave"
    Environment = "dev"
  }
}