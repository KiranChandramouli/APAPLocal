* @ValidationCode : MjotMTI0MjU5ODIzNzpDcDEyNTI6MTY4MjQxMjM1NzAyNDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:57
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
SUBROUTINE REDO.V.VAL.CARD.CHARGE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*------------------------------------------------------------------------------

*Description  : This routine is validation routine attached to version CARD.TYPE,REDO.CARD.TYPE to validate bin nu
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : CARD.TYPE

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11-09-2010     SWAMINATHAN            ODR-2010-03-0400          Initial Creation
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
 
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.TYPE


    L.REF.APPL = 'CARD.TYPE'
    L.REF.FIELDS = 'L.CT.CHARGE'
    L.REF.POS = ''
    CALL MULTI.GET.LOC.REF(L.REF.APPL,L.REF.FIELDS,L.REF.POS)
    Y.L.CT.CHARGE.POS = L.REF.POS<1,1>
    Y.CHARGE = R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.CHARGE.POS>
    Y.VALUE = FMT(Y.CHARGE,"R2,#15")
    R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.CHARGE.POS> = Y.VALUE
RETURN
END
