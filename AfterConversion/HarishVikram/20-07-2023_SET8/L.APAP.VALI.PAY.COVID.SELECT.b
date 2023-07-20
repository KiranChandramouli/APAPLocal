* @ValidationCode : MjotMTY2NTAzODI2MTpDcDEyNTI6MTY4OTMxOTc3MjA2MDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 12:59:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.VALI.PAY.COVID.SELECT
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina SELECT Validar los pagos realizdos a los cotratos COVID19 con el monto de prelacion
* Logica: Lee todos los pagos realizados en el dia de las tablas (FBNK.AA.ARRANGEMENT.ACTIVITY,FBNK.FUNDS.TRASNFER)
* y va contra la tabla F.ST.L.APAP.COVI.PRELACIONIII
* y verifica si contrato se encuentra en esa tabla y tiene monto pendiente y le recta el valor que tenga
* monto pagado FT
* Developed By: APAP
* Date:  10122020
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.AA.PAYMENT.SCHEDULE
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.VALI.PAY.COVID.COMMON

    GOSUB PROCESS
RETURN

PROCESS:
********
    SEL.CMD = '' ; SEL.LIST = '' ; NO.OF.REC = '' ; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.AAA:" WITH EFFECTIVE.DATE EQ ":TODAY:" AND ACTIVITY EQ ":Y.ACTIVIDADES
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
