using System;
using System.IO;
using System.Windows.Forms;

public class Refresher : Timer
{
    public Refresher()
    {
        Interval = ((int)Program.halfRefreshInterval.TotalSeconds)*2000;
        Tick += new EventHandler(Program.RecountDebt);
        Start();
    }
}

public class MainForm : Form
{
    private Label stopLabel = new Label();
    private DateTimePicker stopPicker = new DateTimePicker();
    private Label startLabel = new Label();
    private DateTimePicker startPicker = new DateTimePicker();
    private Button sleptWell = new Button();
    private Button sleptBadly = new Button();
    private Label debtLabel = new Label();
    public  TextBox debtValue = new TextBox();
    private Label wakeLabel ;
    private Label wakeValue = new Label();
    private Timer refresher;
    public static MainForm formHolder;
    public MainForm()
    {
        formHolder = this;
        Program.Store();
        FormBorderStyle = FormBorderStyle.Fixed3D;
        SizeGripStyle = SizeGripStyle.Hide;
        ShowIcon = false;
        MaximizeBox = false;
        AutoSize = true;
        AutoSizeMode = AutoSizeMode.GrowAndShrink;
        stopLabel.Text = "Спал с:";
        Place(stopLabel);
        stopPicker.Format = DateTimePickerFormat.Custom;
        stopPicker.CustomFormat = "dd/MM HH:mm";
        stopPicker.ShowUpDown = true;
        stopPicker.Value = Program.stopTime;
        Place(stopPicker);
        startLabel.Text = "До:";
        Place(startLabel);
        startPicker.Format = DateTimePickerFormat.Custom;
        startPicker.CustomFormat = "dd/MM HH:mm";
        startPicker.ShowUpDown = true;
        startPicker.Value = Program.startTime;
        Place(startPicker);
        debtLabel.Text = "Долг: (дн.чч:мм:сс)";
        Place(debtLabel);
        debtValue.Text = Program.debt.ToString(@"dd\.hh\:mm\:ss");
        Place(debtValue);
        sleptWell.Text = "Выспался";
        sleptWell.Click += new EventHandler(sleptWell_clicked);
        Place(sleptWell);
        sleptBadly.Text = "Сонный";
        sleptBadly.Click += new EventHandler(sleptBadly_clicked);
        Place(sleptBadly);
        if (Program.stopTime == Program.startTime)
        {
            slept();
        }
    }
    private void Place(Control control)
    {
        control.Dock = DockStyle.Bottom;
        Controls.Add(control);
    }
    private void sleptWell_clicked(Object o,EventArgs e)
    {
        debtValue.Text = TimeSpan.Zero.ToString();
        slept();
    }
    private void sleptBadly_clicked(Object o,EventArgs e)
    {
        slept();
    }
    private void slept()
    {
        refresher = new Refresher();
        FormClosing += new FormClosingEventHandler(Program.Store);
        Program.ChangeDebt(startPicker.Value-stopPicker.Value,(stopPicker.Value-Program.stopTime)+(Program.startTime-startPicker.Value));
        stopPicker.Enabled = false;
        startPicker.Enabled = false;
        Program.debt = TimeSpan.Parse(debtValue.Text);
        debtValue.Enabled = false;
        Controls.Remove(sleptWell);
        Controls.Remove(sleptBadly);
        wakeLabel = new Label();
        wakeLabel.Text = "Проснёшся в:";
        Place(wakeLabel);
        Place(wakeValue);
        ChangeDebt();
    }
    public static void ChangeDebt()
    {
        formHolder.debtValue.Text = Program.debt.ToString(@"dd\.hh\:mm\:ss");
        if (formHolder.debtValue != null)
        {
        formHolder.wakeValue.Text = DateTime.Now.Add(Program.debt).ToString();
        }
    }
}
public class Program
{
    public static DateTime stopTime;
    public static DateTime startTime;
    private static TimeSpan debtValue;
    public static TimeSpan debt 
    {
        get 
        {
            return debtValue;
        }
        set 
        {
            if (value<TimeSpan.Zero) 
            {
                debtValue = TimeSpan.Zero;
            } 
            else 
            {
                debtValue = value;
            }
        }
    }
    public static TimeSpan halfRefreshInterval = new TimeSpan(0,0,30);
    private static string path = "data";
    public static void Main()
    {
        if (File.Exists(path)) 
        {
            using (StreamReader sr = File.OpenText(path)) 
            {
                stopTime = DateTime.Parse(sr.ReadLine());
                debt = TimeSpan.Parse(sr.ReadLine());
            }
        } 
        else
        {
            stopTime = DateTime.Now;
            debt = TimeSpan.Zero;
        }
        startTime = DateTime.Now;
        Application.Run(new MainForm());
    }
    public static void RecountDebt(Object o,EventArgs e)
    {
        Program.RecountDebt();
    }
    public static void RecountDebt()
    {
        debt = debt + halfRefreshInterval; 
        Store();
    }
    public static void Store(Object o,EventArgs e)
    {
        Store();
    }
    public static void Store()
    {
        using (StreamWriter sw = File.CreateText(path))
        {
            sw.WriteLine(DateTime.Now.ToString());
            sw.WriteLine(debt.ToString());
            //sw.WriteLine(startTime.ToString());
        }
        MainForm.ChangeDebt();
    }
    public static void ChangeDebt(TimeSpan slept,TimeSpan haventSlept)
    {
        debt -= slept;
        debt += new TimeSpan(0,0,(int)(haventSlept.TotalSeconds/2));
    }
}