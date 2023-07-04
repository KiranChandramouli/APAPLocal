* @ValidationCode : MjoxMDY1MzIxMDA1OkNwMTI1MjoxNjgxMjgzOTMzNTg2OklUU1M6LTE6LTE6NDgxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 481
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACH.INW.ALT.ACCT.CUS

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
*            New Development
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------
PROCESS:


    CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF NOT(R.ACCOUNT) THEN
        CALL F.READ(FN.ALT.ACCT,COMI,R.ALT.ACCT,F.ALT.ACCT,ALT.ACCT.ERR)
        IF R.ALT.ACCT THEN
            Y.AC.ID = R.ALT.ACCT
            CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
            COMI = R.ACCOUNT<AC.CUSTOMER>
        END
    END ELSE
        COMI = R.ACCOUNT<AC.CUSTOMER>
    END


RETURN
*-----------------------------------------------------------------------------------
INITIALISE:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''

    FN.ALT.ACCT = 'F.ALTERNATE.ACCOUNT'
    F.ALT.ACCT  = ''
RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ALT.ACCT,F.ALT.ACCT)

RETURN

*-----------------------------------------------------------------------------------

END
