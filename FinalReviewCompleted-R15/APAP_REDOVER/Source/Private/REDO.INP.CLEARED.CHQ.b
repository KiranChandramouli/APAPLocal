* @ValidationCode : MjoxMzI2NjAzMTM6Q3AxMjUyOjE2ODI0MTIzMzEwMTY6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CLEARED.CHQ
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.INP.CLEARED.CHQ
*-------------------------------------------------------------------------
* Description: This routine is a Auto New Content routine
*
*----------------------------------------------------------
* Linked with:  FUNDS.TRANSFER,CH.RTN
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
*Modification History
*DATE                      WHO                          REFERENCE            DESCRIPITION
*06-04-2023           Conversion Tool          R22 Auto Code conversion      VM TO @VM
*06-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
*-------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.CLEARING.OUTWARD

    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files

    FN.REDO.OUTWARD.CLEARING = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.OUTWARD.CLEARING = ''
    CALL OPF(FN.REDO.OUTWARD.CLEARING,F.REDO.OUTWARD.CLEARING)

RETURN

PROCESS:

*Get the Payment Details

    VAR.PAY.DETAILS = R.NEW(FT.PAYMENT.DETAILS)

* Read REDO.CLEARING.OUTWARD and get the status and raise the override

    CALL F.READ(FN.REDO.OUTWARD.CLEARING,VAR.PAY.DETAILS,R.REDO.OUTWARD.CLEARING,F.REDO.OUTWARD.CLEARING,OUTWARD.ERR)
    VAR.CHQ.STATUS = R.REDO.OUTWARD.CLEARING<CLEAR.OUT.CHQ.STATUS>
    IF VAR.CHQ.STATUS EQ "CLEARED" THEN
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = "CLEARED.CHEQUE"
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
END
