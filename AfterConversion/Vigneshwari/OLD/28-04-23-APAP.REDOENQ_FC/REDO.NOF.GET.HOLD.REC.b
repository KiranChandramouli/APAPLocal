* @ValidationCode : MjoxOTkwNDQ0NTYwOkNwMTI1MjoxNjgyNTgwNzIyMzY1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 13:02:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.GET.HOLD.REC(Y.FINAL.ARRAY)
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.GET.APPL
*--------------------------------------------------------------------------------
*Description : This routine is used to display the hold record for the cases
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.ENQ.GET.HOLD
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date             Who                  Reference               Description
*    ------          ------               -----------             --------------
*   07-06-2011       DHAMU S                 CRM                Initial Creation
*   02-07-2011      Sudharsanan S          PACS00024006        Modify the Logic
*
* 18-APR-2023      Conversion tool   R22 Auto conversion        VM to @VM
* 18-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*-------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_F.REDO.FRONT.REQUESTS
    $INSERT I_F.REDO.FRONT.COMPLAINTS
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*****
INIT:
*****
    Y.ERR.FLAG = '';Y.ID = ''; Y.SHORT.NAME = ''; Y.CUST.CODE = '' ; Y.APPL = '' ;Y.CU.SEGMENTO = ''; Y.ACCOUNT.OFFICER = ''; Y.DATE.TIME = ''
    Y.CUS.LOCAL = '' ; Y.SUPPORT.GROUP = '';Y.LEGAL.ID = ''; Y.CASE.TYPE = '' ; Y.CU.CIDENT = ''; Y.CU.NOUNICO = ''; Y.CU.ACTANAC = '';
    Y.CU.RNC = '';Y.FINAL.ARRAY = '';Y.CUST.ID.NUMBER = ''
RETURN
*****
OPEN.FILES:
*****

    FN.REDO.FRONT.CLAIMS.NAU     = 'F.REDO.FRONT.CLAIMS$NAU'
    F.REDO.FRONT.CLAIMS.NAU      = ''
    CALL OPF(FN.REDO.FRONT.CLAIMS.NAU,F.REDO.FRONT.CLAIMS.NAU)

    FN.REDO.FRONT.COMPLAINTS.NAU = 'F.REDO.FRONT.COMPLAINTS$NAU'
    F.REDO.FRONT.COMPLAINTS.NAU  = ''
    CALL OPF(FN.REDO.FRONT.COMPLAINTS.NAU,F.REDO.FRONT.COMPLAINTS.NAU)

    FN.REDO.FRONT.REQUESTS.NAU   = 'F.REDO.FRONT.REQUESTS$NAU'
    F.REDO.FRONT.REQUESTS.NAU    = ''
    CALL OPF(FN.REDO.FRONT.REQUESTS.NAU,F.REDO.FRONT.REQUESTS.NAU)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    APL.ARRAY = 'CUSTOMER'
    APL.FIELD = 'L.CU.CIDENT':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.RNC':@VM:'L.CU.SEGMENTO'
    FLD.POS   = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.CU.CIDENT.POS    = FLD.POS<1,1>
    LOC.L.CU.NOUNICO.POS   = FLD.POS<1,2>
    LOC.L.CU.ACTANAC.POS   = FLD.POS<1,3>
    LOC.L.CU.RNC.POS       = FLD.POS<1,4>
    LOC.L.CU.SEGMENTO.POS  = FLD.POS<1,5>

RETURN

********
PROCESS:
*********
    LOCATE "APPLICATION" IN D.FIELDS<1> SETTING APP.POS THEN
        Y.APPL = D.RANGE.AND.VALUE<APP.POS>
        D.RANGE.AND.VALUE<APP.POS>=''
        D.LOGICAL.OPERANDS<APP.POS>=''
        D.FIELDS<APP.POS>=''
    END

    LOCATE "CUSTOMER.CODE" IN D.FIELDS<1> SETTING CUS.POS THEN
        Y.CUST.CODE = D.RANGE.AND.VALUE<CUS.POS>
        Y.CUST.CODE.OPR = D.LOGICAL.OPERANDS<CUS.POS>
    END

    LOCATE "CUST.ID.NUMBER" IN D.FIELDS<1> SETTING VAL.POS THEN
        Y.CUS.LOCAL = D.RANGE.AND.VALUE<VAL.POS>
        Y.CUS.LOCAL.OPR = D.LOGICAL.OPERANDS<VAL.POS>
    END

    LOCATE "SUPPORT.GROUP" IN D.FIELDS<1> SETTING GROUP.POS THEN
        Y.SUPPORT.GROUP  = D.RANGE.AND.VALUE<GROUP.POS>
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
*************
CHECK.CLAIMS:
*************
    FILE.NAME = FN.REDO.FRONT.CLAIMS.NAU
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.CLAIM.CMD) ;*Manual R22 conversion
    GOSUB GET.CLAIM.VALUES
RETURN
**************
CHECK.REQUESTS:
***************
    FILE.NAME = FN.REDO.FRONT.REQUESTS.NAU
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.REQ.CMD) ;*Manual R22 conversion
    GOSUB GET.REQ.VALUES
RETURN
*****************
CHECK.COMPLAINTS:
*****************
    FILE.NAME = FN.REDO.FRONT.COMPLAINTS.NAU
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.COMP.CMD) ;*Manual R22 conversion
    GOSUB GET.COMP.VALUES
RETURN
*****************
GET.CLAIM.VALUES:
******************
    CALL EB.READLIST(SEL.CLAIM.CMD,SEL.CLAIM.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.CLAIM.ID FROM SEL.CLAIM.LIST SETTING SEL.CLAIM.POS
    WHILE Y.SEL.CLAIM.ID:SEL.CLAIM.POS
        CALL F.READ(FN.REDO.FRONT.CLAIMS.NAU,Y.SEL.CLAIM.ID,R.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS.NAU,CLAIMS.ERR)
        Y.RECORD.STATUS = R.REDO.FRONT.CLAIMS<FR.CL.RECORD.STATUS>
        IF Y.RECORD.STATUS EQ "IHLD" THEN
            Y.CUSTOMER.ID = R.REDO.FRONT.CLAIMS<FR.CL.CUSTOMER.CODE>
            Y.CASE.TYPE = R.REDO.FRONT.CLAIMS<FR.CL.TYPE>
            Y.CUST.ID.NUMBER = R.REDO.FRONT.CLAIMS<FR.CL.CUST.ID.NUMBER>
            GOSUB CHECK.SELECTION
            IF Y.ERR.FLAG NE '1' THEN
                ID.VAL             = Y.SEL.CLAIM.ID
                Y.ID               = Y.CUSTOMER.ID
                Y.SHORT.NAME       = R.CUSTOMER<EB.CUS.SHORT.NAME>
                Y.CU.SEGMENTO      = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.SEGMENTO.POS>
                Y.ACCOUNT.OFFICER  = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
            END
            Y.DATE.TIME = R.REDO.FRONT.CLAIMS<FR.CL.DATE.TIME>
            Y.DATE.TIME = Y.DATE.TIME[1,6]
            Y.DATE.TIME = TODAY[1,2]:Y.DATE.TIME
            GOSUB FINAL.ARRAY
        END
* GOSUB FINAL.ARRAY
    REPEAT
RETURN
****************
GET.REQ.VALUES:
*****************
    CALL EB.READLIST(SEL.REQ.CMD,SEL.REQ.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.REQ.ID FROM SEL.REQ.LIST SETTING SEL.REQ.POS
    WHILE Y.SEL.REQ.ID:SEL.REQ.POS
        CALL F.READ(FN.REDO.FRONT.REQUESTS.NAU,Y.SEL.REQ.ID,R.REDO.FRONT.REQUESTS,F.REDO.FRONT.REQUESTS.NAU,REQUEST.ERR)
        Y.RECORD.STATUS = R.REDO.FRONT.REQUESTS<FR.CM.RECORD.STATUS>
        IF Y.RECORD.STATUS EQ "IHLD" THEN
            Y.CUSTOMER.ID  = R.REDO.FRONT.REQUESTS<FR.CM.CUSTOMER.CODE>
            Y.CASE.TYPE  = R.REDO.FRONT.REQUESTS<FR.CM.TYPE>
            Y.CUST.ID.NUMBER = R.REDO.FRONT.REQUESTS<FR.CM.CUST.ID.NUMBER>
            GOSUB CHECK.SELECTION
            IF Y.ERR.FLAG NE '1' THEN
                ID.VAL             = Y.SEL.REQ.ID
                Y.ID               = Y.CUSTOMER.ID
                Y.SHORT.NAME       = R.CUSTOMER<EB.CUS.SHORT.NAME>
                Y.CU.SEGMENTO      = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.SEGMENTO.POS>
                Y.ACCOUNT.OFFICER  = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
            END
            Y.DATE.TIME = R.REDO.FRONT.REQUESTS<FR.CM.DATE.TIME>
            Y.DATE.TIME = Y.DATE.TIME[1,6]
            Y.DATE.TIME = TODAY[1,2]:Y.DATE.TIME
            GOSUB FINAL.ARRAY
        END
* GOSUB FINAL.ARRAY
    REPEAT
RETURN
*****************
GET.COMP.VALUES:
*******************
    CALL EB.READLIST(SEL.COMP.CMD,SEL.COMP.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.COMP.ID FROM SEL.COMP.LIST SETTING SEL.COMP.POS
    WHILE Y.SEL.COMP.ID:SEL.COMP.POS
        CALL F.READ(FN.REDO.FRONT.COMPLAINTS.NAU,Y.SEL.COMP.ID,R.REDO.FRONT.COMPLAINTS,F.REDO.FRONT.COMPLAINTS.NAU,COMPLAINT.ERR)
        Y.RECORD.STATUS = R.REDO.FRONT.COMPLAINTS<FR.CM.RECORD.STATUS>
        IF Y.RECORD.STATUS EQ "IHLD" THEN
            Y.CUSTOMER.ID = R.REDO.FRONT.COMPLAINTS<FR.CM.CUSTOMER.CODE>
            Y.CASE.TYPE = R.REDO.FRONT.COMPLAINTS<FR.CM.TYPE>
            Y.CUST.ID.NUMBER = R.REDO.FRONT.COMPLAINTS<FR.CM.CUST.ID.NUMBER>
            GOSUB CHECK.SELECTION
            IF Y.ERR.FLAG NE '1' THEN
                ID.VAL             = Y.SEL.COMP.ID
                Y.ID               = Y.CUSTOMER.ID
                Y.SHORT.NAME       = R.CUSTOMER<EB.CUS.SHORT.NAME>
                Y.CU.SEGMENTO      = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.SEGMENTO.POS>
                Y.ACCOUNT.OFFICER  = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
            END
            Y.DATE.TIME = R.REDO.FRONT.COMPLAINTS<FR.CM.DATE.TIME>
            Y.DATE.TIME = Y.DATE.TIME[1,6]
            Y.DATE.TIME = TODAY[1,2]:Y.DATE.TIME
            GOSUB FINAL.ARRAY
        END
*GOSUB FINAL.ARRAY
    REPEAT
RETURN
****************
CHECK.SELECTION:
****************
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    Y.LEGAL.ID   = R.CUSTOMER<EB.CUS.LEGAL.ID>
    Y.CU.CIDENT  = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.CIDENT.POS>
    Y.CU.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.NOUNICO.POS>
    Y.CU.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.ACTANAC.POS>
    Y.CU.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.RNC.POS>
    IF Y.CUST.ID.NUMBER THEN
        IF Y.CUST.ID.NUMBER EQ Y.LEGAL.ID OR Y.CUST.ID.NUMBER EQ Y.CU.CIDENT OR Y.CUST.ID.NUMBER EQ Y.CU.NOUNICO OR Y.CUST.ID.NUMBER EQ Y.CU.ACTANAC OR Y.CUST.ID.NUMBER EQ Y.CU.RNC ELSE
            Y.ERR.FLAG = '1'
        END
    END
RETURN
************
FINAL.ARRAY:
************

    IF Y.ID NE '' THEN
        Y.FINAL.ARRAY<-1> = ID.VAL:"*":Y.CASE.TYPE:"*":Y.ID:"*":Y.SHORT.NAME:"*":Y.CU.SEGMENTO:"*":Y.ACCOUNT.OFFICER:"*":Y.DATE.TIME
    END
    Y.ERR.FLAG = '';Y.ID = ''; Y.SHORT.NAME = ''; Y.CASE.TYPE = '' ; Y.CU.SEGMENTO = ''; Y.ACCOUNT.OFFICER = ''; Y.DATE.TIME = '';ID.VAL = '';Y.CUST.ID.NUMBER = ''
RETURN
****************************************************
END
*-------------------------End of Program---------------------------------------------------------------------------
