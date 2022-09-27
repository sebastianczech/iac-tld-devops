from diagrams import Diagram, Cluster
from diagrams.oci.compute import VM
from diagrams.oci.network import InternetGateway, RouteTable, SecurityLists
from diagrams.generic.device import Tablet

with Diagram("Architecture diagram", show=False, direction="LR"):
    user = Tablet("end user's web browser")
    with Cluster("Oracle Cloud Region"):
        with Cluster("VNC demo"):
            demo_rt = RouteTable("route table")
            demo_ig = InternetGateway("internet gateway")
            demo_lists = SecurityLists("security lists")
            with Cluster("Subnet public"):
                demo_public_vm = VM("vm public rest api")
            with Cluster("Subnet private"):
                demo_private_vm = VM("vm private db")

    demo_public_vm  << demo_lists << demo_rt << demo_ig << user
    demo_private_vm << demo_public_vm
