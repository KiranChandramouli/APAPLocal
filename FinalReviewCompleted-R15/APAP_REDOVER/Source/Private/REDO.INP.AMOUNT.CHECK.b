* @ValidationCode : MjoxMzYwMTQwNzAyOkNwMTI1MjoxNjgyNDEyMzI5ODU5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.AMOUNT.CHECK
*--------------------------------------------------
* This routine is to check the amount entered in the local field
* is same as the amount of cheque.
*--------------------------------------------------

*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*--------------------------------------------------
OPENFILES:
*--------------------------------------------------

    LOC.REF.APPLICATION   = "FUNDS.TRANSFER"
    LOC.REF.FIELDS        = 'L.COMMENTS'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.COMMENTS = LOC.REF.POS<1,1>

RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------
    Y.CHEQUE.AMOUNT = R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS>
    Y.DEBIT.AMOUNT  = R.NEW(FT.DEBIT.AMOUNT)

    IF Y.CHEQUE.AMOUNT NE Y.DEBIT.AMOUNT THEN
        AF = FT.DEBIT.AMOUNT
        ETEXT = 'EB-REDO.AMT.MISSMATCH'
        CALL STORE.END.ERROR
    END

RETURN
END
