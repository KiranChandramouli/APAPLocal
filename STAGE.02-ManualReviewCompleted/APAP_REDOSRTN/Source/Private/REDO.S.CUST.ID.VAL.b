* @ValidationCode : MjoxOTY5MTM5NzM5OkNwMTI1MjoxNjgyNDE1MTM5MDc3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.CUST.ID.VAL(CUST.ID,CUST.NO,CUS.ERR)
*---------------------------------------------------------------------------------
*This is an call routine to check the customer number.
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : Pradeep S
* Program Name  :
* ODR NUMBER    :
* HD Reference  : PACS00071941
*LINKED WITH:
*----------------------------------------------------------------------
*Input param = CUST.ID
*output param = CUST.NO and CUS.ERR
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
* Date              Who              Reference      Description
* 31-05-2011        Pradeep S        PACS00071941   Initial Creation
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FRONT.REQUESTS
    $INSERT I_REDO.SET.REQ.COMP.ID

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*-----------
OPEN.FILES:
*-----------
    FN.CUST = 'F.CUSTOMER'
    F.CUST = ''
    CALL OPF(FN.CUST,F.CUST)

    FN.CUST.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUST.CIDENT = ''
    CALL OPF(FN.CUST.CIDENT,F.CUST.CIDENT)

    FN.CUST.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUST.RNC = ''
    CALL OPF(FN.CUST.RNC,F.CUST.RNC)

RETURN

*--------
PROCESS:
*--------

    Y.ID.CHK = CUST.ID

    R.CUST = ''
    CALL F.READ(FN.CUST,Y.ID.CHK,R.CUST,F.CUST,E.CUS.ERR)
    IF R.CUST THEN
        CUST.NO = Y.ID.CHK
        CUS.ERR = @FALSE
    END ELSE
        GOSUB CHK.CIDENT
    END

RETURN

*-----------
CHK.CIDENT:
*-----------

    R.CIDENT = ''
    CALL F.READ(FN.CUST.CIDENT,Y.ID.CHK,R.CIDENT,F.CUST.CIDENT,E.CID.ERR)
    IF R.CIDENT THEN
        CUST.NO = FIELD(R.CIDENT,"*",2)
        CUS.ERR = @FALSE
    END ELSE
        GOSUB CHK.RNC
    END

RETURN

*--------
CHK.RNC:
*--------

    R.RNC = ''
    CALL F.READ(FN.CUST.RNC,Y.ID.CHK,R.RNC,F.CUST.RNC,E.RNC.ERR)
    IF R.RNC THEN
        CUST.NO = FIELD(R.RNC,"*",2)
        CUS.ERR = @FALSE
    END ELSE
        CUS.ERR = @TRUE
    END

RETURN

END
