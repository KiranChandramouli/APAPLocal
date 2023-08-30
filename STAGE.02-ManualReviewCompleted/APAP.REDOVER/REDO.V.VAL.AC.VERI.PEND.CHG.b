* @ValidationCode : MjoxNzQyMDI1NjM5OkNwMTI1MjoxNjgxMzcxNTk2MDM1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:09:56
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
SUBROUTINE REDO.V.VAL.AC.VERI.PEND.CHG
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*---------------------------------------------------------------------------------

*DESCRIPTION       :Account closure validation to check any pending charge exist.

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date        who                 Reference                         Description
* 23-JUL-2015   Prabhu.N            ODR-2010-11-0211                Initial Creation
*13-04-2023     Conversion Tool      R22 Auto Code conversion          No Changes
*13-04-2023     Samaran T            R22 Manual Code Conversion         No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.REDO.PENDING.CHARGE

    IF V$FUNCTION NE 'I'  THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
    FN.REDO.PENDING.CHARGE='F.REDO.PENDING.CHARGE'
    F.REDO.PENDING.CHARGE =''
    CALL OPF(FN.REDO.PENDING.CHARGE,F.REDO.PENDING.CHARGE)
RETURN

PROCESS:

    Y.ID.NEW=ID.NEW
    CALL F.READ(FN.REDO.PENDING.CHARGE,Y.ID.NEW,R.REDO.PENDING.CHARGE,F.REDO.PENDING.CHARGE,Y.ERR)
    IF R.REDO.PENDING.CHARGE THEN
        TEXT    = "REDO.ACCT.PEND.CHG"
        CURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),'VM') + 1
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
END
