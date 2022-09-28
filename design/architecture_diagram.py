from diagrams import Diagram, Cluster
from diagrams.oci.compute import VM
from diagrams.oci.network import InternetGateway, RouteTable, SecurityLists, ServiceGateway
from diagrams.generic.device import Tablet

with Diagram("Architecture diagram", show=False, direction="LR"):
    user = Tablet("end user's web browser")
    with Cluster("Oracle Cloud Region"):
        oracle_drg = ServiceGateway("dynamic routing gateway")
        with Cluster("VCN demo"):
            demo_rt = RouteTable("route table")
            demo_ig = InternetGateway("internet gateway")
            demo_lists = SecurityLists("security lists")
            with Cluster("Subnet public"):
                demo_public_vm = VM("vm public rest api")
            with Cluster("Subnet private"):
                demo_private_vm = VM("vm private db")
        with Cluster("VCN internal"):
            internal_rt = RouteTable("route table")
            internal_lists = SecurityLists("security lists")
            with Cluster("Subnet private"):
                internal_private_vm = VM("vm private api")
    demo_public_vm  << demo_lists << demo_rt << demo_ig << user
    demo_private_vm << demo_public_vm
    demo_rt >> oracle_drg >> internal_rt >> internal_lists >> internal_private_vm
