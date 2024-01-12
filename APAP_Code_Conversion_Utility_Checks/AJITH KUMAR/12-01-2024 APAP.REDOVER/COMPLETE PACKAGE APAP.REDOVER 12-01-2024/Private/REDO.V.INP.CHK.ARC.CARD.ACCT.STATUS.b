* @ValidationCode : MjozMTQ0ODEwNDY6Q3AxMjUyOjE3MDQzNjQ5NzI0MDA6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jan 2024 16:12:52
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
SUBROUTINE REDO.V.INP.CHK.ARC.CARD.ACCT.STATUS
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.INP.CHK.CARD.ACCT.STATUS
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
*2-5-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*2-5-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.SUNNEL.PARAMETER

    FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'

    LREF.APP = 'FUNDS.TRANSFER'
    LREF.FIELDS ='L.FT.AC.STATUS'
    LREF.POS=''

    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.CARD.ACCT.ST=R.NEW(FT.LOCAL.REF)<1,LREF.POS>
*CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,IDVAR.1,R.REDO.SUNNEL.PARAMETER,ERR);* R22 AUTO CONVERSION
    Y.STATUS<1>=R.REDO.SUNNEL.PARAMETER<SP.LEGAL.STATUS>
    Y.STATUS<2>=R.REDO.SUNNEL.PARAMETER<SP.DECEASED.ST>
    Y.STATUS<3>=R.REDO.SUNNEL.PARAMETER<SP.CLOSED.STATUS>

    IF Y.CARD.ACCT.ST EQ Y.STATUS<1> THEN
        CURR.NO=DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1 ;*R22 AUTO CONVERSION
        TEXT='REDO.LEGAL.STATUS'
        CALL STORE.OVERRIDE(CURR.NO)
    END
    IF Y.CARD.ACCT.ST EQ Y.STATUS<2> THEN
        AF = FT.LOCAL.REF
        AV = LREF.POS
        ETEXT="EB-REDO.CARD.CLOSED"
        CALL STORE.END.ERROR
    END
    IF Y.CARD.ACCT.ST EQ Y.STATUS<3> THEN
        AF = FT.LOCAL.REF
        AV = LREF.POS
        ETEXT="EB-REDO.CARD.CLOSED"
        CALL STORE.END.ERROR
    END
RETURN
END
