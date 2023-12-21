* @ValidationCode : Mjo2OTU2MDE0NzpVVEYtODoxNzAyNTMzMjY5OTQzOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Dec 2023 11:24:29
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.BM
PROGRAM AB.GET.FC.PARAM
    
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to@FM, D to D.VAR,= to EQ ,<> to NE, IF STATEMENT MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*13-12-2023       Narmadha V                  Manual R22 Conversion       intialise FN variable,Changed hardcoced value to FN variable.
*----------------------------------------------------------------------------------------
    
*==============================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.FILE.CONTROL

*==============================================================================

    GOSUB INITIALISATION

    GOSUB GET.PARAMETER.OPTIONS

    IF ERR.MSG THEN
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
    END ELSE
        GOSUB PROCESS.FILES
    END

    STOP
*

*===============================================================================
INITIALISATION:
*
    FN.MNEMONIC.COMPANY = "F.MNEMONIC.COMPANY" ;* Manual R22 Conversion - intialise FN variable
    F.MNEMONIC.COMPANY = ''
* OPEN 'F.MNEMONIC.COMPANY' TO F.MNEMONIC.COMPANY ELSE
    OPEN FN.MNEMONIC.COMPANY TO F.MNEMONIC.COMPANY ELSE ;*Manual R22 Conversion - Changed hardcoced value to FN variable.
        ERR.MSG = 'Unable to open MNEMONIC.COMPANY'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
    FN.COMPANY = "F.COMPANY" ;* Manual R22 Conversion - intialise FN variable
    F.COMPANY = ''
*OPEN F.COMPANY TO F.COMPANY ELSE
    OPEN FN.COMPANY TO F.COMPANY ELSE ;*Manual R22 Conversion - Changed hardcoced value to FN variable.
        ERR.MSG = 'Unable to open COMPANY'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
    FN.PGM.FILE = "F.PGM.FILE" ;* Manual R22 Conversion - intialise FN variable
    F.PGM.FILE = ''
*OPEN 'F.PGM.FILE' TO F.PGM.FILE ELSE
    OPEN FN.PGM.FILE TO F.PGM.FILE ELSE ;*Manual R22 Conversion - Changed hardcoced value to FN variable.
        ERR.MSG = 'Unable to open PGM.FILE'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
    FN.FILE.CONTROL = "F.FILE.CONTROL" ;* Manual R22 Conversion - intialise FN variable
    F.FILE.CONTROL = ""
*OPEN F.FILE.CONTROL TO F.FILE.CONTROL ELSE
    OPEN FN.FILE.CONTROL TO F.FILE.CONTROL ELSE ;*Manual R22 Conversion - Changed hardcoced value to FN variable.
        ERR.MSG = 'Unable to open FILE.CONTROL'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
    FN.VOC = "F.VOC" ;* Manual R22 Conversion - intialise FN variable
    F.VOC = ""
* OPEN F.VOC TO F.VOC ELSE
    OPEN FN.VOC TO F.VOC ELSE ;*Manual R22 Conversion - Changed hardcoced value to FN variable.
        ERR.MSG = 'Unable to open VOC'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
    FN.UFD = "&UFD&" ;* Manual R22 Conversion - intialise FN variable
    F.UFD = ""
*OPEN '','&UFD&' TO F.UFD ELSE
    OPEN FN.UFD TO F.UFD ELSE ;*Manual R22 Conversion - Changed hardcoced value to FN variable.
        ERR.MSG = 'Unable to open &UFD&'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
*
    DIM R.FILE.CONTROL(20)
    R.REC = ""

    COMPANIES.LIST = ''
    LIST.PARAM.FILE = ''
    BATCH.JOB.COUNT = ''
    BATCH.JOB.LIST = ''
    COMPANIES.TO.BE.INCLUDED = ''
    FILE.COUNT = 0  ;* Initialise number of files to compare
    TRUE = 1
    FALSE = 0

RETURN

*===============================================================================
GET.PARAMETER.OPTIONS:
*
*
    COMMAND.FILE = ''
    COMMAND.LINE = TRIM(@SENTENCE)
    C = INDEX(COMMAND.LINE,'AB.GET.FC.PARAM',1) + LEN('AB.GET.FC.PARAM')
    IF C GT 0 THEN ;*R22 AUTO CODE CONVERSION -START
        COMMAND.FILE = COMMAND.LINE[C+1,LEN(COMMAND.LINE)-C]
    END ;*R22 AUTO CODE CONVERSION - END
    IF COMMAND.FILE NE '' THEN ;*R22 AUTO CODE CONVERSION
        UNIX.FILENAME = COMMAND.FILE
        OPENSEQ UNIX.FILENAME TO UNIX.FILE ELSE
            CREATE UNIX.FILE ELSE
                ERR.MSG = 'Unix filename ':UNIX.FILENAME:' cannot be created '
                PRINT ERR.MSG:'   hit <cr>':
                INPUT XXX
                STOP
            END
        END
        WEOFSEQ UNIX.FILE
    END ELSE
        ERR.MSG = 'Must specify the savelist file name - file where to save the result'
        PRINT ERR.MSG:'   hit <cr>':
        INPUT XXX
        STOP
    END
*
    ERR.MSG = ''
    RUNNING.IN.JBASE = INDEX(SYSTEM(1021), 'TEMENOS',1)
*
RETURN
*
*===============================================================================
PROCESS.FILES:
*
    SQL.STATEMENT = 'SSELECT F.MNEMONIC.COMPANY'
    EXECUTE SQL.STATEMENT
    BATCH.JOB.COUNT = @SELECTED
    READLIST LIST.OF.COMPANIES ELSE LIST.OF.COMPANIES = ""
    LOOP
        REMOVE MNEMONIC.COMPANY FROM LIST.OF.COMPANIES SETTING MC.POS
    WHILE MNEMONIC.COMPANY : MC.POS DO
        READ REC.COMPANY.ID FROM F.MNEMONIC.COMPANY,MNEMONIC.COMPANY ELSE NULL
        READ REC.COMPANY FROM F.COMPANY,REC.COMPANY.ID ELSE NULL
        CONSOLIDATION.MARK = REC.COMPANY<EB.COM.CONSOLIDATION.MARK>
        IF CONSOLIDATION.MARK EQ "N" THEN
            COMPANIES.TO.BE.INCLUDED<-1> = MNEMONIC.COMPANY
            COMPANIES.LIST<-1> = REC.COMPANY.ID
        END
    REPEAT

    NUMBER.OF.COMPANIES = COUNT(COMPANIES.TO.BE.INCLUDED, @FM) + 1

    NUMBER.OF.FILES = 0
    SQL.STATEMENT = "SSELECT F.FILE.CONTROL WITH SYS.CLEAR.FILES EQ 'N' "
    SQL.STATEMENT := " AND CUS.CLEAR.FILES EQ 'N' AND SUFFIXES NE '' "
    EXECUTE SQL.STATEMENT
    READLIST ID.LIST ELSE ID.LIST = ""
    BATCH.JOB.COUNT = @SELECTED
    LOOP REMOVE CURRENT.FILE FROM ID.LIST SETTING D.VAR WHILE CURRENT.FILE:D.VAR ;*R22 AUTO CODE CONVERSION
        FOR COMPANY.COUNT = 1 TO NUMBER.OF.COMPANIES
            MATREAD R.FILE.CONTROL FROM F.FILE.CONTROL,CURRENT.FILE ELSE RECORD.EXISTS = 0
            MATREAD R.COMPANY FROM F.COMPANY,COMPANIES.LIST<COMPANY.COUNT> ELSE RECORD.EXISTS = 0
            IF R.FILE.CONTROL(EB.FILE.SYS.CLEAR.FILES) NE 'N' AND R.FILE.CONTROL(EB.FILE.SYS.CLEAR.FILES) THEN
                CONTINUE
            END
            FILE.CLASSIFICATION = R.FILE.CONTROL(EB.FILE.CONTROL.CLASS)
            Y.FILE.NAME = CURRENT.FILE
            GOSUB GET.MNEMONIC
            IF NOT(CLASS.OK) THEN
                ERR.MSG = "Classification error from MNEMONIC.CALCULATION ":CURRENT.FILE
                PRINT ERR.MSG:'   hit <cr>':
                INPUT XXX
                STOP
            END
*
            IF MNEMONIC EQ '' THEN ;*R22 AUTO CODE CONVERSION-START
                COMPANY.COUNT = NUMBER.OF.COMPANIES
            END ;*R22 AUTO CODE CONVERSION -END
            FULL.FILE.NAME = "F": MNEMONIC: ".": CURRENT.FILE
            READ R.REC FROM F.VOC,FULL.FILE.NAME ELSE CONTINUE
            READ R.REC FROM F.PGM.FILE,CURRENT.FILE ELSE CONTINUE
            WRITESEQ FULL.FILE.NAME TO UNIX.FILE ELSE
                ERR.MSG = 'CANNOT WRITE TO ':UNIX.FILENAME
                PRINT ERR.MSG:'   hit <cr>':
                INPUT XXX
                STOP
            END
            IF LIST.PARAM.FILE THEN
                LIST.PARAM.FILE := '@':FULL.FILE.NAME
            END ELSE
                LIST.PARAM.FILE = FULL.FILE.NAME
            END
        NEXT COMPANY.COUNT
    REPEAT
*
RETURN

*===============================================================================
GET.MNEMONIC:
*
    MNEMONIC = ""
    CLASS.OK = 1
    BEGIN CASE
        CASE FILE.CLASSIFICATION EQ "INT"
            MNEMONIC = ""
        CASE FILE.CLASSIFICATION EQ "CUS"
            MNEMONIC = R.COMPANY(EB.COM.CUSTOMER.MNEMONIC)
        CASE FILE.CLASSIFICATION EQ "FIN"
            MNEMONIC = R.COMPANY(EB.COM.MNEMONIC)
        CASE FILE.CLASSIFICATION EQ "FTF"
            MNEMONIC = R.COMPANY(EB.COM.FINAN.FINAN.MNE)
        CASE FILE.CLASSIFICATION EQ "CCY"
            MNEMONIC = R.COMPANY(EB.COM.CURRENCY.MNEMONIC)
        CASE FILE.CLASSIFICATION EQ "NOS"
            MNEMONIC = R.COMPANY(EB.COM.NOSTRO.MNEMONIC)
        CASE FILE.CLASSIFICATION EQ "CST" ;*R22 AUTO CODE CONVERSION
            SUBFIELD = R.COMPANY(EB.COM.SPCL.CUST.FILE)
            LOCATE Y.FILE.NAME IN SUBFIELD<1,1> SETTING POS ELSE POS = ""
            IF POS EQ "" THEN
                MNEMONIC = R.COMPANY(EB.COM.DEFAULT.CUST.MNE)
            END ELSE
                MNEMONIC = R.COMPANY(EB.COM.SPCL.CUST.MNE)<1,POS>
            END
        CASE FILE.CLASSIFICATION EQ "FTD" ;*R22 AUTO CODE CONVERSION
            SUBFIELD = R.COMPANY(EB.COM.SPCL.FIN.FILE)
            LOCATE Y.FILE.NAME IN SUBFIELD<1,1> SETTING POS ELSE POS = ""
            IF POS EQ "" THEN
                MNEMONIC = R.COMPANY(EB.COM.DEFAULT.FINAN.MNE)
            END ELSE
                MNEMONIC = R.COMPANY(EB.COM.SPCL.FIN.MNE)<1,POS>
            END
        CASE OTHERWISE
            CLASS.OK = 0
    END CASE
*
RETURN
*

END
