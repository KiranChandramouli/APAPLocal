* @ValidationCode : MjotMTQ0NTAxNzI2NjpVVEYtODoxNjkwMTY3NTUyMzY5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:12
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.SRV.48H.CUS.INFO.RT.SELECT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 17-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
*-----------------------------------------------------------------------------

    $INSERT  I_COMMON ;*R22 Manual Conversion - START
    $INSERT  I_EQUATE
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.ST.LAPAP.MOD.DIRECCIONES
    $INSERT  I_SRV.48H.COMMON ;*R22 Manual Conversion - END

    GOSUB DO.SELECT
RETURN

DO.SELECT:

*SEL.CMD = "SELECT ":FN.DIR:" WITH ESTADO EQ 'PENDIENTE' AND FECHA LE " : PROCESS.DATE
    SEL.CMD = "SELECT ":FN.DIR:" WITH ESTADO EQ 'PENDIENTE' AND FECHA.P.APLICAR EQ " : PROCESS.DATE
    CALL EB.READLIST(SEL.CMD,CHANGE.LIST,'',NO.REC,PGM.ERR)

    CALL OCOMO("Total of records to process " : NO.REC)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,CHANGE.LIST)



RETURN

END
