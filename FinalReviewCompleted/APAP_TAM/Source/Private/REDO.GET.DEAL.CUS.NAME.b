* @ValidationCode : MjotOTkyNzYxNzkyOkNwMTI1MjoxNjgzODkyNjIzNjUyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.DEAL.CUS.NAME(Y.NAME.PART)
*---------------------------------------------------------
* Description: This routine is to get the customer name based on type
* and return to deal slip based on argument.
*---------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $USING APAP.REDORETAIL

    GOSUB PROCESS
RETURN
*---------------------------------------------------------
PROCESS:
*---------------------------------------------------------
    Y.FIELD.NAME = Y.NAME.PART
    Y.NAME.PART  = ''
    R.ACCOUNT    = ''
    Y.CUS.ID     = ''


* Below position are obtained so that we can use it accross various deal slip.

    Y.CUS.POS   = FIELD(Y.FIELD.NAME,'*',2)         ;* Customer Id position in that application.
    Y.ACC.POS   = FIELD(Y.FIELD.NAME,'*',3)         ;* Customer Id position in that application.
    Y.NAME.LEN  = FIELD(Y.FIELD.NAME,'*',4)         ;* No of char to be displayed in each line.
    Y.NEXT.LEN  = FIELD(Y.FIELD.NAME,'*',5)         ;* Position of next line.
    BEGIN CASE
        CASE Y.CUS.POS EQ '' AND Y.ACC.POS EQ ''
            RETURN
        CASE Y.CUS.POS NE '' AND Y.ACC.POS EQ ''
            Y.CUS.ID = R.NEW(Y.CUS.POS)
        CASE Y.CUS.POS EQ '' AND Y.ACC.POS NE ''
            Y.ACC.ID = R.NEW(Y.ACC.POS)
            GOSUB GET.CUSTOMER.ID
        CASE Y.CUS.POS NE '' AND Y.ACC.POS NE ''
            Y.CUS.ID = R.NEW(Y.CUS.POS)
    END CASE

    IF Y.CUS.ID EQ '' THEN
        IF R.ACCOUNT THEN
            Y.CUS.NAME = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
            GOSUB FORMAT.NAME
        END
        RETURN
    END

*CALL REDO.CUST.IDENTITY.REF(Y.CUS.ID,Y.ALT.ID,Y.CUS.NAME)
** R22 Manual conversion
    APAP.REDORETAIL.redoCustIdentityRef(Y.CUS.ID,Y.ALT.ID,Y.CUS.NAME) ;*R22 Manual Conversion
    GOSUB FORMAT.NAME

RETURN
*---------------------------------------------------
FORMAT.NAME:
*---------------------------------------------------

    IF LEN(Y.CUS.NAME) GT Y.NAME.LEN  THEN
        Y.NAME.PART = Y.CUS.NAME[1,Y.NAME.LEN]:@VM:SPACE(Y.NEXT.LEN):Y.CUS.NAME[Y.NAME.LEN,LEN(Y.CUS.NAME)]
    END ELSE
        Y.NAME.PART = Y.CUS.NAME
    END
RETURN
*---------------------------------------------------
GET.CUSTOMER.ID:
*---------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUS.ID = R.ACCOUNT<AC.CUSTOMER>

RETURN
END
