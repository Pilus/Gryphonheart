using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GH_UnitTest {
    public partial class Form1 : Form {
        TestList testList;
        public Form1() {
            InitializeComponent();
            testList = new TestList();
            UpdateDisplay();
        }

        private String GetUnitTestInfo(FilePair pair) {
            if (pair.codeFile != null) {
                return pair.codeFile.Name;
            }
            else {
                return pair.unitTestFile.Name;
            }
        }

        public TreeNode UpdateTreeNode(FilePairDirectory dir) {
            TreeNode node = new TreeNode();
            node.Text = dir.Name;

            foreach (FilePair filePair in dir.files) {
                node.Nodes.Add(GetUnitTestInfo(filePair));
            }            

            return node;
        }

        public void UpdateTreeNodeCollection(TreeNodeCollection col,FilePairDirectory dir) {

            col.Clear();

            foreach (KeyValuePair<String ,FilePairDirectory> pair in dir.dirs) {
                FilePairDirectory subDir = pair.Value;
                col.Add(UpdateTreeNode(subDir));
            }

            foreach (FilePair filePair in dir.files) {
                col.Add(GetUnitTestInfo(filePair));
            }            

        }

        private void UpdateDisplay() {
            TreeView tree = treeView1;
            UpdateTreeNodeCollection(tree.Nodes, testList.fileDir);
        }


         

        private void button1_Click(object sender, EventArgs e) {
            testList.Update();
            UpdateDisplay();
        }

        private void button2_Click(object sender, EventArgs e) {
            this.Close();
        }

    }
}
