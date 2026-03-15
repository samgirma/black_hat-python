<div align="center">
  <img src="https://learning.oreilly.com/library/cover/9781098102920/250w/" alt="Black Hat Python Cover" width="180" style="border-radius: 12px; box-shadow: 0 10px 20px rgba(0,0,0,0.3);">
  
  <h1 style="border-bottom: none; margin-top: 20px;">Black Hat Python Lab</h1>
  <p style="font-size: 1.2em; color: #586069;">Advanced Offensive Tooling & Automation Environment</p>

  <div style="margin-bottom: 25px;">
    <img src="https://img.shields.io/badge/Python-3.13-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python">
    <img src="https://img.shields.io/badge/Linux-Shell-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Bash">
    <img src="https://img.shields.io/badge/Cybersecurity-Lab-red?style=for-the-badge&logo=target&logoColor=white" alt="Security">
    <img src="https://img.shields.io/badge/Status-Under--Development-orange?style=for-the-badge" alt="Status">
  </div>
</div>

---

### 📖 Research & Development
This laboratory is dedicated to the practical implementation of offensive security concepts detailed in **"Black Hat Python" (2nd Edition)**. The project focuses on bridging the gap between high-level software engineering and low-level network manipulation, specifically targeting:

* **Network Foundation:** Custom TCP/UDP proxies and multi-purpose listeners.
* **Security Automation:** Building tools that automate the reconnaissance and exploitation phases.
* **System Integrity:** Ensuring code modularity and safety during security testing.

---

### 🛠 The Management Toolkit
To streamline development within the Linux terminal, I have engineered a custom Bash-based ecosystem. These utilities automate repetitive tasks and provide a safe "sandbox" for script testing.

<div style="overflow-x: auto;">
  <table style="width: 100%; border-spacing: 0; border-collapse: collapse; border: 1px solid #e1e4e8; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;">
    <thead>
      <tr style="background-color: #f6f8fa;">
        <th style="padding: 12px; border: 1px solid #e1e4e8;">Command</th>
        <th style="padding: 12px; border: 1px solid #e1e4e8;">Utility</th>
        <th style="padding: 12px; border: 1px solid #e1e4e8;">Core Functionality</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td style="padding: 12px; border: 1px solid #e1e4e8; text-align: center;"><code>bhp</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><code>run.sh</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><b>Launcher:</b> Recursive script discovery with automatic <code>venv</code> activation and interactive wizards for complex tools.</td>
      </tr>
      <tr>
        <td style="padding: 12px; border: 1px solid #e1e4e8; text-align: center;"><code>bhp-new</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><code>create.sh</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><b>Generator:</b> Rapid module and file scaffolding with standardized security boilerplates and executable permissions.</td>
      </tr>
      <tr>
        <td style="padding: 12px; border: 1px solid #e1e4e8; text-align: center;"><code>bhp-rm</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><code>remove.sh</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><b>Manager:</b> Secure file removal system with mandatory confirmation and timestamped backups.</td>
      </tr>
      <tr>
        <td style="padding: 12px; border: 1px solid #e1e4e8; text-align: center;"><code>./recover.sh</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><code>recover.sh</code></td>
        <td style="padding: 12px; border: 1px solid #e1e4e8;"><b>Recovery:</b> Dynamically generated restoration script to return the last backed-up file to its original path.</td>
      </tr>
    </tbody>
  </table>
</div>

---

### 🚀 Implementation Details

#### Aliases Configuration
To integrate the toolkit into your global environment, add the following to your shell profile:

```bash
# Black Hat Python Toolkit Aliases
alias bhp='~/cyber/black_hat_python/bash_utils/run.sh'
alias bhp-new='~/cyber/black_hat_python/bash_utils/create.sh'
alias bhp-rm='~/cyber/black_hat_python/bash_utils/remove.sh'

# Operational Note
The environment utilizes an isolated Python Virtual Environment to manage security-specific dependencies (such as scapy and impacket), ensuring the host system remains stable and clean.

👨‍💻 Developer Profile
Samuel Girma Software Engineering Student | Adama Science and Technology University (ASTU) Passionate about Cybersecurity, Data Engineering, and Scalable SaaS Architecture.

<p align="center" style="font-size: 0.85em; color: #6a737d;">
<i><b>Disclaimer:</b> This repository is intended strictly for educational purposes and ethical security research. Unauthorized use of these tools against systems without explicit permission is illegal.</i>
</p>
