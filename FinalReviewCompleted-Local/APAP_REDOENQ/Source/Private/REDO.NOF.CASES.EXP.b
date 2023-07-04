* @ValidationCode : MjotNDk0NzgyODc6Q3AxMjUyOjE2ODE5OTU5ODg5ODc6SVRTUzotMTotMTo1MTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 518
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.CASES.EXP(Y.FINAL.ARRAY)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.CASES.EXP
*--------------------------------------------------------------------------------
*Description :This subroutine is attached to the ENQUIRY REDO.CASES.EXPIRED.UNCLOSED
*             which displays the details of the Claims,Requests and Complaints application
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.CASES.EXPIRED.UNCLOSED
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   02-06-2011       DHAMU S                 CRM                     Initial Creation
*  31-Jul-2012       Madhupriya            PACS00209536              Including additional column in the Enquiry
*                                                                    to display the no of days to expire.

* 13-APR-2023     Conversion tool    R22 Auto conversion            No changes
* 13-APR-2023      Harishvikram C    Manual R22 conversion          No changes
*--------------------------------------------------------------------------------------------------------

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
    Y.CUSTOMER.ID = ''; Y.ID = ''; Y.TYPE = ''; Y.RES.DATE = ''; Y.SER.COMP = '' ; Y.STATUS = ''; Y.APPL = ''; Y.GROUP = ''
    Y.EXP.DAYS = ''
    NO.OF.DAYS = 'C'
RETURN
*****
OPEN:
*****

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
********
PROCESS:
********

    LOCATE "APPLICATION" IN D.FIELDS<1> SETTING APPL.POS THEN
        Y.APPL = D.RANGE.AND.VALUE<APPL.POS>
    END

    LOCATE "SUPPORT.GROUP" IN D.FIELDS<1> SETTING GROUP.POS THEN
        Y.GROUP = D.RANGE.AND.VALUE<GROUP.POS>
    END

    IF Y.APPL THEN
        GOSUB CHECK.CASE
    END ELSE
        GOSUB CHECK.CLAIMS
        GOSUB CHECK.REQUESTS
        GOSUB CHECK.COMPLAINTS
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
****************
CHECK.CLAIMS:
****************
    SEL.CLAIM.CMD ="SELECT ":FN.REDO.ISSUE.CLAIMS:" WITH SER.AGR.COMP EQ EXPIRED AND (STATUS EQ OPEN OR STATUS EQ IN-PROCESS)"
    IF Y.GROUP THEN
        SEL.CLAIM.CMD :=" AND SUPPORT.GROUP EQ ":Y.GROUP
    END

    GOSUB GET.CLAIM.VALUES
RETURN
**************
CHECK.REQUESTS:
***************
    SEL.REQ.CMD ="SELECT ":FN.REDO.ISSUE.REQUESTS:" WITH SER.AGR.COMP EQ EXPIRED AND (STATUS EQ OPEN OR STATUS EQ IN-PROCESS)"
    IF Y.GROUP THEN
        SEL.REQ.CMD :=" AND SUPPORT.GROUP EQ ":Y.GROUP
    END
    GOSUB GET.REQ.VALUES
RETURN
*****************
CHECK.COMPLAINTS:
*****************
    SEL.COMP.CMD ="SELECT ":FN.REDO.ISSUE.COMPLAINTS:" WITH SER.AGR.COMP EQ EXPIRED AND (STATUS EQ OPEN OR STATUS EQ IN-PROCESS)"
    IF Y.GROUP THEN
        SEL.COMP.CMD :=" AND SUPPORT.GROUP EQ ":Y.GROUP
    END
    GOSUB GET.COMP.VALUES
RETURN
*****************
GET.CLAIM.VALUES:
*****************
    CALL EB.READLIST(SEL.CLAIM.CMD,SEL.CLAIM.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.ID FROM SEL.CLAIM.LIST SETTING SEL.POS
    WHILE Y.SEL.ID:SEL.POS
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.SEL.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CLAIM.ERR)
        Y.CUSTOMER.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.CUSTOMER.CODE>
        Y.ID = Y.SEL.ID
        Y.TYPE = R.REDO.ISSUE.CLAIMS<ISS.CL.TYPE>
        Y.RES.DATE = R.REDO.ISSUE.CLAIMS<ISS.CL.DATE.RESOLUTION>
        Y.SER.COMP = R.REDO.ISSUE.CLAIMS<ISS.CL.SER.AGR.COMP>
        Y.STATUS   = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>
*PACS00209536
        Y.CLOSE.DATE = ''
        Y.CLOSE.DATE = TODAY
        IF LEN(Y.RES.DATE) EQ 8 THEN
            CALL CDD('',Y.RES.DATE,Y.CLOSE.DATE,NO.OF.DAYS)
            Y.EXP.DAYS = ABS(NO.OF.DAYS)
        END

        GOSUB FINAL.ARRAY
    REPEAT
RETURN
***************
GET.REQ.VALUES:
****************
    CALL EB.READLIST(SEL.REQ.CMD,SEL.REQ.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.REQ.ID FROM SEL.REQ.LIST SETTING SEL.REQ.POS
    WHILE Y.SEL.REQ.ID:SEL.REQ.POS
        CALL F.READ(FN.REDO.ISSUE.REQUESTS,Y.SEL.REQ.ID,R.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS,REQUEST.ERR)
        Y.CUSTOMER.ID = R.REDO.ISSUE.REQUESTS<ISS.REQ.CUSTOMER.CODE>
        Y.ID          = Y.SEL.REQ.ID
        Y.TYPE        = R.REDO.ISSUE.REQUESTS<ISS.REQ.TYPE>
        Y.RES.DATE    = R.REDO.ISSUE.REQUESTS<ISS.REQ.DATE.RESOLUTION>
        Y.SER.COMP    = R.REDO.ISSUE.REQUESTS<ISS.REQ.SER.AGR.COMP>
        Y.STATUS      = R.REDO.ISSUE.REQUESTS<ISS.REQ.STATUS>
*PACS00209536
        Y.CLOSE.DATE = ''
        Y.CLOSE.DATE = TODAY
        IF LEN(Y.RES.DATE) EQ 8 THEN
            CALL CDD('',Y.RES.DATE,Y.CLOSE.DATE,NO.OF.DAYS)
            Y.EXP.DAYS = ABS(NO.OF.DAYS)
        END
        GOSUB FINAL.ARRAY
    REPEAT
RETURN
****************
GET.COMP.VALUES:
****************
    CALL EB.READLIST(SEL.COMP.CMD,SEL.COMP.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.COMP.ID FROM SEL.COMP.LIST SETTING SEL.COMP.POS
    WHILE Y.SEL.COMP.ID:SEL.COMP.POS
        CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,Y.SEL.COMP.ID,R.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS,COMPLAINT.ERR)
        Y.CUSTOMER.ID = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CUSTOMER.CODE>
        Y.ID          = Y.SEL.COMP.ID
        Y.TYPE        = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.TYPE>
        Y.RES.DATE    = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.DATE.RESOLUTION>
        Y.SER.COMP    = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SER.AGR.COMP>
        Y.STATUS      = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.STATUS>
*PACS00209536
        Y.CLOSE.DATE = ''
        Y.CLOSE.DATE = TODAY
        IF LEN(Y.RES.DATE) EQ 8 THEN
            CALL CDD('',Y.RES.DATE,Y.CLOSE.DATE,NO.OF.DAYS)
            Y.EXP.DAYS = ABS(NO.OF.DAYS)
        END
        GOSUB FINAL.ARRAY
    REPEAT
RETURN
************
FINAL.ARRAY:
************

    Y.FINAL.ARRAY<-1> = Y.CUSTOMER.ID:"*":Y.ID:"*":Y.TYPE:"*":Y.RES.DATE:"*":Y.SER.COMP:"*":Y.STATUS:"*":Y.EXP.DAYS
    Y.CUSTOMER.ID= ''; Y.ID = '' ; Y.TYPE = ''; Y.RES.DATE = ''; Y.SER.COMP = ''; Y.STATUS = ''  ; Y.EXP.DAYS = ''
    NO.OF.DAYS = ''
    NO.OF.DAYS = 'C'
RETURN
*************************
END
*--------------End of Program---------------------------------------------------------------------------
