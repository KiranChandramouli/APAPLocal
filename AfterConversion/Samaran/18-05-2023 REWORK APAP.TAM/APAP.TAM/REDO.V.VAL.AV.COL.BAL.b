* @ValidationCode : MjoxODgxOTg5MjAwOkNwMTI1MjoxNjg0NDA5NzUzMDMwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 17:05:53
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.AV.COL.BAL
*--------------------------------------------------------------------------
*Company Name: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program Name: REDO.V.VAL.AV.COL.BAL
*------------------------------------------------------------------------------------------------------------------
*Description:
*          This routine will update with the available collateral balance which can be used by the present loan
*-----------------------------------------------------------------------------------------------------------------
*Modification History:
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE             DESCRIPTION
* 29-06-2010      PREETHI MD    ODR-2009-10-0326 N.3  INITIAL CREATION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.TERM.AMOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------------------------

    FN.TERM.AMT="F.AA.ARR.TERM.AMOUNT"
    F.TERM.AMT = ''
    R.TERM.AMT=''
    CALL OPF(FN.TERM.AMT,F.TERM.AMT)
    Y.BAL.SUM=0

    LOC.APPL="AA.PRD.DES.TERM.AMOUNT"
    LOC.FIELD="L.AA.COL":@VM:"L.AA.COL.VAL":@VM:"L.AA.AV.COL.BAL" ;*R22 AUTO CONVERSION
    LOC.POS=''

RETURN
*--------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------

    CALL MULTI.GET.LOC.REF(LOC.APPL,LOC.FIELD,LOC.POS)

    Y.COL.POS=LOC.POS<1,1>
    Y.COLVAL.POS=LOC.POS<1,2>
    Y.COLBAL.POS=LOC.POS<1,3>

    Y.COLLATERAL.ID=R.NEW(AA.AMT.LOCAL.REF)<1,Y.COL.POS>

    SEL.CMD="SELECT ":FN.TERM.AMT:" WITH L.AA.COL EQ ":Y.COLLATERAL.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    LOOP
        REMOVE Y.TERM.ID FROM SEL.LIST SETTING POS1
    WHILE Y.TERM.ID:POS1

        CALL F.READ(FN.TERM.AMT,Y.TERM.ID,R.TERM.AMT,F.TERM.AMT,Y.ERR)
        Y.COL.VAL=R.TERM.AMT<AA.AMT.LOCAL.REF,Y.COLVAL.POS>
        Y.BAL.SUM+=Y.COL.VAL
    REPEAT

    Y.AMT=R.NEW(AA.AMT.AMOUNT)
    Y.DIFF=Y.BAL.SUM-Y.AMT

    R.NEW(AA.AMT.LOCAL.REF)<1,Y.COLBAL.POS>=Y.DIFF
    IF V$FUNCTION EQ 'I' THEN
        IF Y.DIFF LT '0' THEN
            TEXT = "AA.TERM.COL.BAL"
            CURR.NO = DCOUNT(R.NEW(AA.AMT.OVERRIDE),@VM) ;*R22 AUTO CONVERSION
            CALL STORE.OVERRIDE(CURR.NO+1)
        END
    END
RETURN
END
