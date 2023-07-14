* @ValidationCode : MjotNTExMTU1NzQ1OkNwMTI1MjoxNjgxODgyOTkyNDI1OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:13:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.RESIDUAL
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to display the field values based upon the users selection in residual mode
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.MULTI.TRANSACTION.PARAMETER
    $INSERT I_F.TELLER.ID

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*--------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.MULTI.TRANSACTION.PARAMETER = 'F.MULTI.TRANSACTION.PARAMETER'
    F.MULTI.TRANSACTION.PARAMETER = ''
    CALL OPF(FN.MULTI.TRANSACTION.PARAMETER,F.MULTI.TRANSACTION.PARAMETER)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
RETURN

*-----------
PROCESS:

    Y.RESIDUAL.VAL = COMI
    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
    IF Y.OPERATION EQ 'REPAYMENT' THEN
        IF Y.RESIDUAL.VAL EQ 'NO' THEN
            T(REDO.MTS.RESIDUAL.MODE)<3> = 'NOINPUT'
        END

        Y.TYPE = R.NEW(REDO.MTS.SETTLEMENT.TYPE)
        Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
        IF Y.TYPE EQ 'MULTIPLE' THEN
            T(REDO.MTS.ARRANGEMENT.ID)<3> = 'NOINPUT'
        END
    END
RETURN
END
