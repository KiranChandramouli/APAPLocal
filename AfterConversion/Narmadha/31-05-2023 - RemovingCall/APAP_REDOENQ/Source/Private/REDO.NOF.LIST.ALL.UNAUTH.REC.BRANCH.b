* @ValidationCode : MjotMTM2ODMzNzQxMjpDcDEyNTI6MTY4MjA3ODg3Mjk0ODpJVFNTOi0xOi0xOjUzNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 537
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.LIST.ALL.UNAUTH.REC.BRANCH(Y.ENQ.OUT)

* Program Description
* Subroutine Type   : ENQUIRY ROUTINE
* Attached to       : REDO.NOF.UNAUTH.RECORDS.BRANCH
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
*
* 18-APR-2023     Conversion tool   R22 Auto conversion    FM TO @FM, VM to @VM, ++ to +=, IF Condition added
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_SCREEN.VARIABLES
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_DAS.COMMON
    $INSERT I_DAS.GUI.EXCEPTION
    $INSERT I_DAS.VOC
    $INSERT I_F.USER
    $INSERT I_F.FILE.CONTROL
    $INSERT I_System
*
    $INSERT I_F.REDO.EXCEP.REC.PARAM
*

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*
*-------------------------------------------------------------------------
INITIALISE:
*~~~~~~~~~~
*
*   This para is used to initialise the variable
*
    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)

    FN.BRANCH.UNAUTH.LIST = 'F.BRANCH.UNAUTH.LIST'
    F.BRANCH.UNAUTH.LIST  = ''
    CALL OPF(FN.BRANCH.UNAUTH.LIST,F.BRANCH.UNAUTH.LIST)
    R.BRANCH.UNAUTH.LIST = ''

    FN.REDO.EXCEP.REC.PARAM = 'F.REDO.EXCEP.REC.PARAM'
    F.REDO.EXCEP.REC.PARAM  = ''
    CALL OPF(FN.REDO.EXCEP.REC.PARAM,F.REDO.EXCEP.REC.PARAM)
    R.REDO.EXCEP.REC.PARAM  = ''

*
    LREF.APPLN = "USER"
    LREF.FLDS  = "L.US.IDC.CODE":@VM:"L.US.IDC.BR"
    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POSN)
    POS.IDC.CODE = LREF.POSN<1,1>
    POS.IDC.BR   = LREF.POSN<1,2>
*
    CALL CACHE.READ(FN.REDO.EXCEP.REC.PARAM,'SYSTEM',R.REDO.EXCEP.REC.PARAM,EXCEP.ERR)
    Y.DEPT.CODES = R.REDO.EXCEP.REC.PARAM<EXCEP.DEPT.CODES>
    VAR.APPLICATION.NAME = R.REDO.EXCEP.REC.PARAM<EXCEP.APPLICATION.NAME>
    CHANGE @VM TO @FM IN Y.DEPT.CODES
    Y.ID.COMPANY =  System.getVariable('CURRENT.BRANCH.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion -START
        Y.ID.COMPANY = ""
    END					;*R22 Auto conversion - END


    VAR.SEP = '#'

    LOCATE "APPLICATION" IN D.FIELDS<1> SETTING APPL.POS THEN
        Y.SEL.APPL = D.RANGE.AND.VALUE<APPL.POS>
    END
*
RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------

    SEL.BRANCH  = 'SSELECT ':FN.BRANCH.UNAUTH.LIST
    SEL.BRANCH := ' WITH @ID LIKE ':Y.ID.COMPANY :'...'
    CALL EB.READLIST(SEL.BRANCH,BRANCH.LIST,'',BRANCH.NOR,LIST.ERR)
    Y.BR.CNT = 1
    LOOP
    WHILE Y.BR.CNT LE BRANCH.NOR
        Y.BRANCH.ID  = BRANCH.LIST<Y.BR.CNT>
        Y.DEPT.POS  = FIELD(Y.BRANCH.ID,'-',2)
        LOCATE Y.DEPT.POS IN Y.DEPT.CODES SETTING DEPT.POS THEN
            CALL F.READ(FN.BRANCH.UNAUTH.LIST,Y.BRANCH.ID,R.BRANCH.UNAUTH.LIST,F.BRANCH.UNAUTH.LIST,BRANCH.ERR)
            GOSUB READ.VALUES
        END
        Y.BR.CNT += 1
    REPEAT
RETURN

*------------------------------------------------------------------------
READ.VALUES:
*~~~~~~~~~~~

    Y.ID = R.BRANCH.UNAUTH.LIST
    Y.APPLICATION.POS = FIELD(FIELD(Y.ID,'-',1),',',1)
    Y.TRANSACTION.ID = FIELD(Y.ID,'-',2)
    FN.FILE.NAME =  'F.':Y.APPLICATION.POS:'$NAU'
    F.FILE.NAME  = ''
    CALL OPF(FN.FILE.NAME,F.FILE.NAME)
    CALL GET.STANDARD.SELECTION.DETS(Y.APPLICATION.POS,R.STANDARD.SELECTION)
    IF R.STANDARD.SELECTION THEN
        GOSUB MAP.VALUES.PARA
    END
RETURN
*
***************
MAP.VALUES.PARA:
***************

    LOCATE 'RECORD.STATUS' IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING POS THEN
        YSTFD = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,POS>
    END
    LOCATE 'INPUTTER' IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING POS1 THEN
        YINP = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,POS1>
    END
    CALL F.MATREAD(FN.FILE.NAME,Y.TRANSACTION.ID,MAT R.NEW,C$SYSDIM,F.FILE.NAME,FN.ER)
    IF NOT(FN.ER) THEN
        GOSUB LOOP.VAR.INIT
        YSTATUS     = R.NEW(YSTFD)[1,4]
        YINPUT      = R.NEW(YINP)
        INPUT.USR   = FIELD(YINPUT,'_',2)
        Y.USER      = INPUT.USR   ;******************************************* 6TH FIELD VALUE
        Y.RECORD.ID = Y.TRANSACTION.ID      ;***************************************************** 2ND FIELD VALUE
        Y.STATUS    = YSTATUS     ;******************************************* 3RD FIELD VALUE
        CALL CACHE.READ(FN.USER, INPUT.USR, R.USER.REC, ERR.USER) ;*R22 Auto conversion
        IF R.USER.REC THEN
            Y.IDC.CODE = R.USER.REC<EB.USE.LOCAL.REF,POS.IDC.CODE>          ;************* 4TH FIELD VALUE
            Y.BR.CODE  = R.USER.REC<EB.USE.LOCAL.REF,POS.IDC.BR>  ;************* 5TH FIELD VALUE
        END
        IF Y.SEL.APPL THEN
            IF Y.SEL.APPL EQ Y.APPLICATION.POS THEN
                GOSUB FORM.ARRAY
            END
        END  ELSE
            GOSUB FORM.ARRAY
        END
    END
RETURN
*---------------------------
LOOP.VAR.INIT:
*---------------------------
*
    YSTATUS     = ''
    Y.STATUS    = ''
    YINPUT      = ''
    INPUT.USR   = ''
    Y.RECORD.ID = ''
    R.USER.REC  = ''
    Y.IDC.CODE  = ''
    Y.BR.CODE   = ''
    Y.USER      = ''
*
RETURN
*
*************************************************************************
FORM.ARRAY:
*----------
*
    Y.DATA        = Y.APPLICATION.POS
    Y.DATA<-1>    = Y.RECORD.ID
    Y.DATA<-1>    = Y.STATUS
    Y.DATA<-1>    = Y.IDC.CODE
    Y.DATA<-1>    = Y.BR.CODE
    Y.DATA<-1>    = Y.USER
    Y.ENQ.OUT<-1> = CHANGE(Y.DATA,@FM,VAR.SEP)

RETURN

*************************************************************************
END
