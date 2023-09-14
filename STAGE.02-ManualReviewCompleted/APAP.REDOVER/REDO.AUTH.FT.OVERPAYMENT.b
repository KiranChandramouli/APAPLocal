* @ValidationCode : MjoxOTczMjI4MTQ1OkNwMTI1MjoxNjgwNjgyMzgxNzk5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:43:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.FT.OVERPAYMENT
*-------------------------------------------------
* Description: This FT auth routine is to update the ref of FT Txn
*             in REDO.AA.OVERPAYMENT.
*-------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023          Samaran T            Manual R22 Code Conversion      No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.AA.OVERPAYMENT

    GOSUB PROCESS
RETURN

*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT  = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)


    Y.REF.ID = R.NEW(FT.ORDERING.CUST)

    CALL F.READU(FN.REDO.AA.OVERPAYMENT,Y.REF.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,Y.ERR.QTY,'')
    R.REDO.AA.OVERPAYMENT<REDO.OVER.FT.TXN.REFS,-1> = ID.NEW
    CALL F.WRITE(FN.REDO.AA.OVERPAYMENT,Y.REF.ID,R.REDO.AA.OVERPAYMENT)

RETURN

END
