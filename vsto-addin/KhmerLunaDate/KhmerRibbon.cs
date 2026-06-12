using System;
using System.Diagnostics;
using System.Windows.Forms;
using Microsoft.Office.Tools.Ribbon;

namespace KhmerLunaDate
{
    public partial class KhmerRibbon
    {
        private void KhmerRibbon_Load(object sender, RibbonUIEventArgs e)
        {
        }

        private void btnOpenCalendar_Click(object sender, RibbonControlEventArgs e)
        {
            try
            {
                // Open the web calendar in default browser
                string url = "https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html";
                Process.Start(new ProcessStartInfo(url) { UseShellExecute = true });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Cannot open calendar: " + ex.Message, 
                    "Khmer Luna Date", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnInsertDate_Click(object sender, RibbonControlEventArgs e)
        {
            MessageBox.Show(
                "1. Open the calendar using 'បើកប្រតិទិន' button\n" +
                "2. Select a date and click Copy\n" +
                "3. Come back to Word and paste (Ctrl+V)",
                "How to Use",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
    }
}
