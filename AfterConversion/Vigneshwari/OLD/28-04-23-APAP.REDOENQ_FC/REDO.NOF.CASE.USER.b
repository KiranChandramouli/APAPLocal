* @ValidationCode : MjoxOTE1MzYzNjg3OkNwMTI1MjoxNjgyNTc5MjM2NDYxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 12:37:16
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
SUBROUTINE REDO.NOF.CASE.USER(Y.FINAL.ARRAY)
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
*   02-06-2011       DHAMU S              PACS00024006         Initial Creation
*   09-03-2012       RIYAS J              PACS00185457         Initial Creation
*
* 17-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB OPEN
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    Y.CUST.CODE = ''; Y.CLIENT.ID = ''; Y.USER = ''; Y.DEPT.CODE = ''; Y.ACCT.OFFICER = ''; Y.CUST.VAL = '';
    CLIENT.ID.VAL = ''; Y.GIVEN.NAME = ''; Y.FAMILY.NAME = ''; Y.SOCIAL.NAME = ''; Y.NAME = ''; Y.TYPE = '';
    Y.SEGMENTO = ''; APL.ARRAY  = ''; APL.FIELD = '' ; FLD.POS = ''; LOC.L.CU.SEGMENTO.POS = '';

RETURN
******
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

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
********
PROCESS:
********
    LOCATE "APPLICATION" IN D.FIELDS<1> SETTING APL.POS THEN
        Y.APPL = D.RANGE.AND.VALUE<APL.POS>
        D.RANGE.AND.VALUE<APL.POS>=''
        D.LOGICAL.OPERANDS<APL.POS>=''
        D.FIELDS<APL.POS>=''
    END

    LOCATE "CUSTOMER.CODE" IN D.FIELDS<1> SETTING CUS.POS THEN
        Y.CUST.CODE = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "CUST.ID.NUMBER" IN D.FIELDS<1> SETTING CLIENT.POS THEN
        Y.CLIENT.ID = D.RANGE.AND.VALUE<CLIENT.POS>
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
**************
CHECK.CLAIMS:
*************
    FILE.NAME = FN.REDO.ISSUE.CLAIMS
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.CLAIM.CMD) ;*Manual R22 conversion
    
    GOSUB CLAIMS.GET.VALUES
RETURN
***************
CHECK.REQUESTS:
***************
    FILE.NAME = FN.REDO.ISSUE.REQUESTS
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.REQ.CMD) ;*Manual R22 conversion
    GOSUB REQUESTS.GET.VALUES
RETURN
*****************
CHECK.COMPLAINTS:
*****************
    FILE.NAME = FN.REDO.ISSUE.COMPLAINTS
    CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '',SEL.COMP.CMD) ;*Manual R22 conversion
    GOSUB COMPLAINTS.GET.VALUES
RETURN
********************
CLAIMS.GET.VALUES:
*****************
    CALL EB.READLIST(SEL.CLAIM.CMD,SEL.CLAIM.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.CLAIM.ID FROM SEL.CLAIM.LIST SETTING SEL.CLAIM.POS
    WHILE Y.SEL.CLAIM.ID:SEL.CLAIM.POS
        Y.DEPT.CODE = R.USER<EB.USE.DEPARTMENT.CODE>
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.SEL.CLAIM.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CLAIMS.ERR)
        Y.CUST.VAL    = R.REDO.ISSUE.CLAIMS<ISS.CL.CUSTOMER.CODE>
        CALL F.READ(FN.CUSTOMER,Y.CUST.VAL,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        Y.ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
        IF Y.ACCT.OFFICER EQ Y.DEPT.CODE THEN
            CLIENT.ID.VAL = R.REDO.ISSUE.CLAIMS<ISS.CL.CUST.ID.NUMBER>
            Y.GIVEN.NAME  = R.REDO.ISSUE.CLAIMS<ISS.CL.GIVEN.NAMES>
            Y.FAMILY.NAME = R.REDO.ISSUE.CLAIMS<ISS.CL.FAMILY.NAMES>
            Y.SOCIAL.NAME = R.REDO.ISSUE.CLAIMS<ISS.CL.SOCIAL.NAME>
            IF Y.GIVEN.NAME NE ''  OR Y.FAMILY.NAME NE '' OR (Y.GIVEN.NAME NE '' AND Y.FAMILY.NAME NE '') THEN
                Y.NAME = Y.GIVEN.NAME:' ':Y.FAMILY.NAME
            END
            IF Y.GIVEN.NAME EQ '' AND Y.FAMILY.NAME EQ '' THEN
                Y.NAME = Y.SOCIAL.NAME
            END
            Y.ID = Y.SEL.CLAIM.ID
            Y.TYPE = R.REDO.ISSUE.CLAIMS<ISS.CL.TYPE>
            Y.SEGMENTO = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.SEGMENTO.POS>
            GOSUB FINAL.ARRAY
        END
    REPEAT
RETURN
********************
REQUESTS.GET.VALUES:
********************

    CALL EB.READLIST(SEL.REQ.CMD,SEL.REQ.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.REQ.ID FROM SEL.REQ.LIST SETTING SEL.REQ.POS
    WHILE Y.SEL.REQ.ID:SEL.REQ.POS
        Y.DEPT.CODE = R.USER<EB.USE.DEPARTMENT.CODE>
        CALL F.READ(FN.REDO.ISSUE.REQUESTS,Y.SEL.REQ.ID,R.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS,REQUESTS.ERR)
        Y.CUST.VAL    = R.REDO.ISSUE.REQUESTS<ISS.REQ.CUSTOMER.CODE>
        CALL F.READ(FN.CUSTOMER,Y.CUST.VAL,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        Y.ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
        IF Y.ACCT.OFFICER EQ Y.DEPT.CODE THEN
            CLIENT.ID.VAL  = R.REDO.ISSUE.REQUESTS<ISS.REQ.CUST.ID.NUMBER>
            Y.GIVEN.NAME   = R.REDO.ISSUE.REQUESTS<ISS.REQ.GIVEN.NAMES>
            Y.FAMILY.NAME  = R.REDO.ISSUE.REQUESTS<ISS.REQ.FAMILY.NAMES>
            Y.SOCIAL.NAME  = R.REDO.ISSUE.REQUESTS<ISS.REQ.SOCIAL.NAME>
            IF Y.GIVEN.NAME NE ''  OR Y.FAMILY.NAME NE '' OR (Y.GIVEN.NAME NE '' AND Y.FAMILY.NAME NE '') THEN
                Y.NAME = Y.GIVEN.NAME:' ':Y.FAMILY.NAME
            END
            IF Y.GIVEN.NAME EQ '' AND Y.FAMILY.NAME EQ '' THEN
                Y.NAME = Y.SOCIAL.NAME
            END
            Y.ID = Y.SEL.REQ.ID
            Y.TYPE = R.REDO.ISSUE.REQUESTS<ISS.REQ.TYPE>
            Y.RECORD.STATUS = R.REDO.ISSUE.REQUESTS<ISS.REQ.RECORD.STATUS>
            Y.SEGMENTO = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.SEGMENTO.POS>
            GOSUB FINAL.ARRAY
        END
    REPEAT
RETURN
**********************
COMPLAINTS.GET.VALUES:
**********************
    CALL EB.READLIST(SEL.COMP.CMD,SEL.COMP.LIST,'',NO.OF.REC,REC.ERR)
    LOOP
        REMOVE Y.SEL.COMP.ID FROM SEL.COMP.LIST SETTING SEL.COMP.POS
    WHILE Y.SEL.COMP.ID:SEL.COMP.POS
        Y.DEPT.CODE = R.USER<EB.USE.DEPARTMENT.CODE>
        CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,Y.SEL.COMP.ID,R.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS,COMPLAINT.ERR)
        Y.CUST.VAL    = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CUSTOMER.CODE>
        CALL F.READ(FN.CUSTOMER,Y.CUST.VAL,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        Y.ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
        IF Y.ACCT.OFFICER EQ Y.DEPT.CODE THEN
            CLIENT.ID.VAL   = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CUST.ID.NUMBER>
            Y.GIVEN.NAME    = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.GIVEN.NAMES>
            Y.FAMILY.NAME   = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.FAMILY.NAMES>
            Y.SOCIAL.NAME   = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SOCIAL.NAME>
            IF Y.GIVEN.NAME NE ''  OR Y.FAMILY.NAME NE '' OR (Y.GIVEN.NAME NE '' AND Y.FAMILY.NAME NE '') THEN
                Y.NAME = Y.GIVEN.NAME:' ':Y.FAMILY.NAME
            END
            IF Y.GIVEN.NAME EQ '' AND Y.FAMILY.NAME EQ '' THEN
                Y.NAME = Y.SOCIAL.NAME
            END
            Y.ID = Y.SEL.COMP.ID
            Y.TYPE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.TYPE>
            Y.SEGMENTO = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.SEGMENTO.POS>
            GOSUB FINAL.ARRAY
        END
    REPEAT
RETURN
**************
GET.LOCAL.REF:
**************
    APL.ARRAY = 'CUSTOMER'
    APL.FIELD = 'L.CU.SEGMENTO'
    FLD.POS   = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.CU.SEGMENTO.POS = FLD.POS<1,1>
RETURN
************
FINAL.ARRAY:
************
    Y.FINAL.ARRAY<-1> = Y.ID:"*":Y.CUST.VAL:"*":CLIENT.ID.VAL:"*":Y.NAME:"*":Y.TYPE:"*":Y.SEGMENTO
    Y.CUST.VAL = ''; CLIENT.ID.VAL = '';Y.NAME = ''; Y.TYPE = ''; Y.SEGMENTO = ''
RETURN
***********************************
END
*--------------End of Program----------------------------------------------
