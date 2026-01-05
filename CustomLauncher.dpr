program CustomLauncher;





uses
  Vcl.Forms,
  main in 'main.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
