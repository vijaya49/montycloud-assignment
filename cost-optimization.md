# AWS Cost Investigation and Optimization Scenario

A sudden **30% increase** in an AWS production workload bill typically flags unintended resource usage, misconfiguration, or operational spikes. Investigation begins with analytics, root cause identification, and mitigation using AWS built-in tools, followed by ongoing cost optimization initiatives.

---

## Real-Time Scenario: Unused EC2 Instances

A retail company runs its production platform on AWS. After a new product launch, the engineering team scaled up EC2 instances to handle high user traffic. Deployments finished successfully, but some legacy instances were inadvertently left running after traffic stabilized.  

The finance team notices a **30% surge** in the monthly AWS bill and raises a concern.

---

## Investigation Steps

- **Review Cost Explorer and Anomaly Detection**  
  Use AWS Cost Explorer and Cost Anomaly Detection to identify which service component's cost spiked — here, EC2 Compute.

- **Analyze Resource Usage**  
  Drill down into per-instance billing using Cost and Usage Reports and CloudWatch metrics; spot several large EC2s with negligible CPU utilization running for the entire month.

- **Audit Change History**  
  Check tagging, deployment logs, and organization sign-off procedures to spot if any dev/test instances didn’t get terminated post-deployment.

---

## Short-term Fixes

- **Terminate Idle Instances**  
  Immediately shut down unused EC2s and stop non-critical environments outside business hours.  

- **Set Up Alerts**  
  Enable anomaly alerts and billing threshold notifications for cost spikes using AWS Budgets or Cost Anomaly Detection.  

- **Tag Resources Properly**  
  Implement tagging to distinguish production, test, and legacy resources for easier monitoring.  

---

## Long-term Cost Optimization

- **Rightsize Continuously**  
  Use AWS Compute Optimizer to regularly evaluate and downsize overprovisioned resources across EC2, RDS, and EBS.  

- **Implement Auto Scaling**  
  Automate EC2 scaling to match real-time demand and avoid peak provisioning.  

- **Use Appropriate Pricing Models**  
  Migrate predictable workloads to Reserved Instances or Savings Plans; leverage Spot Instances for flexible workloads.  

- **Regular Audit**  
  Schedule monthly or quarterly cost and usage reviews, including cost allocation tagging and actionable feedback to dev teams.  

---

## Automatic Cost Optimizations

To prevent manual oversight and continuously manage costs, implement automation:

- **Instance Scheduler**  
  Use AWS Instance Scheduler (Lambda-based solution) to automatically stop/start non-production workloads outside of business hours.  

- **Auto-Termination Policies**  
  Apply Lambda or EventBridge automation to detect and terminate idle/underutilized resources (EC2, RDS, EBS).  

- **Automated Rightsizing Scripts**  
  Integrate Compute Optimizer with AWS Systems Manager Automation to auto-adjust EC2 and RDS instance sizes based on utilization.  

- **Lifecycle Policies**  
  Configure S3 Lifecycle Policies to automatically transition or delete old objects to reduce storage costs.  

- **Infrastructure as Code with Guardrails**  
  Enforce tagging policies, budget thresholds, and resource limits using AWS Control Tower or Service Control Policies.  

- **Automated Savings Plan Coverage**  
  Regularly analyze usage using Cost Explorer reports and automate recommendations for Reserved Instance or Savings Plan purchases.  

---

## Key Recommendations

- Combine **monitoring, alerting, tagging, rightsizing, and automation** for sustainable cost control.  
- Engage both engineering and finance teams to build **cost-awareness** and eliminate shadow IT activities.  
- Enforce automation and governance to stop cost overruns at the source.  
- Continuous education and policy enforcement stop recurrence of billing shocks and drive **long-term efficiency**.  



---

# AWS EKS Autoscaling: Cluster Autoscaler and Karpenter Explained

This document explains the autoscaling mechanisms available for Amazon EKS (Elastic Kubernetes Service), focusing on the traditional Kubernetes Cluster Autoscaler and the newer AWS Karpenter autoscaler. It covers how they work, configuration basics, and their differences in managing cluster costs and efficiency.

---

## Kubernetes Cluster Autoscaler (CA) on EKS

- The **Cluster Autoscaler (CA)** automatically adjusts the number of EC2 nodes in your EKS node groups based on pod scheduling demands.
- It watches for pods that cannot be scheduled due to insufficient CPU/memory and requests the Auto Scaling Group (ASG) to add nodes.
- When nodes are underutilized or empty, it signals the ASG to scale down by terminating nodes.
- To enable CA:
  - Tag your ASGs with:
    - `k8s.io/cluster-autoscaler/enabled = true`
    - `k8s.io/cluster-autoscaler/<cluster-name> = owned`
  - Configure IAM policies to permit CA to scale ASGs.
  - Deploy the Cluster Autoscaler manifest customized to your EKS version and cluster.
- CA works within the bounds of ASGs and fixed instance types, making it suitable for predictable workloads and managed node groups.

---

## Karpenter: Dynamic, Cloud-Native Autoscaler

- **Karpenter** is an open-source, high-performance autoscaler developed by AWS that dynamically provisions EC2 instances based on real-time pod resource requests.
- It doesn't rely on predefined ASGs but creates right-sized instances fitting the exact workload requirements on demand.
- Karpenter provisions nodes faster and supports mixed instance policies, including Spot and On-Demand instances for cost optimization.
- It integrates with Kubernetes Scheduler to optimize pod placement based on affinity, taints, and tolerations.
- Karpenter simplifies autoscaling by removing ASG limits and improves cost efficiency by minimizing overprovisioning.

---

## Configuration Highlights

### Cluster Autoscaler Setup Highlights:
1. Tag Auto Scaling Groups appropriately for discovery.
2. Create IAM role with necessary permissions.
3. Deploy Cluster Autoscaler manifest configured with your cluster and node group info.
4. Monitor logs and tune scaling parameters.

### Karpenter Setup Highlights:
1. Create and assign an IAM role for Karpenter with required permissions.
2. Deploy the Karpenter controller manifest to your cluster.
3. Define provisioners that control node lifecycle, instance types, zones, and pricing models.
4. Monitor Karpenter events and node provisioning efficiency.

---

## Key Differences Summary

| Feature               | Cluster Autoscaler                              | Karpenter                                            |
|-----------------------|------------------------------------------------|-----------------------------------------------------|
| Node Management       | Scales nodes within predefined ASGs             | Dynamically provisions EC2 instances on demand      |
| Instance Selection    | Limited to fixed node group instance types       | Chooses optimal instance types including Spot       |
| Scaling Latency       | Reactive and slower due to ASG constraints       | Fast and proactive, provisioning right-sized nodes  |
| Cost Efficiency       | Dependent on ASG configuration                    | High, minimizes overprovisioning and idle resources |
| Scheduling Features   | Basic scaling based on pending pods               | Supports affinity, taints, and scheduling policies  |
| Spot Instance Support | Limited manual configuration                       | Native support with automatic selection and fallback|

---

## Interview Talking Points

- Cluster Autoscaler is ideal for workloads with predictable scaling needs and existing ASG structure.
- Karpenter offers greater flexibility and cost optimization by right-sizing nodes dynamically.
- Both require proper IAM permissions, tagging, and monitoring to be effective.
- Karpenter reduces manual overhead and improves scaling latency, especially for bursty or unpredictable workloads.
- Use Cluster Autoscaler if your infrastructure relies heavily on ASGs and you want stability.
- Choose Karpenter for more agile, cloud-native autoscaling with efficient cost control.

---

For detailed setup instructions and manifests, refer to:

- [Cluster Autoscaler on AWS EKS](https://docs.aws.amazon.com/eks/latest/best-practices/cluster-autoscaling.html)
- [Karpenter - Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/karpenter.html)

---
