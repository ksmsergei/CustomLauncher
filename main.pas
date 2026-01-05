{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.JSON,
  System.IOUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Math;

type
  TfrmMain = class(TForm)
    lblName: TLabel;
    lblStartVariant: TLabel;
    lbVariants: TListBox;
    pnlButtons: TPanel;
    btnCancel: TButton;
    btnStart: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lbVariantsDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FCloseOnLaunch: Boolean;
    FDebugEnabled: Boolean;
    function FParseConfigFile: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  DEFAULT_WIDTH = 715;
  DEFAULT_HEIGHT = 645;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure WinExec(const ACmdLine: string; const ACmdShow: UINT = SW_SHOWNORMAL);
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  CmdLine: string;
begin
  Assert(ACmdLine <> '');

  CmdLine := ACmdLine;
  UniqueString(CmdLine);

  FillChar(SI, SizeOf(SI), 0);
  FillChar(PI, SizeOf(PI), 0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := STARTF_USESHOWWINDOW;
  SI.wShowWindow := ACmdShow;

  SetLastError(ERROR_INVALID_PARAMETER);
  {$WARN SYMBOL_PLATFORM OFF}
  Win32Check(CreateProcess(nil, PChar(CmdLine), nil, nil, False, CREATE_DEFAULT_ERROR_MODE {$IFDEF UNICODE} or CREATE_UNICODE_ENVIRONMENT{$ENDIF}, nil, nil, SI, PI));
  {$WARN SYMBOL_PLATFORM ON}
  CloseHandle(PI.hThread);
  CloseHandle(PI.hProcess);
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  var LIndex := lbVariants.ItemIndex;
  var LStringList := TStringList(lbVariants.Items.Objects[LIndex]);
  WinExec(LStringList.Strings[0]);

  if FCloseOnLaunch then
    Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  if not FParseConfigFile then
    Halt;

  lbVariants.Selected[0] := True;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  for var I := 0 to lbVariants.Items.Count - 1 do
    lbVariants.Items.Objects[I].Free;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if FDebugEnabled then
    Caption := Format('%d x %d', [Width, Height]);
end;

procedure TfrmMain.lbVariantsDblClick(Sender: TObject);
begin
  var LIndex := lbVariants.ItemAtPos(lbVariants.ScreenToClient(Mouse.CursorPos), True);
  if LIndex = -1 then
    Exit;
  btnStartClick(nil);
end;

function TfrmMain.FParseConfigFile: Boolean;
const
  TITLE_FIELD = 'title';
  VARIANTS_FIELD = 'variants';
  NAME_FIELD = 'name';
  COMMAND_FIELD = 'command';
  CLOSE_ON_LAUNCH_FIELD = 'closeOnLaunch';
  WIDTH_FIELD = 'windowSize.width';
  HEIGHT_FIELD = 'windowSize.height';
  DEBUG_FIELD = 'debug';
begin
  Result := True;

  // Неправильное количество параметров
  if ParamCount <> 1 then
  begin
    var LProgramName := TPath.GetFileName(ParamStr(0));
    Application.MessageBox(PWideChar('Использование программы:' + #13#10 + LProgramName + ' <JSON Конфиг>'), 'Неправильные аргументы', MB_OK + MB_ICONINFORMATION);
    Result := False;
    Exit;
  end;

  // Переданный файл конфига не существует
  var LConfigFileName := ParamStr(1);
  if not TFile.Exists(LConfigFileName) then
  begin
    Application.MessageBox(PWideChar('Переданный файл ''' + LConfigFileName + ''' не найден!'), 'Ошибка', MB_OK + MB_ICONSTOP);
    Result := False;
    Exit;
  end;

  var LContent := TEncoding.UTF8.GetString(TFile.ReadAllBytes(LConfigFileName));

  var LJSONValue := TJSONObject.ParseJSONValue(LContent);
  try
    // Недопустимый JSON
    if (LJSONValue = nil) or not (LJSONValue is TJSONObject) then
    begin
      Application.MessageBox('Недопустимый JSON-файл!', 'Ошибка', MB_OK + MB_ICONSTOP);
      Result := False;
      Exit;
    end;

    var LConfigObject := LJSONValue as TJSONObject;

    // Обработка заголовка лаунчера
    var LTitle: string;
    if not LConfigObject.TryGetValue<string>(TITLE_FIELD, LTitle) then
    begin
      Application.MessageBox('В конфиге нет поля ''' + TITLE_FIELD + '''!', 'Ошибка', MB_OK + MB_ICONSTOP);
      Result := False;
      Exit;
    end;
    lblName.Caption := LTitle;

    // Обработка вариантов запуска
    var LVariants: TJSONArray;
    if not LConfigObject.TryGetValue<TJSONArray>(VARIANTS_FIELD, LVariants) then
    begin
      Application.MessageBox('В конфиге нет поля ''' + VARIANTS_FIELD + '''!', 'Ошибка', MB_OK + MB_ICONSTOP);
      Result := False;
      Exit;
    end;

    if LVariants.Count = 0 then
    begin
      Application.MessageBox('В конфиге должен быть как минимум один вариант запуска', 'Предупреждение', MB_OK + MB_ICONWARNING);
      Result := False;
      Exit;
    end;

    // Обработка отдельных вариантов запуска
    lbVariants.Clear;
    for var LVariant in LVariants do
    begin
      var LName: string;
      if not LVariant.TryGetValue<string>(NAME_FIELD, LName) then
      begin
        Application.MessageBox('В одном из вариантов запуска нет поля ''' + NAME_FIELD + '''!', 'Ошибка', MB_OK + MB_ICONSTOP);
        Result := False;
        Exit;
      end;

      var LCommand: string;
      if not LVariant.TryGetValue<string>(COMMAND_FIELD, LCommand) then
      begin
        Application.MessageBox('В одном из вариантов запуска нет поля ''' + COMMAND_FIELD + '''!', 'Ошибка', MB_OK + MB_ICONSTOP);
        Result := False;
        Exit;
      end;

      var LStrings := TStringList.Create;
      LStrings.Add(LCommand);
      lbVariants.AddItem(' ' + LName, LStrings);
    end;

    // Необязательные параметры
    FCloseOnLaunch := LConfigObject.GetValue<Boolean>(CLOSE_ON_LAUNCH_FIELD, True);

    Width := LConfigObject.GetValue<Integer>(WIDTH_FIELD, DEFAULT_WIDTH);
    Height := LConfigObject.GetValue<Integer>(HEIGHT_FIELD, DEFAULT_HEIGHT);

    FDebugEnabled := LConfigObject.GetValue<Boolean>(DEBUG_FIELD, False);
    if FDebugEnabled then
    begin
      frmMain.BorderStyle := bsSizeToolWin;
    end;
  finally
    LJSONValue.Free;
  end;
end;

end.

