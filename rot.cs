using System;
using System.IO;
using System.Windows.Forms;

class Rot {
    [STAThread]
    public static void Main() {
        var dialog = new OpenFileDialog();

        if (dialog.ShowDialog() == DialogResult.OK) {
            try
            {
                using (var readStream = dialog.OpenFile())
                {
                    bool encoding = true;
                    if (dialog.FileName.EndsWith(".rot")) {
                        encoding = false;
                    }
                    if (readStream != null) 
                    {
                        var buffer = new byte[4096];
                        FileStream writeStream;
                        if (encoding) {
                            writeStream = File.Open(dialog.FileName + ".rot",FileMode.Create);
                        } else {
                            writeStream = File.Open(
                                dialog.FileName.Substring(0,dialog.FileName.LastIndexOf(".rot"))
                                ,FileMode.Create);
                        }
                        int bytesRead = 1;
                        while (bytesRead != 0) {
                            bytesRead = readStream.Read(buffer,0,4096);
                            if (encoding) {
                                for (var i = 0; i < bytesRead; i++) {
                                    unchecked {
                                        buffer[i] = (byte)(buffer[i] + 13);
                                    }
                                }
                            } else {
                                for (var i = 0; i < bytesRead; i++) {
                                    unchecked {
                                        buffer[i] = (byte)(buffer[i] - 13);
                                    }
                                }
                            }
                            writeStream.Write(buffer,0,bytesRead);
                        }
                        readStream.Close();
                        writeStream.Close();
                        File.Delete(dialog.FileName);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Out.Write(ex.Message);
            }
        }
    }
}