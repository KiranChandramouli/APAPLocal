* @ValidationCode : MjotMTUwMTYxMjE4OTpDcDEyNTI6MTY4MjU3Mjg0NjY3ODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 10:50:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.OVERRIDE.DISPLAY(Y.FINAL.ARRAY)


* Description: This routine is the nofile enquiry routine to fetch the details of
* account closure records in INAO status

*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26-02-2011      H GANESH      PACS00034162    Initial Draft
* 22-12-2011      S Sudharsanan PACS00164629    Modify as per the issue
* 08-11-2012      MARIMUTHU S   PACS00232596
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CLOSE.ACCT
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.USER
	$USING APAP.REDOENQ

    GOSUB INIT
    GOSUB PROCESS
RETURN


* ----------------------------------------------------------------------------
INIT:
* ----------------------------------------------------------------------------

    Y.FINAL.ARRAY=''
    Y.DATA=''
    Y.OVERRIDE=''
    Y.ID = ''

    FN.USER='F.USER'
    F.USER=''
    CALL OPF(FN.USER,F.USER)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CLOSURE='F.ACCOUNT.CLOSURE$NAU'
    F.ACCOUNT.CLOSURE=''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.REDO.CLOSE.ACCT = 'F.REDO.CLOSE.ACCT'
    F.REDO.CLOSE.ACCT  = ''
    R.REDO.CLOSE.ACCT  = ''
    CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    LOC.REF.APP = 'ACCOUNT':@FM:'ACCOUNT.CLOSURE'
    LOC.REF.FIELD = 'L.AC.AZ.ACC.REF':@FM:'L.CLOSE.MODE'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    POS.L.AC.AZ.ACC.REF = LOC.REF.POS<1,1>
    POS.L.CLOSE.MODE = LOC.REF.POS<2,1>

RETURN
***********
PROCESS:
***********
*PACS00164629 - S
    LOCATE '@ID' IN D.FIELDS<1> SETTING ID.POS THEN
        Y.ID = D.RANGE.AND.VALUE<ID.POS>
        CALL F.READ(FN.ACCOUNT,Y.ID,R.ACC,F.ACCOUNT,ACC.ERRR)
        IF NOT(R.ACC) THEN
            CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ID,R.ALT.ACC,F.ALTERNATE.ACCOUNT,ALT.ACC.ERR)
            Y.ID = R.ALT.ACC<AAC.GLOBUS.ACCT.NUMBER>
        END
    END
    IF Y.ID THEN
        D.RANGE.AND.VALUE<ID.POS> = Y.ID
        CALL F.READ(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)
        IF R.AZ.ACC THEN
            D.RANGE.AND.VALUE<ID.POS> = R.AZ.ACC<AZ.INTEREST.LIQU.ACCT>
        END ELSE
            GOSUB CLOSURE.ACCOUNT
        END
    END

    CALL APAP.REDOENQ.RedoEFormSelStmt(FN.ACCOUNT.CLOSURE, '', '', SEL.ACC.CLOSE)
    CALL EB.READLIST(SEL.ACC.CLOSE,ACC.LIST,'',NO.OF.REC,SEL.ERR)
*PACS00164629 - E


    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        Y.ACC.ID=ACC.LIST<Y.VAR1>
        CALL F.READ(FN.ACCOUNT.CLOSURE,Y.ACC.ID,R.ACC.CLOSE,F.ACCOUNT.CLOSURE,ACC.CLS.ERR)
        Y.OVERRIDE=R.ACC.CLOSE<AC.ACL.OVERRIDE>
        Y.CLOSE.MODE = R.ACC.CLOSE<AC.ACL.LOCAL.REF,POS.L.CLOSE.MODE>
        GOSUB FORM.OVERRIDE
        Y.INPUTTER=R.ACC.CLOSE<AC.ACL.INPUTTER>
        GOSUB FORM.INPUTTER
        IF NOT(Y.ID) THEN
            Y.FINAL.ARRAY<-1>=Y.ACC.ID:'#':Y.FIN.OVERRIDE:'#':Y.INP.FINAL:'#':Y.CLOSE.MODE
        END ELSE
            Y.FINAL.ARRAY<-1>=Y.ID:'#':Y.FIN.OVERRIDE:'#':Y.INP.FINAL:'#':Y.CLOSE.MODE
        END
        Y.VAR1 += 1
    REPEAT

RETURN

****************
CLOSURE.ACCOUNT:
****************

    CALL F.READ(FN.REDO.CLOSE.ACCT,Y.ID,R.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT,ERR.CLS.AC)
    IF R.REDO.CLOSE.ACCT THEN
        IF R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT> NE '' THEN
            D.RANGE.AND.VALUE<ID.POS> = R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT>
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ID,R.ACC,F.ACCOUNT,ACC.ERR)
        VAR.ACCOUNT = R.ACC<AC.LOCAL.REF,POS.L.AC.AZ.ACC.REF>
        IF VAR.ACCOUNT THEN
            D.RANGE.AND.VALUE<ID.POS> = ''
        END
    END
RETURN

*-------------------------------------------------------------
FORM.OVERRIDE:
*-------------------------------------------------------------

    MESS=R.ACC.CLOSE<AC.ACL.OVERRIDE>
    MSG = ''
    CTR = 0
    NO.OF.MSG = DCOUNT(MESS,@VM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE NO.OF.MSG
        MAIN.TEXT = MESS<1,Y.VAR2,1>
        OVER.CLASS.TEXT = ''
        IF MESS<1,Y.VAR2,2> THEN
            OVER.CLASS.TEXT := '*':MESS<1,Y.VAR2,2>
        END
        IF MESS<1,Y.VAR2,3> THEN
            OVER.CLASS.TEXT := '*':MESS<1,Y.VAR2,3>
        END
        CHANGE '~' TO @FM IN MAIN.TEXT

        CHANGE '{' TO @FM IN MAIN.TEXT

        CHANGE '}' TO @VM IN MAIN.TEXT

        CALL TXT(MAIN.TEXT)
        IF CTR EQ 0 THEN
            MSG = MAIN.TEXT:OVER.CLASS.TEXT
            CTR = 1
        END ELSE
            MSG = MSG:@VM:MAIN.TEXT:OVER.CLASS.TEXT
        END
        Y.VAR2 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.FIN.OVERRIDE=MSG



RETURN
*-------------------------------------------------------------
FORM.INPUTTER:
*-------------------------------------------------------------
    Y.INPUTTER.CNT=DCOUNT(Y.INPUTTER,@VM)
    Y.INP.FINAL=''
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE Y.INPUTTER.CNT
        Y.INP=Y.INPUTTER<1,Y.VAR3>
        Y.INP=FIELD(Y.INP,'_',2)
        Y.INP=FIELD(Y.INP,'_',1)
        CALL CACHE.READ(FN.USER, Y.INP, R.USER.RECORD, USER.ERR) ;*R22 AUTO CODE CONVERSION
        Y.INP.FINAL<1,-1>=R.USER.RECORD<EB.USE.USER.NAME>
        Y.VAR3 += 1
    REPEAT

RETURN
*-----------------------------------------------------------
END
