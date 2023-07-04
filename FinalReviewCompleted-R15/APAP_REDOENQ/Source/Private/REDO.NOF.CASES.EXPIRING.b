* @ValidationCode : MjotMTM3Mjc0NzgwNjpDcDEyNTI6MTY4NDg1MTk4MTgxODpJVFNTOi0xOi0xOjUwMToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 501
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.CASES.EXPIRING(Y.FINAL.ARRAY)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.CASE.USER
*--------------------------------------------------------------------------------
*Description : This routine is used to display the Values of the particular user
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.NOF.CASE.USER
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   02-06-2011       DHAMU S                 CRM                Initial Creation
* 30-Jul-2012        Madhupriya             PACS00209533        Code to include the NO of days to expire
* 13-APRIL-2023      Harsha                R22 Auto Conversion  - SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    GOSUB INIT
    GOSUB OPEN
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    Y.ID = ''; Y.CUST.VAL = ''; Y.SUPPORT.GROUP = ''; Y.RES.DATE = ''; Y.STATUS = ''; Y.APPL = ''; Y.DATE = '';Y.CLOSING.STATUS = ''
    Y.EXP.DAYS = ''
    NO.OF.DAYS = ''  ; RETURN.FLAG = ''
    COMPLAINT.FLAG = ''
    NO.OF.DAYS = 'C'
RETURN
******
OPEN:
******
    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS  = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.REDO.ISSUE.REQUESTS = 'F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS  = ''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

RETURN
**********
PROCESS:
*********
    LOCATE "APPLICATION" IN D.FIELDS<1> SETTING APL.POS THEN
        Y.APPL = D.RANGE.AND.VALUE<APL.POS>
        D.RANGE.AND.VALUE<APL.POS>=''
        D.LOGICAL.OPERANDS<APL.POS>=''
        D.FIELDS<APL.POS>=''
    END

    LOCATE "DATE.RESOLUTION" IN D.FIELDS<1> SETTING DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<DATE.POS>
        GOSUB CHECK.DATE
    END
    IF Y.APPL THEN
        GOSUB CHECK.CASE
    END ELSE
        GOSUB CHECK.CLAIMS
        GOSUB CHECK.REQUESTS
        GOSUB CHECK.COMPLAINTS
    END

RETURN

**************
CHECK.DATE:
************
    Y.COUNT =DCOUNT(Y.DATE,@SM)
    Y.TXN.DATE1 = FIELD(Y.DATE,@SM,1)
    Y.TXN.DATE2 = FIELD(Y.DATE,@SM,2)
    IF Y.TXN.DATE2 THEN
        IF NOT(NUM(Y.TXN.DATE1)) OR LEN(Y.TXN.DATE1) NE '8' OR NOT(NUM(Y.TXN.DATE2)) OR LEN(Y.TXN.DATE2) NE '8' THEN
            ENQ.ERROR = "EB-REDO.DATE.RANGE"
        END ELSE
            IF Y.TXN.DATE1[5,2] GT '12' OR Y.TXN.DATE2[5,2] GT '12' OR Y.TXN.DATE1[7,2] GT '31' OR Y.TXN.DATE2[7,2] GT '31' OR Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
                ENQ.ERROR = "EB-REDO.DATE.RANGE"
            END
        END
    END
RETURN

***********
CHECK.CASE:
***********
    BEGIN CASE
        CASE Y.APPL EQ "RECLAMACION"
            GOSUB CHECK.CLAIMS
        CASE Y.APPL EQ "SOLICITUD"
            GOSUB CHECK.REQUESTS
        CASE Y.APPL EQ "QUEJAS"
            GOSUB CHECK.COMPLAINTS
    END CASE

RETURN
**************
CHECK.CLAIMS:
*************

    FILE.NAME = FN.REDO.ISSUE.CLAIMS
    APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '',SEL.CMD)	;*R22 Manual Conversion - Added APAP.REDOENQ
    CLAIM.FLAG = '1'
    GOSUB GET.VALUES
RETURN
***************
CHECK.REQUESTS:
***************
    CLAIM.FLAG = '' ;
    FILE.NAME = FN.REDO.ISSUE.REQUESTS
    APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '',SEL.CMD)	;*R22 Manual Conversion - Added APAP.REDOENQ
    RETURN.FLAG = '1'
    GOSUB GET.VALUES
RETURN
*****************
CHECK.COMPLAINTS:
*****************
    CLAIM.FLAG = '';RETURN.FLAG = ''
    FILE.NAME = FN.REDO.ISSUE.COMPLAINTS
    APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '',SEL.CMD)	;*R22 Manual Conversion - Added APAP.REDOENQ
    COMPLAINT.FLAG = '1'
    GOSUB GET.VALUES
RETURN
************
GET.VALUES:
************
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.ID FROM SEL.LIST SETTING SEL.POS
    WHILE Y.SEL.ID:SEL.POS
        IF CLAIM.FLAG EQ '1' THEN
            GOSUB CLAIMS.GET.VALUES
        END
        IF RETURN.FLAG EQ '1' THEN
            GOSUB REQUESTS.GET.VALUES
        END
        IF COMPLAINT.FLAG EQ '1' THEN
            GOSUB COMPLAINTS.GET.VALUES
        END
    REPEAT
RETURN
********************
CLAIMS.GET.VALUES:
*****************
    CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.SEL.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CLAIMS.ERR)
    Y.CLOSING.STATUS = R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.STATUS>
    IF Y.CLOSING.STATUS EQ '' THEN
        Y.ID            = Y.SEL.ID
        Y.CUST.VAL      = R.REDO.ISSUE.CLAIMS<ISS.CL.CUSTOMER.CODE>
        Y.CASE.TYPE = R.REDO.ISSUE.CLAIMS<ISS.CL.TYPE>
        Y.SUPPORT.GROUP = R.REDO.ISSUE.CLAIMS<ISS.CL.SUPPORT.GROUP>
        Y.RES.DATE      = R.REDO.ISSUE.CLAIMS<ISS.CL.DATE.RESOLUTION>
        Y.STATUS        = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>
        Y.RECORD.STATUS = R.REDO.ISSUE.CLAIMS<ISS.CL.RECORD.STATUS>
*PACS00209533
        Y.CLOSE.DATE = ''
        Y.CLOSE.DATE = TODAY
        IF LEN(Y.RES.DATE) EQ 8 THEN
            CALL CDD('',Y.RES.DATE,Y.CLOSE.DATE,NO.OF.DAYS)
            Y.EXP.DAYS = ABS(NO.OF.DAYS)
        END
        GOSUB FINAL.ARRAY
    END
RETURN
********************
REQUESTS.GET.VALUES:
********************
    CALL F.READ(FN.REDO.ISSUE.REQUESTS,Y.SEL.ID,R.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS,REQUESTS.ERR)
    Y.CLOSING.STATUS = R.REDO.ISSUE.REQUESTS<ISS.REQ.CLOSING.STATUS>
    IF Y.CLOSING.STATUS EQ '' THEN
        Y.ID            = Y.SEL.ID
        Y.CUST.VAL      = R.REDO.ISSUE.REQUESTS<ISS.REQ.CUSTOMER.CODE>
        Y.CASE.TYPE = R.REDO.ISSUE.REQUESTS<ISS.REQ.TYPE>
        Y.SUPPORT.GROUP = R.REDO.ISSUE.REQUESTS<ISS.REQ.SUPPORT.GROUP>
        Y.RES.DATE      = R.REDO.ISSUE.REQUESTS<ISS.REQ.DATE.RESOLUTION>
        Y.STATUS        = R.REDO.ISSUE.REQUESTS<ISS.REQ.STATUS>
        Y.RECORD.STATUS = R.REDO.ISSUE.REQUESTS<ISS.REQ.RECORD.STATUS>
*PACS00209533
        Y.CLOSE.DATE = ''
        Y.CLOSE.DATE = TODAY
        IF LEN(Y.RES.DATE) EQ 8 THEN
            CALL CDD('',Y.RES.DATE,Y.CLOSE.DATE,NO.OF.DAYS)
            Y.EXP.DAYS = ABS(NO.OF.DAYS)
        END
        GOSUB FINAL.ARRAY
    END
RETURN
*********************
COMPLAINTS.GET.VALUES:
**********************
    CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,Y.SEL.ID,R.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS,COMPLAINT.ERR)
    Y.CLOSING.STATUS  = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CLOSING.STATUS>
    IF Y.CLOSING.STATUS EQ '' THEN
        Y.ID            = Y.SEL.ID
        Y.CUST.VAL      = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CUSTOMER.CODE>
        Y.CASE.TYPE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.TYPE>
        Y.SUPPORT.GROUP = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SUPPORT.GROUP>
        Y.RES.DATE      = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.DATE.RESOLUTION>
        Y.STATUS        = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.STATUS>
        Y.RECORD.STATUS = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.RECORD.STATUS>
*PACS00209533
        Y.CLOSE.DATE = ''
        Y.CLOSE.DATE = TODAY
        IF LEN(Y.RES.DATE) EQ 8 THEN
            CALL CDD('',Y.RES.DATE,Y.CLOSE.DATE,NO.OF.DAYS)
            Y.EXP.DAYS = ABS(NO.OF.DAYS)
        END
        GOSUB FINAL.ARRAY

    END
RETURN
*************
FINAL.ARRAY:
************
    Y.FINAL.ARRAY<-1> = Y.CUST.VAL:"*":Y.ID:"*":Y.CASE.TYPE:"*":Y.SUPPORT.GROUP:"*":Y.RES.DATE:"*":Y.STATUS:"*":Y.EXP.DAYS
    Y.CUST.VAL = ''; Y.ID = ''; Y.SUPPORT.GROUP = ''; Y.CASE.TYPE = '' ; Y.RES.DATE = ''; Y.STATUS = '' ; Y.EXP.DAYS = ''  ; NO.OF.DAYS = ''
    NO.OF.DAYS = 'C'
RETURN
******************************
END
*----------End of Program---------------------------------------------------
