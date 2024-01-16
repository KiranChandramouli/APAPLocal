* @ValidationCode : MjoxNjIxOTc3NTA0OkNwMTI1MjoxNzAwODQyNjY1NzAwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------

$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CUST.CHECK.RELATION
***********************************************************************
*----------------------------------------------------------------------
* Company Name : APAP
* Developed By : Ftrinidad
* Program Name : LAPAP.CUST.CHECK.RELATION
*----------------------------------------------------------------------
* Description: Esta rutina valida que el CODE.RELATION para un VINCULADOS
* sea diferente de 17 y 18
* Linked with   : Version CUSTOMER,L.APAP.BE.CLIENTE.ME.MOD
*                         CUSTOMER,L.APAP.BE.CLIENTE.PF.MOD
*                         CUSTOMER,L.APAP.BE.CLIENTE.PJ.MOD as Input routine
* In Parameter  : None
* Out Parameter : None
*------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*24/11/2023         Suresh             R22 Manual Conversion             T24.BP File Removed
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Manual Conversion
    $INSERT I_EQUATE ;*R22 Manual Conversion
    $INSERT I_F.CUSTOMER ;*R22 Manual Conversion

    GOSUB CHECKING.RELATION.CODE
RETURN
  
*----------------------------------------------------------------------------
* Relation code is checked to find whether it is in the range of 17 to 18
*----------------------------------------------------------------------------
CHECKING.RELATION.CODE:

    REL.NEW = R.NEW(EB.CUS.RELATION.CODE)
    NEW.CNT.VAL = DCOUNT(REL.NEW,@VM)

    CONVERT @VM TO @FM IN REL.NEW

    FOR I = 1 TO NEW.CNT.VAL
        POS=''
        IF REL.NEW<I> EQ 17 OR REL.NEW<I> EQ 18 THEN
            GOSUB SHOW.ERROR
        END
    NEXT I

RETURN
  
*-------------------------------------------------
* Dispara el Siguiente Error:

*-------------------------------------------------
SHOW.ERROR:
  
    OVERRIDE.FIELD.VALUE = R.NEW(EB.CUS.OVERRIDE)
    CURR.NO = DCOUNT(OVERRIDE.FIELD.VALUE,'VM') + 1
    AF = EB.CUS.RELATION.CODE
    TEXT = 'LAPAP.CUST.CHECK.RELATION' : @FM : ' Diferente de 17 o 18'
    CALL STORE.OVERRIDE(CURR.NO)

  
    GOSUB ROUTINE.END

ROUTINE.END:
END
