# enterprise-devops-workshop
This is collaboration space and will become the starter files and work item list for the MSFT Azure Apps July 2019 Airlift content.

## Goal
Enable small teams of App-focused GBBs/CSAs/... to get hands on experience with the combination of Azure Policy, Azure DevOps, GitHub and AKS.

## Logistics
- Teams of 4-6 participants
- Floating proctors (not at the table)
- If you already know how to do it, you can advise your team but don't touch the keyboard
- It will be approximately a 3 hour time block

## Challenge Objectives
These will be moved into Work items and will form the goals/tasks that teams will strive to achieve:

| Story                       | Task                                                | Description                                 |
| :-------------------------- | :-------------------------------------------------  | :------------------------------------------ |
| Configure source repository |                                                     |                                             |
|                             | Fork https://github.com/dmckinstry/terraform-labs/  |                                             |
|                             | Grant permissions as appropriate                    |                                             |
| Configure Azure             |                                                     |                                             |
|                             | Allocate a subscription and/or resource group(s)    |                                             |
|                             | Set permissions as appropriate for the hack team    |                                             |
| Create a Policy pipeline    |                                                     |                                             |
|                             | Review the **TBD** folder                           |                                             |
|                             | Create a Pipeline to deploy and assign the policies | Scope to the **TBD** folder                 |
|                             | Verify the pipeline / review the Azure Portal       |                                             |
| Create an IAC pipeline      |                                                     |                                             |
|                             | Use Azure Pipelines and YAML                        | Scope to the **TBD** folder                 |
|                             | Use the existing Terraform files                    | ** NEED config/customization rqts **        |
|                             | Run the pipeline and verify AKS deployment to Azure |                                             |
| Configure CI build for app  |                                                     |                                             |
|                             | Q: Do we have tests or anything else to wire up?    |                                             |
| Configure branch protection |                                                     |                                             |
|                             | Require successful CI build before PR merge         |                                             |
|                             | Require a reviewer before PR merge                  |                                             |
| ** TBD Policy Update        |                                                     |                                             |
|                             | **TBD** Adjust policy                               |                                             |
|                             | **TBD** Execute Policy pipeline and verify          | Should be non-compliant                     |
|                             | **TBD** Adjust IAC to resolve violation             | Run IAC Pipeline and verify it's fixed      |
| Create an app pipeline      |                                                     |                                             |
|                             | Use Azure Pipelines and YAML                        |                                             |
|                             | Automatically deploy to AKS                         |                                             |
|                             | CURL the end point to verify deployment             |                                             |
| Secure the app pipeline     |                                                     |                                             |
|                             | Add SAST to the pipeline                            | Recommend securego, SonarQube or SonarCloud |
|                             | Add CVE Scanning to the pipeline                    | Any, but Whitesource Bolt is free           |
