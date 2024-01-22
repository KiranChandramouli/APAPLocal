* @ValidationCode : MjotODI0MzI4Mzc0OlVURi04OjE3MDU5MjMyNDEzODM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 17:04:01
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.LIST.ALL.UNAUTH.REC(Y.ENQ.OUT)
* Program Description
* Subroutine Type   : ENQUIRY ROUTINE
* Attached to       : REDO.NOF.UNAUTH.RECORDS
* Attached as       : NOFILE ROUTINE
* Primary Purpose   : To return data to the enquiry

* Incoming:  N/A
* ---------
*
* Outgoing:
* ---------
* Y.ENQ.OUT - Data returned to the enquiry
*--------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------
* DATE         WHO                REFERENCE              DESCRIPTION
* 05-04-11    SUDHARSANAN S      PACS00038166          Initial Creation
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , VM to @VM , FM to @FM and ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 19-01-2024         Narmadha V            R22 Utility Changes     ID Variable used instead of Hardcoding
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_SCREEN.VARIABLES
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_DAS.COMMON
    $INSERT I_DAS.GUI.EXCEPTION
    $INSERT I_DAS.VOC
    $INSERT I_F.USER
    $INSERT I_F.FILE.CONTROL
    $INSERT I_F.REDO.EXCEP.REC.PARAM
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------
INITIALISE:
*~~~~~~~~~~
*This para is used to initialise the variable
    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)
    FN.REDO.EXCEP.REC.PARAM = 'F.REDO.EXCEP.REC.PARAM'
*CALL CACHE.READ(FN.REDO.EXCEP.REC.PARAM,'SYSTEM',R.EXCEP.REC,EXCEP.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 Utility Changes
    CALL CACHE.READ(FN.REDO.EXCEP.REC.PARAM,IDVAR.1,R.EXCEP.REC,EXCEP.ERR);* R22 Utility Changes
    LREF.APPLN = "USER"
    LREF.FLDS = "L.US.IDC.CODE":@VM:"L.US.IDC.BR"
    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POSN)
    POS.IDC.CODE = LREF.POSN<1,1>
    POS.IDC.BR = LREF.POSN<1,2>
    VAR.SEP = '#'
RETURN
*-------------------------------------------------------------------------
PROCESS:
*~~~~~~~
*This main para is used fetch the files from parameter table REDO.EXCEP.REC.PARAM and displays all exception records.
    VAR.APPLICATION.NAME = R.EXCEP.REC<EXCEP.APPLICATION.NAME>
    IF NOT(VAR.APPLICATION.NAME) THEN
        ENQ.ERROR = "EB-NO.APP.PARAM.TABLE"
        RETURN
    END ELSE
        GOSUB GET.EXCEP.FILES
    END
RETURN
*-----------------------
GET.EXCEP.FILES:
*-----------------------
    CHANGE @VM TO @FM IN VAR.APPLICATION.NAME
    CNT.APPLICATION = DCOUNT(VAR.APPLICATION.NAME,@FM)
    LOCAL.CNT = 1
    LOOP
    WHILE LOCAL.CNT LE CNT.APPLICATION
        Y.APPLICATION = ''  ;F.FILE.NAME = ''
        Y.APPLICATION = VAR.APPLICATION.NAME<LOCAL.CNT>         ;*************1ST FIELD VALUE
        CALL GET.STANDARD.SELECTION.DETS(Y.APPLICATION,R.STANDARD.SELECTION)
        IF R.STANDARD.SELECTION THEN
            GOSUB READ.VALUES
        END
        LOCAL.CNT += 1
    REPEAT
RETURN
*------------------------------------------------------------------------
READ.VALUES:
*~~~~~~~~~~~
    F.FILE.NAME ='F.':Y.APPLICATION:'$NAU'
    F.FILE$NAU = ''
    CALL OPF(F.FILE.NAME,F.FILE$NAU)
    LOCATE 'RECORD.STATUS' IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING POS THEN
        YSTFD = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,POS>
    END
    LOCATE 'INPUTTER' IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING POS1 THEN
        YINP = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,POS1>
    END
    SEL.EXCEP = 'SSELECT ':F.FILE.NAME:' WITH RECORD.STATUS UNLIKE ...HLD'
    CALL EB.READLIST(SEL.EXCEP,EXCEP.LIST,'',NOR,LIST.ERR)
    CNT = 1
    LOOP
    WHILE CNT LE NOR
        Y.ID = EXCEP.LIST<CNT>
        CALL F.MATREAD(F.FILE.NAME,Y.ID,MAT R.NEW,C$SYSDIM,F.FILE$NAU,ER)
        IF NOT(ER) THEN
            GOSUB LOOP.VAR.INIT
            YSTATUS = R.NEW(YSTFD)[1,4]
            YINPUT = R.NEW(YINP)
            INPUT.USR = FIELD(YINPUT,'_',2)
            CALL CACHE.READ(FN.USER, INPUT.USR, R.USER.REC, ERR.USER)	;*R22 Auto Conversion  - F.READ to CACHE.READ
            Y.RECORD.ID = Y.ID      ;***************************************************** 2ND FIELD VALUE
            Y.STATUS = YSTATUS      ;******************************************* 3RD FIELD VALUE
            IF R.USER.REC THEN
                Y.IDC.CODE = R.USER.REC<EB.USE.LOCAL.REF,POS.IDC.CODE>        ;************* 4TH FIELD VALUE
                Y.BR.CODE = R.USER.REC<EB.USE.LOCAL.REF,POS.IDC.BR> ;************* 5TH FIELD VALUE
            END
            Y.USER = INPUT.USR      ;******************************************* 6TH FIELD VALUE
            GOSUB FORM.ARRAY
        END
        CNT += 1
    REPEAT
RETURN
*---------------------------
LOOP.VAR.INIT:
*---------------------------
    YSTATUS =''
    Y.STATUS =''
    YINPUT = ''
    INPUT.USR = ''
    Y.RECORD.ID = ''
    R.USER.REC = ''
    Y.IDC.CODE = ''
    Y.BR.CODE = ''
    Y.USER = ''
RETURN
*************************************************************************
FORM.ARRAY:
*----------
*VALUE NO :                 1                2                  3                 4                 5                6
    Y.ENQ.OUT<-1> = Y.APPLICATION:VAR.SEP:Y.RECORD.ID:VAR.SEP:Y.STATUS:VAR.SEP:Y.IDC.CODE:VAR.SEP:Y.BR.CODE:VAR.SEP:Y.USER
RETURN
*************************************************************************
END
