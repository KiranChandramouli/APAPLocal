* @ValidationCode : MjotNDAxNjkxOTA1OkNwMTI1MjoxNjg2MjA0NjY3NDM4OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Jun 2023 11:41:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.COB.PENDING
*----------------------------------------------------------------------------------------------------
* Description           : Rutina MAIN para Habilitar autorización al servicio del COB de T24
*
* Developed On          : 15-02-2022
* Developed By          : APAP
* Development Reference : MDR-1381
*----------------------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 08-JUNE-2023     Santosh         R22 Manual Conversion - Removed BP from inserts
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION
    $INSERT I_F.TSA.SERVICE
    GOSUB MAIN.PROCESS
RETURN


MAIN.PROCESS:
    Y.ID = ID.NEW
*Y.CURR.NO= DCOUNT(R.NEW(TS.TSM.CURR.NO),VM)
    Y.CURR.NO=0
    IF Y.ID EQ 'COB'  AND V$FUNCTION EQ 'I' THEN
*TEXT = "EL COB REQUIERE AUTORIZACION DE OTRO USUARIO"
*TEXT = "L.APAP.REPRECIO.OVR.MSG"
        R.VERSION(EB.VER.NO.OF.AUTH) = 1
*CALL STORE.OVERRIDE(Y.CURR.NO)
    END

RETURN
