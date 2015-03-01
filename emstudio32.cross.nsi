
/******************************************************************************
    WORKAROUND - lnkX64IconFix
        This snippet was developed to address an issue with Windows 
        x64 incorrectly redirecting the shortcuts icon from $PROGRAMFILES32 
        to $PROGRAMFILES64.
 
    See Forum post: http://forums.winamp.com/newreply.php?do=postreply&t=327806
 
    Example:
        CreateShortcut "$SMPROGRAMS\My App\My App.lnk" "$INSTDIR\My App.exe" "" "$INSTDIR\My App.exe"
        ${lnkX64IconFix} "$SMPROGRAMS\My App\My App.lnk"
 
    Original Code by Anders [http://forums.winamp.com/member.php?u=70852]
 ******************************************************************************/
!ifndef ___lnkX64IconFix___
    !verbose push
    !verbose 0
 
    !include "LogicLib.nsh"
    !include "x64.nsh"
 
    !define ___lnkX64IconFix___
    !define lnkX64IconFix `!insertmacro _lnkX64IconFix`
    !macro _lnkX64IconFix _lnkPath
        !verbose push
        !verbose 0
        ${If} ${RunningX64}
            DetailPrint "WORKAROUND: 64bit OS Detected, Attempting to apply lnkX64IconFix"
            Push "${_lnkPath}"
            Call lnkX64IconFix
        ${EndIf}
        !verbose pop
    !macroend
 
    Function lnkX64IconFix ; _lnkPath
        Exch $5
        Push $0
        Push $1
        Push $2
        Push $3
        Push $4
        System::Call 'OLE32::CoCreateInstance(g "{00021401-0000-0000-c000-000000000046}",i 0,i 1,g "{000214ee-0000-0000-c000-000000000046}",*i.r1)i'
        ${If} $1 <> 0
            System::Call '$1->0(g "{0000010b-0000-0000-C000-000000000046}",*i.r2)'
            ${If} $2 <> 0
                System::Call '$2->5(w r5,i 2)i.r0'
                ${If} $0 = 0
                    System::Call '$1->0(g "{45e2b4ae-b1c3-11d0-b92f-00a0c90312e1}",*i.r3)i.r0'
                    ${If} $3 <> 0
                        System::Call '$3->5(i 0xA0000007)i.r0'
                        System::Call '$3->6(*i.r4)i.r0'
                        ${If} $0 = 0 
                            IntOp $4 $4 & 0xffffBFFF
                            System::Call '$3->7(ir4)i.r0'
                            ${If} $0 = 0 
                                System::Call '$2->6(i0,i0)'
                                DetailPrint "WORKAROUND: lnkX64IconFix Applied successfully"
                            ${EndIf}
                        ${EndIf}
                        System::Call $3->2()
                    ${EndIf}
                ${EndIf}
                System::Call $2->2()
            ${EndIf}
            System::Call $1->2()
        ${EndIf} 
        Pop $4
        Pop $3
        Pop $2
        Pop $1
        Pop $0
    FunctionEnd
    !verbose pop
!endif



; The name of the installer
Name "EMStudio"

!ifndef QTDIR
  !error "Please define QT installation directory via /DQTDIR=/home/michael/QtWin32"
!endif


; The file to write
OutFile "EMStudioInstaller.exe"

; The default installation directory
InstallDir $PROGRAMFILES\EMStudio

InstallDirRegKey HKLM "Software\EMStudio" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "EMStudio (Required)" ;No components page, name is not important

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  ; These files should be local to this script
  ;File "/home/michael/code/emstudio/release/emstudio.exe"
  ;File "/home/michael/code/emstudio/src/gauges.qml"
  ;File "/home/michael/code/emstudio/freeems.config.json"
  File "emstune\core\release\emstudio.exe"
  File "emsload\release\emsload.exe"
  File "emslogview\release\emslogview.exe"
  
  

  SetOutPath "$INSTDIR\definitions"
  File "emstune\core\freeems.config.json"
  File "emstune\core\decodersettings.json"
  SetOutPath "$INSTDIR\dashboards"
  File "emstune\core\src\gauges.qml"
  SetOutPath "$INSTDIR\dashboards\WarningLabel"
  File "emstune\core\src\WarningLabel\WarningLabel.qml"
  SetOutPath "$INSTDIR\wizards"
  File "emstune\core\wizards\BenchTest.qml"
  File "emstune\core\wizards\DecoderOffset.qml"
  File "emstune\core\wizards\wizard.qml"
  SetOutPath "$INSTDIR\plugins"
!ifndef PLUGIN
  File "emstune\core\plugins\libreemsplugin.dll"
!else
  File "emstune\core\plugins\${PLUGIN}"
!endif
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\EMStudio "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EMStudio" "DisplayName" "EMStudio"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EMStudio" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EMStudio" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EMStudio" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
SectionEnd ; end the section

Section "Qt Components"

  SetOutPath $INSTDIR

;  File ${QTDIR}\bin\libgcc_s_dw2-1.dll
;  File ${QTDIR}\bin\libstdc++-6.dll
;  File ${QTDIR}\bin\libwinpthread-1.dll
  File ${QTDIR}\bin\Qt5WebKitWidgets.dll
  File ${QTDIR}\bin\Qt5MultimediaWidgets.dll
  File ${QTDIR}\bin\Qt5Multimedia.dll
  File ${QTDIR}\bin\Qt5Gui.dll
  File ${QTDIR}\bin\Qt5Core.dll
  File ${QTDIR}\bin\icuin51.dll
  File ${QTDIR}\bin\icuuc51.dll
  File ${QTDIR}\bin\icudt51.dll
  File ${QTDIR}\bin\Qt5Network.dll
  File ${QTDIR}\bin\Qt5Widgets.dll
  File ${QTDIR}\bin\Qt5OpenGL.dll
  File ${QTDIR}\bin\Qt5PrintSupport.dll
  File ${QTDIR}\bin\Qt5WebKit.dll
  File ${QTDIR}\bin\Qt5Quick.dll
  File ${QTDIR}\bin\Qt5Qml.dll
  File ${QTDIR}\bin\Qt5Sql.dll
  File ${QTDIR}\bin\Qt5Positioning.dll
  File ${QTDIR}\bin\Qt5Sensors.dll
  File ${QTDIR}\bin\Qt5Declarative.dll
  File ${QTDIR}\bin\Qt5XmlPatterns.dll
  File ${QTDIR}\bin\Qt5Xml.dll
  File ${QTDIR}\bin\Qt5Script.dll
  File ${QTDIR}\bin\Qt5Svg.dll
  File ${QTDIR}\bin\Qt5Test.dll
  File ${QTDIR}\bin\Qt5SerialPort.dll


SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\EMStudio"
  CreateShortCut "$SMPROGRAMS\EMStudio\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\EMStudio\EMSTune.lnk" "$INSTDIR\emstudio.exe" "" "$INSTDIR\emstudio.exe" 0
  CreateShortCut "$SMPROGRAMS\EMStudio\EMSLoad.lnk" "$INSTDIR\emsload.exe" "" "$INSTDIR\emsload.exe" 0
  CreateShortCut "$SMPROGRAMS\EMStudio\EMSLogView.lnk" "$INSTDIR\emslogview.exe" "" "$INSTDIR\emslogview.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EMStudio"
  DeleteRegKey HKLM SOFTWARE\EMStudio

  ; Remove files and uninstaller
  Delete $INSTDIR\emstudio.exe
  Delete $INSTDIR\emsload.exe
  Delete $INSTDIR\emslogview.exe
  Delete $INSTDIR\uninstall.exe
  Delete $INSTDIR\*.*"
  Delete $INSTDIR\dashboards\*.*"
  Delete $INSTDIR\dashboards\WarningLabel\*.*"
  Delete $INSTDIR\definitions\*.*"
  Delete $INSTDIR\plugins\*.*"
  Delete $INSTDIR\wizards\*.*"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\EMStudio\*.*"

  ; Remove directories used
  RMDir "$INSTDIR\dashboards\WarningLabel"
  RMDir "$INSTDIR\dashboards"
  RMDir "$INSTDIR\definitions"
  RMDir "$INSTDIR\plugins"
  RMDir "$INSTDIR\wizards"
  RMDir "$SMPROGRAMS\EMStudio"
  RMDir "$INSTDIR"

SectionEnd
