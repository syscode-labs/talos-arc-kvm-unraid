import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'talos-arc-kvm-unraid',
  description: 'Practical operations docs for Talos + ARC + KVM workloads on Unraid',
  lang: 'en-US',
  base: '/talos-arc-kvm-unraid/',
  appearance: true,
  themeConfig: {
    nav: [
      { text: 'Architecture', link: '/architecture/' },
      { text: 'User Manual', link: '/user-manual/' },
      { text: 'Service Manual', link: '/service-manual/' },
      { text: 'GitHub', link: 'https://github.com/syscode-labs/talos-arc-kvm-unraid' }
    ],
    search: { provider: 'local' },
    sidebar: [
      {
        text: 'Start Here',
        items: [
          { text: 'Overview', link: '/' },
          { text: 'Quick Start', link: '/quick-start' },
          { text: 'Secrets Reference', link: '/reference/secrets' }
        ]
      },
      {
        text: 'Architecture',
        items: [
          { text: 'System Overview', link: '/architecture/' },
          { text: 'Control/Data Flows', link: '/architecture/flows' },
          { text: 'Security Model', link: '/architecture/security' }
        ]
      },
      {
        text: 'User Manual',
        items: [
          { text: 'Operator Workflow', link: '/user-manual/' },
          { text: 'Terraform Manual Apply', link: '/user-manual/terraform-apply' },
          { text: 'ARC and Runner Classes', link: '/user-manual/arc-runners' },
          { text: 'GitHub Workflows', link: '/user-manual/workflows' },
          { text: 'Validation and Smoke Tests', link: '/user-manual/validation' }
        ]
      },
      {
        text: 'Service Manual',
        items: [
          { text: 'SRE Runbook', link: '/service-manual/' },
          { text: 'Autoscaler Operations', link: '/service-manual/autoscaler' },
          { text: 'Incidents and Recovery', link: '/service-manual/incidents' },
          { text: 'Upgrade and Change Management', link: '/service-manual/upgrades' },
          { text: 'Troubleshooting Matrix', link: '/service-manual/troubleshooting' }
        ]
      }
    ],
    outline: 'deep',
    socialLinks: [
      { icon: 'github', link: 'https://github.com/syscode-labs/talos-arc-kvm-unraid' }
    ]
  }
})
