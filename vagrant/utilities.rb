VM_USERNAME       = "vagrant"
VM_CPUS           = 4
VM_MEMORY         = 8192
VM_IP_ADDR        = "10.10.22.57"

KUBESPRAY_VERSION = "v2.22.1"
KUBESPRAY_DIR     = "/opt/kubespray-#{KUBESPRAY_VERSION}"

VM_OS_NAME   = "debian11"
SUPPORTED_OS = {
  "debian11"   => { :box => "generic/debian11",   :version => "4.2.16" },
  "ubuntu2204" => { :box => "generic/ubuntu2204", :version => "4.2.16" },
}

if ! SUPPORTED_OS.key?(VM_OS_NAME)
  puts "Unsupported OS   : '#{VM_OS_NAME}'"
  supported_os_list = SUPPORTED_OS.keys.map { |os| "'#{os}'" }
  puts "Supported OS are : #{supported_os_list.join(', ')}"
  exit 1
end
