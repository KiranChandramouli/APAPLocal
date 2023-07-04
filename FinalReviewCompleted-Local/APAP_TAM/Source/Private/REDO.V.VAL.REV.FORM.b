* @ValidationCode : MjoxMjgwNTExNjM4OkNwMTI1MjoxNjg0NDkxMDQ3MjU4OklUU1M6LTE6LTE6LTE1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.REV.FORM
*-----------------------------------------------------------------------------
* Company Name: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name: REDO.V.VAL.REV.FORM
*-----------------------------------------------------------------------------
* Description:
*       This is a validation routine used to make the local ref field form of
* review and first review rate date to be mandatory if the type of review is periodic
*-----------------------------------------------------------------------------
*Modification History:
*------------------------------------------------------------------------------
*DATE             WHO         REFERENCE             DESCRIPTION
*29-06-2010      PREETHI MD    ODR-2009-10-0326 N.3  INITIAL CREATION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST

    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------

    APPL.ARRAY="AA.PRD.DES.INTEREST"
    FLD.ARRAY='L.AA.REV.RT.TY':@VM:'L.AA.REV.FORM' ;*R22 AUTO CONVERSION
    FLD.POS=''

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.TYPE.POS=FLD.POS<1,1>
    Y.FORM.POS=FLD.POS<1,2>

    Y.REV.TY=R.NEW(AA.INT.LOCAL.REF)<1,Y.TYPE.POS>
    Y.FORM=R.NEW(AA.INT.LOCAL.REF)<1,Y.FORM.POS>

    IF Y.REV.TY EQ "PERIODICO" THEN
        IF Y.FORM EQ "" THEN
            AF=AA.INT.LOCAL.REF
            AV=Y.FORM.POS
            ETEXT="AA-REVIEW.FORM"
            CALL  STORE.END.ERROR
        END
    END

RETURN

END
