* @ValidationCode : MjoxMDY5OTQ1MjQ6Q3AxMjUyOjE2ODQ0OTEwMzExNjE6SVRTUzotMTotMTo0MDA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 400
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHQ.STOP.AUTO.ACCOUNT.NUMBER
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This is the auto new contevt routine to populate the value of Account number
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-oct-2011   Riyas ahamad Basha   ODR-2009-10-0331      Initial Creation
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CHEQUE.TYPE.ACCOUNT
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT = ''
    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)
    FN.CHEQUE.TYPE.ACCOUNT = "F.CHEQUE.TYPE.ACCOUNT"
    F.CHEQUE.TYPE.ACCOUNT = ""
    CALL OPF(FN.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT)

    Y.FINAL.ID = FIELD(ID.NEW,'.',1)
    R.NEW(REDO.PS.ACCT.ACCOUNT.NUMBER) = Y.FINAL.ID
    CALL F.READ(FN.CHEQUE.TYPE.ACCOUNT,Y.FINAL.ID,R.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT,ACC.ERR)

    Y.CHEQUE.TYPE = R.CHEQUE.TYPE.ACCOUNT<CHQ.TYP.CHEQUE.TYPE>
    R.NEW(REDO.PS.ACCT.CHEQUE.TYPE) = Y.CHEQUE.TYPE

END
