* @ValidationCode : MjoxMDk1NTEwMTUyOkNwMTI1MjoxNzAzMTYwMzAzNTYwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 17:35:03
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.CUS.UPD.FAX

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.CUS.UPD.FAX
*--------------------------------------------------------------------------------
* Description: This routine is for the local template which holds Id of Employee customer
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 02-12-2011      Jeeva T     For COB Performance
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB OPEN.FILE

RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
    FN.REDO.W.CUSTOMER.UPDATE = 'F.REDO.W.CUSTOMER.UPDATE'
    F.REDO.W.CUSTOMER.UPDATE = ''
    CALL OPF(FN.REDO.W.CUSTOMER.UPDATE,F.REDO.W.CUSTOMER.UPDATE)

    R.REDO.W.CUSTOMER.UPDATE = ''
    Y.FAX = ''
    Y.FAX = R.NEW(EB.CUS.FAX.1)

*CALL F.READ(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW,R.REDO.W.CUSTOMER.UPDATE,F.REDO.W.CUSTOMER.UPDATE,Y.ERR)
    CALL F.READU(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW,R.REDO.W.CUSTOMER.UPDATE,F.REDO.W.CUSTOMER.UPDATE,Y.ERR,'');*R22 MANUAL CODE CONVERSION

    IF NOT(R.REDO.W.CUSTOMER.UPDATE) AND Y.FAX THEN
        R.REDO.W.CUSTOMER.UPDATE<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW,R.REDO.W.CUSTOMER.UPDATE)
    END

    IF NOT(Y.FAX) AND R.REDO.W.CUSTOMER.UPDATE THEN
        CALL F.DELETE(FN.REDO.W.CUSTOMER.UPDATE,ID.NEW)
    END

RETURN
END
