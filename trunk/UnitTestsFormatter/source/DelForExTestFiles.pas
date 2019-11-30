unit DelForExTestFiles;

{$OPTIMIZATION off}

interface

uses
  Classes,
  SysUtils,
  TestFrameWork,
  GX_CodeFormatterTypes,
  GX_CodeFormatterSettings,
  GX_CodeFormatterDefaultSettings,
  GX_CodeFormatterEngine,
  GX_GenericUtils;

type
  TTestTestfiles = class(TTestCase)
  private
    FFormatter: TCodeFormatterEngine;
    procedure TrimTrailingCrLf(_sl: TGxUnicodeStringList);
    procedure TestFile(const _Filename: string; _AllowFailure: Boolean = False);
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; virtual; abstract;
    function GetResultDir: string; virtual; abstract;
    function GetConfigDirBS: string;
    procedure SetUp; override;
    procedure TearDown; override;
    procedure ExecuteDoubleClickAction; override;
  published
    procedure testAbstractSealedClass;
    procedure testAttributes;
    procedure testAttributes2;
    procedure testAngledBrackets;
    procedure testAnonymous;
    procedure testAnonymous2;
    procedure testAnonymous3;
    procedure testAnonymous4;
    procedure testArabic;
    procedure testAsm;
    procedure testAsmProblem1;
    procedure testAssemblerNewlines;
    procedure testCharList;
    procedure testClassFields;
    procedure testClassInImplementation;
    procedure testClassProperties;
    procedure testClassProperties2;
    procedure testClassProperties3;
    procedure testClassVar;
    procedure testCommentEnd;
    procedure testCompilerDirectives;
    procedure testConstArray;
    procedure testConstSet;
    procedure testConstSetWithComment;
    procedure testConstSetWithCommentAtEnd;
    procedure testConstVar;
    procedure testConstWithLineBreak;
    procedure testControlChars;
    procedure testCurlyBracesInWhile;
    procedure testDisableFormatComment;
    procedure testDotFloat;
    procedure testElseAtEnd;
    procedure testEmptyProgram;
    procedure testEmptyStringAssignment;
    procedure testEmptyUnit;
    procedure testFakeGenericCreate;
    procedure testFinalMethod;
    procedure testFluentCode1;
    procedure testFluentCode2;
    procedure testFluentCode3;
    procedure testFormatWithLineBreaks;
    procedure testFormula;
    procedure testGenericClass;
    procedure testGenericClass2;
    procedure testGenericCreate;
    procedure testGenericField;
    procedure testGenericFunctions;
    procedure testGenericFunctions2;
    procedure testGenericFunctions3;
    procedure testGenericFunctions4;
    procedure testGenericInterface;
    procedure testGenericProcTypes;
    procedure testGenericRecord;
    procedure testGenericVariable;
    procedure testHashCharStrings;
    procedure testHexNumbers;
    procedure testIfAndThen;
    procedure testIfAndThen2;
    procedure testIfdefs;
    procedure testIfElseendif;
    procedure testIfInSet;
    procedure testIfThen;
    procedure testIfThenElse;
    procedure testIfThenElse2; virtual;
    procedure testIfThenElse3;
    procedure testIfThenElse4;
    procedure testIfThenTry;
    procedure testIndentComment;
    procedure testJustOpeningComment;
    procedure testJustOpeningStarCommentInAsm;
    procedure testLargeFile;
    procedure testNestedClass;
    procedure testNestedClass2;
    procedure testNestedClass3;
    procedure testNestedClass4;
    procedure testNestedClass5;
    procedure testNestedClass6;
    procedure testNestedEventType;
    procedure testNoGeneric;
    procedure testNoGeneric2;
    procedure testOperatorOverloading;
    procedure testQuotesError;
    procedure testReadWrite;
    procedure testRecordMethod;
    procedure testSetWithLinebreaks;
    procedure testSingleElse;
    procedure testSlashCommentToCurly;
    procedure testStarCommentAtEol;
    procedure testStrictVisibility;
    procedure testStringWithSingleQuotes;
    procedure testTabBeforeEndInAsm;
    procedure testTripleQuotes;
    procedure testTypeOf;
    procedure testUnicode;
    procedure testUnmatchedElse;
    procedure testUnmatchedEndif;
    procedure testUnmatchedIfdef;
    procedure testUnterminatedString;
    procedure testUsesWithComment;
    procedure testVariantExtendedRecord;

    procedure testComplex;
    procedure testCurlyHalfCommentEndCurrentlyFails;
    procedure testForLoopWithInlineVar1CurrentlyFails;
    procedure testForLoopWithInlineVar2CurrentlyFails;
    procedure testForLoopWithInlineVar3CurrentlyFails;
    procedure testForLoopWithInlineVar4CurrentlyFails;
    procedure testInlineConst1CurrentlyFails;
    procedure testInlineConst2CurrentlyFails;
    procedure testInlineVar1CurrentlyFails;
    procedure testInlineVar2CurrentlyFails;
    procedure testInlineVar3CurrentlyFails;
  end;

type
  TTestFilesHeadworkFormatting = class(TTestTestfiles)
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; override;
    function GetResultDir: string; override;
  published
  end;

type
  TTestFilesBorlandFormatting = class(TTestTestfiles)
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; override;
    function GetResultDir: string; override;
  end;

type
  TTestFilesDelforFormatting = class(TTestTestfiles)
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; override;
    function GetResultDir: string; override;
  end;

type
  TTestFilesDefaultFormatting = class(TTestTestfiles)
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; override;
    function GetResultDir: string; override;
  end;

type
  TTestFilesTwmFormatting = class(TTestTestfiles)
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; override;
    function GetResultDir: string; override;
  end;

type
  TTestFilesSpecial = class(TTestFilesTwmFormatting)
  protected
    function GetFormatSettings: TCodeFormatterEngineSettings; override;
    function GetResultDir: string; override;
  end;

implementation

uses
  Windows,
  ShellAPI,
  StrUtils,
  Dialogs,
  GX_CodeFormatterConfigHandler,
  GX_DbugIntf;

{ TTestTestfiles }

procedure TTestTestfiles.ExecuteDoubleClickAction;
const
  CURRENTLY_FAILS = 'CurrentlyFails';
var
  s: string;
  Filename: string;
  InFile: string;
  ExpectedFile: string;
  OutputFile: string;
  Params: string;
begin
  // 'testStarCommentAtEol'
  s := Self.FTestName;
  Assert(StartsText('test', s));
  s := Copy(s, 5);
  if EndsText(CURRENTLY_FAILS, s) then
    s := Copy(s, 1, Length(s) - Length(CURRENTLY_FAILS));

  Filename := 'testfile_' + s + '.pas';
  InFile := 'testcases\input\' + Filename;
  ExpectedFile := 'testcases\expected\' + GetResultDir + '\' + Filename;
  OutputFile := 'testcases\output\' + GetResultDir + '\' + Filename;
  Params := Format('"%s" "%s"', [ExpectedFile, OutputFile]);
  ShellExecute(0, '', PChar('C:\Program Files (x86)\Beyond Compare 3\bcompare.exe'),
    PChar(Params), '', SW_NORMAL);
end;

function TTestTestfiles.GetConfigDirBS: string;
begin
  Result := '..\binaries\';
end;

procedure TTestTestfiles.SetUp;
var
  Settings: TCodeFormatterEngineSettings;
begin
  inherited;
  Settings := GetFormatSettings;
  FFormatter := TCodeFormatterEngine.Create;
  FFormatter.Settings.Settings := Settings;
end;

procedure TTestTestfiles.TearDown;
begin
  inherited;
  FFormatter.Free;
end;

procedure TTestTestfiles.TrimTrailingCrLf(_sl: TGxUnicodeStringList);
var
  cnt: Integer;
begin
  cnt := _sl.Count;
  while cnt > 0 do begin
    if _sl[cnt - 1] <> '' then
      Exit;
    Dec(cnt);
    _sl.Delete(cnt);
  end;
end;

type
  EFileDoesNotExist = class(EAbort)

  end;

procedure TTestTestfiles.TestFile(const _Filename: string; _AllowFailure: Boolean);
var
  Filename: string;
  InFile: string;
  ExpectedFile: string;
  ExpectedText: TGxUnicodeStringList;
  st: TGxUnicodeStringList;
begin
  Filename := 'testfile_' + _Filename + '.pas';
  InFile := 'testcases\input\' + Filename;
  ExpectedFile := 'testcases\expected\' + GetResultDir + '\' + Filename;
  if not FileExists(InFile) then begin
//    ExpectedException := EFileDoesNotExist;
    raise EFileDoesNotExist.CreateFmt('Input file does not exist: %s', [InFile]);
  end;
  if not FileExists(ExpectedFile) then begin
    CheckTrue(CopyFile(PChar(InFile), PChar(ExpectedFile), True), 'Copying file failed');
    Self.Status('Warning: Input file was copied to expected!');
  end;

  ExpectedText := nil;
  st := TGxUnicodeStringList.Create;
  try
    st.LoadFromFile(InFile);
    ExpectedText := TGxUnicodeStringList.Create;
    ExpectedText.LoadFromFile(ExpectedFile);
    FFormatter.Execute(st);
    try
      TrimTrailingCrLf(ExpectedText);
      TrimTrailingCrLf(st);
// uncomment if you want to use e.g. BeyondCompare do the comparison
//      st.SaveToFile('testcases\output\' + GetResultDir + '\' + Filename);
      CheckEquals(ExpectedText.Text, st.Text, 'error in output');
    except
      on e: ETestFailure do begin
        st.SaveToFile('testcases\output\' + GetResultDir + '\' + Filename);
        if _AllowFailure then
          e.Message := 'known ' + e.Message;
        raise;
      end;
    end;
  finally
    ExpectedText.Free;
    st.Free;
  end;
end;

procedure TTestTestfiles.testStarCommentAtEol;
begin
  TestFile('StarCommentAtEol');
end;

procedure TTestTestfiles.testSlashCommentToCurly;
begin
  TestFile('SlashCommentToCurly');
end;

procedure TTestTestfiles.testStrictVisibility;
begin
  TestFile('strictvisibility');
end;

procedure TTestTestfiles.testCompilerDirectives;
begin
  TestFile('compilerdirectives');
end;

procedure TTestTestfiles.testComplex;
begin
  TestFile('complex');
end;

procedure TTestTestfiles.testAssemblerNewlines;
begin
  TestFile('assemblernewline');
end;

procedure TTestTestfiles.testAttributes;
begin
  TestFile('Attributes');
end;

procedure TTestTestfiles.testAttributes2;
begin
  TestFile('Attributes2');
end;

procedure TTestTestfiles.testIfAndThen;
begin
  TestFile('IfAndThen');
end;

procedure TTestTestfiles.testIfAndThen2;
begin
  TestFile('IfAndThen2');
end;

procedure TTestTestfiles.testIfdefs;
begin
  TestFile('ifdefs');
end;

procedure TTestTestfiles.testUnmatchedIfdef;
begin
  TestFile('unmatchedifdef');
end;

procedure TTestTestfiles.testUnmatchedElse;
begin
  TestFile('unmatchedelse');
end;

procedure TTestTestfiles.testUnmatchedEndif;
begin
  TestFile('unmatchedendif');
end;

procedure TTestTestfiles.testIfElseendif;
begin
  TestFile('IfElseEndif');
end;

procedure TTestTestfiles.testIfInSet;
begin
  TestFile('IfInSet');
end;

procedure TTestTestfiles.testIfThen;
begin
  TestFile('ifthen');
end;

procedure TTestTestfiles.testIfThenElse;
begin
  TestFile('ifthenelse');
end;

procedure TTestTestfiles.testIfThenElse2;
begin
  TestFile('ifthenelse2');
end;

procedure TTestTestfiles.testIfThenElse3;
begin
  TestFile('Ifthenelse3');
end;

procedure TTestTestfiles.testIfThenElse4;
begin
  TestFile('Ifthenelse4');
end;

procedure TTestTestfiles.testIfThenTry;
begin
  TestFile('ifthentry');
end;

procedure TTestTestfiles.testDisableFormatComment;
begin
  TestFile('DisableFormatComment');
end;

procedure TTestTestfiles.testLargeFile;
begin
  TestFile('LargeFile');
end;

procedure TTestTestfiles.testNestedClass;
begin
  TestFile('NestedClass');
end;

procedure TTestTestfiles.testNestedClass2;
begin
  TestFile('NestedClass2');
end;

procedure TTestTestfiles.testNestedClass3;
begin
  TestFile('NestedClass3');
end;

procedure TTestTestfiles.testNestedClass4;
begin
  TestFile('NestedClass4');
end;

procedure TTestTestfiles.testNestedClass5;
begin
  TestFile('NestedClass5');
end;

procedure TTestTestfiles.testNestedClass6;
begin
  TestFile('NestedClass6');
end;

procedure TTestTestfiles.testNestedEventType;
begin
  TestFile('NestedEventType');
end;

procedure TTestTestfiles.testNoGeneric;
begin
  TestFile('NoGeneric');
end;

procedure TTestTestfiles.testNoGeneric2;
begin
  TestFile('NoGeneric2');
end;

procedure TTestTestfiles.testOperatorOverloading;
begin
  TestFile('OperatorOverloading');
end;

procedure TTestTestfiles.testTripleQuotes;
begin
  TestFile('triplequotes');
end;

procedure TTestTestfiles.testTypeOf;
begin
  TestFile('TypeOf');
end;

procedure TTestTestfiles.testUnicode;
begin
  TestFile('unicode');
end;

procedure TTestTestfiles.testSingleElse;
begin
  TestFile('singleelse');
end;

procedure TTestTestfiles.testQuotesError;
begin
  TestFile('QuotesError');
end;

procedure TTestTestfiles.testReadWrite;
begin
  TestFile('ReadWrite');
end;

procedure TTestTestfiles.testRecordMethod;
begin
  TestFile('RecordMethod');
end;

procedure TTestTestfiles.testSetWithLinebreaks;
begin
  TestFile('SetWithLinebreaks');
end;

procedure TTestTestfiles.testJustOpeningComment;
begin
  TestFile('OpeningCommentOnly');
end;

procedure TTestTestfiles.testElseAtEnd;
begin
  TestFile('ElseAtEnd');
end;

procedure TTestTestfiles.testJustOpeningStarCommentInAsm;
begin
  // I actually thought this would crash...
  TestFile('OpeningStarCommentInAsm');
end;

procedure TTestTestfiles.testTabBeforeEndInAsm;
begin
  TestFile('TabBeforeEndInAsm');
end;

procedure TTestTestfiles.testEmptyProgram;
begin
  TestFile('EmptyProgram');
end;

procedure TTestTestfiles.testEmptyUnit;
begin
  TestFile('EmptyUnit');
end;

procedure TTestTestfiles.testIndentComment;
begin
  TestFile('IndentComment');
end;

procedure TTestTestfiles.testInlineConst1CurrentlyFails;
begin
  TestFile('InlineConst1');
end;

procedure TTestTestfiles.testInlineConst2CurrentlyFails;
begin
  TestFile('InlineConst2');
end;

procedure TTestTestfiles.testInlineVar1CurrentlyFails;
begin
  TestFile('InlineVar1');
end;

procedure TTestTestfiles.testInlineVar2CurrentlyFails;
begin
  TestFile('InlineVar2');
end;

procedure TTestTestfiles.testInlineVar3CurrentlyFails;
begin
  TestFile('InlineVar3');
end;

procedure TTestTestfiles.testUnterminatedString;
begin
  TestFile('UnterminatedString');
end;

procedure TTestTestfiles.testUsesWithComment;
begin
  TestFile('UsesWithComment');
end;

procedure TTestTestfiles.testVariantExtendedRecord;
begin
  TestFile('VariantExtendedRecord');
end;

procedure TTestTestfiles.testStringWithSingleQuotes;
begin
  // note this actually contains a string with the TEXT #13#10:
  // >hello ' #13#10);<
  TestFile('StringWithSingleQuote');
end;

procedure TTestTestfiles.testEmptyStringAssignment;
begin
  TestFile('EmptyStringAssignment');
end;

procedure TTestTestfiles.testHashCharStrings;
begin
  TestFile('HashCharStrings');
end;

procedure TTestTestfiles.testDotFloat;
begin
  TestFile('DotFloat');
end;

procedure TTestTestfiles.testHexNumbers;
begin
  TestFile('HexNumbers');
end;

procedure TTestTestfiles.testConstArray;
begin
  TestFile('ConstArray');
end;

procedure TTestTestfiles.testConstSet;
begin
  TestFile('ConstSet');
end;

procedure TTestTestfiles.testConstSetWithComment;
begin
  TestFile('ConstSetWithComment');
end;

procedure TTestTestfiles.testConstSetWithCommentAtEnd;
begin
  TestFile('ConstSetWithCommentAtEnd');
end;

procedure TTestTestfiles.testControlChars;
begin
  TestFile('ControlChars');
end;

procedure TTestTestfiles.testConstVar;
begin
  TestFile('ConstVar');
end;

procedure TTestTestfiles.testConstWithLineBreak;
begin
  TestFile('ConstWithLineBreak');
end;

procedure TTestTestfiles.testGenericCreate;
begin
  TestFile('GenericCreate');
end;

procedure TTestTestfiles.testFakeGenericCreate;
begin
  TestFile('FakeGenericCreate');
end;

procedure TTestTestfiles.testForLoopWithInlineVar1CurrentlyFails;
begin
  TestFile('ForLoopWithInlineVar1');
end;

procedure TTestTestfiles.testForLoopWithInlineVar2CurrentlyFails;
begin
  TestFile('ForLoopWithInlineVar2');
end;

procedure TTestTestfiles.testForLoopWithInlineVar3CurrentlyFails;
begin
  TestFile('ForLoopWithInlineVar3');
end;

procedure TTestTestfiles.testForLoopWithInlineVar4CurrentlyFails;
begin
  TestFile('ForLoopWithInlineVar4');
end;

procedure TTestTestfiles.testFormatWithLineBreaks;
begin
  TestFile('FormatWithLineBreaks');
end;

procedure TTestTestfiles.testFormula;
begin
  TestFile('Formula');
end;

procedure TTestTestfiles.testFinalMethod;
begin
  TestFile('FinalMethod');
end;

procedure TTestTestfiles.testFluentCode1;
begin
  TestFile('FluentCode1');
end;

procedure TTestTestfiles.testFluentCode2;
begin
  TestFile('FluentCode2');
end;

procedure TTestTestfiles.testFluentCode3;
begin
  TestFile('FluentCode3');
end;

procedure TTestTestfiles.testGenericClass;
begin
  TestFile('GenericClass');
end;

procedure TTestTestfiles.testGenericClass2;
begin
  TestFile('GenericClass2');
end;

procedure TTestTestfiles.testGenericField;
begin
  TestFile('GenericField');
end;

procedure TTestTestfiles.testGenericFunctions;
begin
  TestFile('GenericFunctions');
end;

procedure TTestTestfiles.testGenericFunctions2;
begin
  TestFile('GenericFunctions2');
end;

procedure TTestTestfiles.testGenericFunctions3;
begin
  TestFile('GenericFunctions3');
end;

procedure TTestTestfiles.testGenericFunctions4;
begin
  TestFile('GenericFunctions4');
end;

procedure TTestTestfiles.testGenericInterface;
begin
  TestFile('GenericInterface');
end;

procedure TTestTestfiles.testGenericProcTypes;
begin
  TestFile('GenericProcTypes');
end;

procedure TTestTestfiles.testGenericRecord;
begin
  TestFile('GenericRecord');
end;

procedure TTestTestfiles.testGenericVariable;
begin
  TestFile('GenericVariable');
end;

procedure TTestTestfiles.testAbstractSealedClass;
begin
  TestFile('AbstractSealedClass');
end;

procedure TTestTestfiles.testAngledBrackets;
begin
  TestFile('AngledBrackets');
end;

procedure TTestTestfiles.testAnonymous;
begin
  TestFile('Anonymous');
end;

procedure TTestTestfiles.testAnonymous2;
begin
  TestFile('Anonymous2');
end;

procedure TTestTestfiles.testAnonymous3;
begin
  TestFile('Anonymous3');
end;

procedure TTestTestfiles.testAnonymous4;
begin
  TestFile('Anonymous4');
end;

procedure TTestTestfiles.testArabic;
begin
  TestFile('Arabic');
end;

procedure TTestTestfiles.testAsm;
begin
  TestFile('asm');
end;

procedure TTestTestfiles.testAsmProblem1;
begin
  TestFile('AsmProblem1');
end;

procedure TTestTestfiles.testCharList;
begin
  TestFile('CharList');
end;

procedure TTestTestfiles.testClassFields;
begin
  TestFile('ClassFields');
end;

procedure TTestTestfiles.testClassInImplementation;
begin
  TestFile('ClassInImplementation');
end;

procedure TTestTestfiles.testClassProperties;
begin
  TestFile('ClassProperties');
end;

procedure TTestTestfiles.testClassProperties2;
begin
  TestFile('ClassProperties2');
end;

procedure TTestTestfiles.testClassProperties3;
begin
  TestFile('ClassProperties3');
end;

procedure TTestTestfiles.testClassVar;
begin
  TestFile('ClassVar');
end;

procedure TTestTestfiles.testCommentEnd;
begin
  TestFile('CommentEnd');
end;

procedure TTestTestfiles.testCurlyBracesInWhile;
begin
  TestFile('CurlyBracesInWhile');
end;

procedure TTestTestfiles.testCurlyHalfCommentEndCurrentlyFails;
begin
  TestFile('CurlyHalfCommentEnd', True);
end;

{ TTestFilesHeadworkFormatting }

function TTestFilesHeadworkFormatting.GetFormatSettings: TCodeFormatterEngineSettings;
var
  Settings: TCodeFormatterSettings;
begin
  Settings := TCodeFormatterSettings.Create;
  try
    TCodeFormatterConfigHandler.ImportFromFile(GetConfigDirBS + 'FormatterSettings-headwork.ini', Settings);
    Result := Settings.Settings;
  finally
    Settings.Free;
  end;
end;

function TTestFilesHeadworkFormatting.GetResultDir: string;
begin
  Result := 'headwork';
end;

{ TTestFilesBorlandFormatting }

function TTestFilesBorlandFormatting.GetFormatSettings: TCodeFormatterEngineSettings;
begin
  Result := BorlandDefaults;
end;

function TTestFilesBorlandFormatting.GetResultDir: string;
begin
  Result := 'borland';
end;

{ TTestFilesDelforFormatting }

function TTestFilesDelforFormatting.GetFormatSettings: TCodeFormatterEngineSettings;
var
  Settings: TCodeFormatterSettings;
begin
  Settings := TCodeFormatterSettings.Create;
  try
    TCodeFormatterConfigHandler.ImportFromFile(GetConfigDirBS + 'FormatterSettings-DelForEx.ini', Settings);
    Result := Settings.Settings;
  finally
    Settings.Free;
  end;
end;

function TTestFilesDelforFormatting.GetResultDir: string;
begin
  Result := 'delforex';
end;

{ TTestFilesDefaultFormatting }

function TTestFilesDefaultFormatting.GetFormatSettings: TCodeFormatterEngineSettings;
var
  Settings: TCodeFormatterSettings;
begin
  Settings := TCodeFormatterSettings.Create;
  try
    Result := Settings.Settings;
  finally
    Settings.Free;
  end;
end;

function TTestFilesDefaultFormatting.GetResultDir: string;
begin
  Result := 'default'
end;

{ TTestFilesTwmFormatting }

function TTestFilesTwmFormatting.GetFormatSettings: TCodeFormatterEngineSettings;
var
  Settings: TCodeFormatterSettings;
begin
  Settings := TCodeFormatterSettings.Create;
  try
    TCodeFormatterConfigHandler.ImportFromFile(GetConfigDirBS + 'FormatterSettings-twm.ini', Settings);
    Result := Settings.Settings;
  finally
    Settings.Free;
  end;
end;

function TTestFilesTwmFormatting.GetResultDir: string;
begin
  Result := 'twm';
end;

{ TTestFilesSpecial }

function TTestFilesSpecial.GetFormatSettings: TCodeFormatterEngineSettings;
begin
  Result := inherited GetFormatSettings;
  Result.ExceptSingle := True;
end;

function TTestFilesSpecial.GetResultDir: string;
begin
  Result := 'special';
end;

initialization
  RegisterTest(TTestFilesBorlandFormatting.Suite);
  RegisterTest(TTestFilesDefaultFormatting.Suite);
  RegisterTest(TTestFilesDelforFormatting.Suite);
  RegisterTest(TTestFilesHeadworkFormatting.Suite);
  RegisterTest(TTestFilesSpecial.Suite);
  RegisterTest(TTestFilesTwmFormatting.Suite);
end.
